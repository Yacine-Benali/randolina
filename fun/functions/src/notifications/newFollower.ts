/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


export const newFollower = functions.firestore
    .document("user_followers_posts/{userThatWasFollowedId}")
    .onUpdate(async (snap, context) => {
      if (snap.before.data().followers.length > snap.after.data().followers.length ) {
        return null;
      }
      const docData = snap.after.data();
      // const senderID = docData.followers[docData.followers.length-1];
      const userThatWasFollowedId = context.params.userThatWasFollowedId;
      const receiverUser = await db.collection("users").doc(userThatWasFollowedId).get();
      const senderUser = await db.collection("users").doc(docData.followers[docData.followers.length-1]).get();


      // const conversationDocdata = conversationDoc.data();
      if (receiverUser?.data()?.pushToken != null) {
        const payload = {
          notification: {
            title: "nouveau abonné",
            body: `@${senderUser?.data()?.username} vient de vous abonnez`,

          },
          data: {

          },
          token: receiverUser?.data()?.pushToken,
        };
        return admin.messaging().send(payload);
      } else {
        return null;
      }
    });
