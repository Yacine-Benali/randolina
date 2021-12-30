/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


export const onMessageCreated = functions.firestore
    .document("conversations/{conversationId}/messages/{messageId}")
    .onCreate(async (snap, context) => {
      const docData = snap.data();
      const receiverUser = await db.collection("users").doc(docData.createdFor).get();
      const senderUser = await db.collection("users").doc(docData.createdBy).get();
      const conversationDoc = await db.collection("conversations").doc(context.params.conversationId).get();

      // const conversationDocdata = conversationDoc.data();
      if (receiverUser?.data()?.pushToken != null) {
        const payload = {
          notification: {
            title: "Vous avez un nouveau message",
            body: `${senderUser?.data()?.username}: ${docData.content}`,

          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "conversationId": `${conversationDoc.id}`,
            // "latestMessagecontent": `${conversationDocdata.latestMessage.content}`,
          },
          token: receiverUser?.data()?.pushToken,
        };
        return admin.messaging().send(payload);
      } else {
        return null;
      }
    });
