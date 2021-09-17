import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


export const onStoryCreated =
functions.firestore.document("stories/{storyId}").onCreate(
    async (snapshot, context) => {
      const data = snapshot.data();

      const uid: string = data.createdBy;
      const documentSnapshot =
            await db.collection("user_followers_stories").doc(uid).get();

      // todo @low longterm this document can get full
      if (documentSnapshot.exists) {
        const storyId: string = context.params.storyId;
        return documentSnapshot.ref.update({
          "storiesIds": admin.firestore.FieldValue.arrayUnion(
              {
                "storyId": storyId,
                "createdAt": data.createdAt,
                "type": data.type,
              }
          ),
          "lastStoryTimestamp": data.createdAt,
        });
      } else {
        return null;
      }
    }
);
