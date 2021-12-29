/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable guard-for-in */
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


export const newEvent = functions.firestore
    .document("events/{eventId}")
    .onUpdate(async (snap) => {
      const docData = snap.after.data();
      const senderID = docData.createdBy.id;
      const senderUser = await db.collection("users").doc(senderID).get();
      const senderUserFollowerPosts = await db.collection("user_followers_posts").doc(senderID).get();
      const clubOrAgencyFollowersIds:string[]= senderUserFollowerPosts?.data()?.followers;
      const futures:Promise<any>[]= new Array(clubOrAgencyFollowersIds.length);

      for (let i = 0; i< clubOrAgencyFollowersIds.length; i++) {
        console.log(clubOrAgencyFollowersIds[i]);
        const future = db.collection("users").doc(clubOrAgencyFollowersIds[i]).get().then((receiverUser)=>{
          if (receiverUser?.data()?.pushToken != null) {
            const payload = {
              notification: {
                title: "nouveau événement",
                body: `@${senderUser?.data()?.username} vient de créer un nouvel événement`,

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

        futures.push(future);
      }
      return Promise.all(futures);
    });
