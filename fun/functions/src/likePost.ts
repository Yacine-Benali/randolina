import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();

export const likePost = functions.https.onCall(async (data, context) => {
  const postId: string = data.postId;
  const uid: string | undefined = context.auth?.uid;


  // if there is no authId return;
  if (uid == undefined) {
    return;
  }
  const postLikeCollection = `posts/${postId}/likes`;
  // query if user already like the document if its the case return
  const querySnapshot1 =
    await db.collection(postLikeCollection)
        .where("likedBy", "array-contains", uid).get();

  if (querySnapshot1.docs.length != 0) {
    return;
  }

  // query for the Like document that is
  // not full(<10 000) in the postLikeCollection
  // if it exist add the user in it,
  // check if its full,if it is then mark it as full
  // update post number of likes
  const querySnapshot2 = await
  db.collection(postLikeCollection).where("length", "<", 4).get();
  if (querySnapshot2.docs.length > 0) {
    await querySnapshot2.docs[0].ref.update({
      "likedBy": admin.firestore.FieldValue.arrayUnion(uid),
      "length": admin.firestore.FieldValue.increment(1),
    });


    return db.doc(`posts/${postId}`).update({
      "numberOfLikes": admin.firestore.FieldValue.increment(1),
    });
  } else {
    // if there is not any creat a new one with isfull false

    db.collection(`posts/${postId}/likes`).add({
      "length": 1,
      "likedBy": admin.firestore.FieldValue.arrayUnion(uid),
    });
    return db.doc(`posts/${postId}`).update({
      "numberOfLikes": admin.firestore.FieldValue.increment(1),
    });
  }
});
