import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import algoliasearch from 'algoliasearch';

admin.initializeApp();
const db = admin.firestore();

const appId: string = '62PH99K08I';
const adminAPIKEY: string = 'd9f4c533907474f6eb98f86d049368a2';

const client = algoliasearch(appId, adminAPIKEY);
const index = client.initIndex('users_search');


export const onUserCreated = functions.firestore.document('users/{userId}').onUpdate(
    async (snapshot, context) => {
        const data = snapshot.after.data();
        let uid: String = context.params.userId;



        let miniUser =
        {
            id: uid,
            name: data.name,
            username: data.username,
            profilePicture: data.profilePicture
        }
        //  create subscription doc if type is 1,2,3
        let type: number = data.type;
        if (type == 1 || type == 2 || type == 3) {

            await db.doc(`subscriptions/${uid}`).set(
                {
                    "isApproved": false,
                    "endsAt": admin.firestore.Timestamp.fromMillis(1641054576000)
                }
            );
        }
        // create user_followers_posts
        await db.doc(`user_followers_posts/${uid}`).set(
            {
                'miniUser': miniUser,
                'lastPostTimestamp': null,
                'followers': [],
                'postsIds': [],

            }
        );

        // create user_followers_stories
        await db.doc(`user_followers_stories/${uid}`).set(
            {
                'miniUser': miniUser,
                'lastPostTimestamp': null,
                'followers': [],
                'storiesIds': [],

            }
        );
        
        //todo remove this line when in prod
        if (false) {
            // add mini user to algolia for full-text-search
            const records = [
                {
                    objectID: uid,
                    name: data.name,
                    username: data.username,
                    profilePicture: data.profilePicture
                },
            ];

            return index.saveObjects(records, { autoGenerateObjectIDIfNotExist: true });
        }

    }
);
