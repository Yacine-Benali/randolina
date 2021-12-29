/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}
const db = admin.firestore();


exports.onMessageCreated = functions.firestore
    .document("conversations/{conversationId}/messages/{messageId}")
    .onCreate(async (snap, context) => {
      const docData = snap.data();
      const receiverUser = await db.collection("users").doc(docData.createdFor).get();
      const senderUser = await db.collection("users").doc(docData.createdBy).get();
      const conversationDoc = await db.collection("conversations").doc(context.params.conversationId).get();

      const conversationDocdata = conversationDoc.data();
      if (receiverUser?.data()?.pushToken != null) {
        const payload = {
          notification: {
            title: "Vous avez un nouveau message",
            body: " ",

          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "groupeChatId": `${conversationDoc.id}`,
            "latestMessagecontent": `${conversationDocdata.latestMessage.content}`,
            "latestMessagereceiverId": `${conversationDocdata.latestMessage.receiverId}`,
            "latestMessageseen": `${conversationDocdata.latestMessage.seen}`,
            "latestMessagesenderId": `${conversationDocdata.latestMessage.senderId}`,
            "latestMessagetimestamp": `${conversationDocdata.latestMessage.timestamp}`,
            "studentId": `${conversationDocdata.student.id}`,
            "studentName": `${conversationDocdata.student.name}`,
            "teacherId": `${conversationDocdata.teacher.name}`,
            "teacherName": `${conversationDocdata.teacher.id}`,
          },
          token: receiverUser.data().pushToken,
        };
        return admin.messaging().send(payload);
      } else {
        return null;
      }
    });
