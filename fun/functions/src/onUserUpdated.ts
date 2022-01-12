/* eslint-disable @typescript-eslint/no-unused-vars */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import algoliasearch from "algoliasearch";
if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


export const onUserUpdated = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (snapshot, context) => {
      const userId = context.params.userId;
      const dataBefore = snapshot.before.data();
      const dataAfter = snapshot.after.data();

      const oldMiniUser = {
        id: userId,
        profilePicture: dataBefore.profilePicture,
        name: dataBefore.name,
        username: dataBefore.username,
      };

      const newMiniUser = {
        id: userId,
        profilePicture: dataAfter.profilePicture,
        name: dataAfter.name,
        username: dataAfter.username,
      };
      if (oldMiniUser.profilePicture!= newMiniUser.profilePicture) {
        const batch = db.batch();

        // updating miniUser on posts
        const querySnapshot1 =await db.collection("posts")
            .where("miniUser.id", "==", userId).get();

        // updating miniUser on conversations
        const querySnapshot2 =await db.collection("conversations")
            .where("usersIds", "array-contains", userId).get();

        // updating miniUser on user_followers_stories
        const querySnapshot3 =await db.collection("user_followers_stories")
            .where("miniUser.id", "==", userId).get();

        // updating miniUser on events
        const querySnapshot4 =await db.collection("events")
            .where("createdBy.id", "==", userId).get();

        // updating miniUser on comments
        const querySnapshot5 =await db.collectionGroup("comments")
            .where("miniUser.id", "==", userId).get();

        // if store
        if (dataAfter.type == 3) {
          const querySnapshot6 =await db.collectionGroup("products")
              .where("createdBy.id", "==", userId).get();
          querySnapshot6.docs.forEach((doc)=>{
            batch.update(doc.ref, {"createdBy": newMiniUser});
          });
          console.log("updating store products");
        }


        querySnapshot1.docs.forEach((doc)=>{
          batch.update(doc.ref, {"miniUser": newMiniUser});
        });

        querySnapshot2.docs.forEach((doc)=>{
          if (doc.data().user1.id == userId) {
            batch.update(doc.ref, {"user1": newMiniUser});
          } else {
            batch.update(doc.ref, {"user2": newMiniUser});
          }
        });

        querySnapshot3.docs.forEach((doc)=>{
          batch.update(doc.ref, {"miniUser": newMiniUser});
        });


        querySnapshot4.docs.forEach((doc)=>{
          batch.update(doc.ref, {"createdBy": newMiniUser});
        });


        querySnapshot5.docs.forEach((doc)=>{
          batch.update(doc.ref, {"miniUser": newMiniUser});
        });

        const appId = "62PH99K08I";
        const adminAPIKEY = "d9f4c533907474f6eb98f86d049368a2";
        const client = algoliasearch(appId, adminAPIKEY);
        const index = client.initIndex("dev_users_search");
        await index.partialUpdateObject({
          profilePicture: newMiniUser.profilePicture,
          objectID: userId,
        });

        return batch.commit();
      }
      return;
    });
