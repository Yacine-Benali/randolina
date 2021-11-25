import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import algoliasearch from "algoliasearch";

admin.initializeApp();
const db = admin.firestore();


export const onUserCreated = functions.firestore.document("users/{userId}").
    onCreate(
        async (snapshot, context) => {
          const data = snapshot.data();
          const uid: string = context.params.userId;


          const miniUser =
        {
          id: uid,
          name: data.name,
          username: data.username,
          profilePicture: data.profilePicture,
        };
          //  create subscription doc if type is 1,2,3
          const type: number = data.type;
          if (type == 1 || type == 2 || type == 3) {
            await db.doc(`subscriptions/${uid}`).set(
                {
                  "isApproved": false,
                  "endsAt": admin.firestore.Timestamp.fromMillis(1641054576000),
                }
            );
          }
          // create user_followers_posts
          await db.doc(`user_followers_posts/${uid}`).set(
              {
                "id": uid,
                "length": 0,
                "lastPostTimestamp": null,
                "followers": [],
                "postsIds": [],

              }
          );

          // create user_followers_stories
          await db.doc(`user_followers_stories/${uid}`).set(
              {
                "miniUser": miniUser,
                "lastStoryTimestamp": null,
                "followers": [],
                "storiesIds": [],

              }
          );

          // TODO add this line when in prod

          // add mini user to algolia for full-text-search

          const appId = "62PH99K08I";
          const adminAPIKEY = "d9f4c533907474f6eb98f86d049368a2";
          const client = algoliasearch(appId, adminAPIKEY);
          const index = client.initIndex("dev_users_search");

          const records = [
            {
              objectID: uid,
              name: data.name,
              username: data.username,
              profilePicture: data.profilePicture,
            },
          ];

          return index
              .saveObjects(records, {autoGenerateObjectIDIfNotExist: true});
        }
    );
