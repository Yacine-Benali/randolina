import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


export const onPostCreated =
    functions.firestore.document("posts/{postId}").onCreate(
        async (snapshot, context) => {
          const data = snapshot.data();

          const uid: string = data.miniUser.id;
          const querySnapshot =
            await db.collection("user_followers_posts").where("id", "==", uid).
                where("length", "<", 10000).get();

          if (querySnapshot.docs.length > 0) {
            const postId: string = context.params.postId;
            return querySnapshot.docs[0].ref.update({
              "postsIds": admin.firestore.FieldValue.arrayUnion(
                  {
                    "postId": postId,
                    "createdAt": data.createdAt,
                  }
              ),
              "length": admin.firestore.FieldValue.increment(1),
              "lastPostTimestamp": data.createdAt,
            });
          } else {
            return db.collection("user_followers_posts").add(
                {
                  "followers": [],
                  "id": uid,
                  "lastPostTimestamp": null,
                  "length": 0,
                  "postsIds": data["postsIds"],

                }
            );
          }
        }
    );
