class APIPath {
  static String userDocument(String uid) => 'users/$uid/';
  static String userProfilePicture(String uid, String photoId) =>
      'users/$uid/profile_picutres/$photoId';

  static String userFollowerStoriesDocument(String uid) =>
      'user_followers_stories/$uid/';

  static String userFollowerPostsDocument(String uid) =>
      'user_followers_posts/$uid/';

  static String userFollowerPostsCollection() => 'user_followers_posts';

  static String userFollowerStoriesCollection() => 'user_followers_stories/';
  static String postsCollection() => 'posts/';
}
