import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {Storage} from "@google-cloud/storage";


if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();
const storage = new Storage();
const bucket = storage.bucket("randolina-10bf4.appspot.com");


export const storyMonitor = functions.pubsub
    .schedule("every 4 hours").onRun(async () => {
      const now = admin.firestore.Timestamp.now();

      // 24 hours in milliseconds = 86400000
      // 3 min in milliseconds = 180000
      const ts = admin.firestore.Timestamp.
          fromMillis(now.toMillis() - 86400000 );

      const snap = await db.collection("stories")
          .where("createdAt", "<", ts).get();

      console.log(snap.docs.length);

      const promises :Promise<FirebaseFirestore.WriteResult>[] = [];


      snap.forEach(async (snap) => {
        const snap2 = await db.collection("user_followers_stories")
            .doc(snap.data().createdBy).get();
        const storiesIds: {
            createdAt: admin.firestore.Timestamp,
            storyId: string,
            type: number,
        }[] = snap2.data()?.storiesIds;

        for (let i = 0; i <storiesIds.length; i++) {
          if (storiesIds[0].storyId == snap.id) {
            const path =`users/${snap.data().createdBy}/stories/${snap.id}`;

            await bucket.file(path).delete();

            promises.push(snap.ref.delete());
            promises.push(snap2.ref.update({
              "storiesIds": admin.firestore.FieldValue.arrayRemove(
                  {
                    "storyId": storiesIds[0].storyId,
                    "createdAt": storiesIds[0].createdAt,
                    "type": storiesIds[0].type,
                  }
              ),
            }));
            break;
          }
        }
      });
      return Promise.all(promises);
    });
