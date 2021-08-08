import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (admin.apps.length === 0) {
    admin.initializeApp();
}
const db = admin.firestore();


export const onStoryCreated = functions.firestore.document('stories/{storyId}').onCreate(
    async (snapshot, context) => {
        const data = snapshot.data();

        let uid: string = data.createdBy;
        let documentSnapshot = await db.collection('user_followers_stories').doc(uid).get();
         

        if (documentSnapshot.exists) {
            let storyId: string = context.params.storyId;
            return documentSnapshot.ref.update({
                'storiesIds': admin.firestore.FieldValue.arrayUnion(
                    {
                        'storyId': storyId,
                        'createdAt': data.createdAt,
                    }
                ),
                'lastPostTimestamp': data.createdAt,
            });
        } else {
            return null;
        }
    }
);
