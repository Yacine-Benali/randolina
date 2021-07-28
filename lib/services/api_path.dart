class APIPath {
  static String userDocument(String uid) => 'users/$uid/';
  static String userProfilePicture(String uid, String photoId) =>
      'users/$uid/profile_picutres/$photoId';
}
