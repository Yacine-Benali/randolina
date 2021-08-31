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

  static String postDocument(String postId) => 'posts/$postId';

  static String likesCollection(String postId) => 'posts/$postId/likes';

  static String likesDocument(String postId, String likeId) =>
      'posts/$postId/likes/$likeId';

  static String commentsCollection(String postId) => 'posts/$postId/comments';

  static String savedPostsDocument(String uid) =>
      'users/$uid/savedPosts/savedPosts';

  static String savedPostsCollection(String uid) => 'users/$uid/savedPosts';
  static String storyDocument(String uid) => 'stories/$uid/';
  static String conversationsCollection() => 'conversations/';
  static String conversationDocument(String uid) => 'conversations/$uid';
  static String messagesCollection(String uid) => 'conversations/$uid/messages';

  static String chatPhotosCollection(String uid, String photoId) =>
      'conversations/$uid/messages/$photoId';

  static String eventsPictures(String userId, String eventId, String photoId) =>
      'events/user_$userId/event_$eventId/$photoId';

  static String eventDocument(String eventId) => 'events/$eventId';
}
