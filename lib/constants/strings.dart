enum Role { client, club, agency, store }
//
const Map<Role, String> roleToText = {
  Role.client: 'User',
  Role.club: 'Club',
  Role.agency: 'Agency',
  Role.store: 'Store',
};
const String loclUserInfoKey = 'userInfo';
const String wrongNameError = '*';
const String invalidUsernameSignUpError = '*';
const String invalidUsernameSignInError = '*';
const String invalidWilayaError = '*';
const String invalidPasswordError = '*';
const String invalidPhoneNumberError = '*';
const String invalidVerificationCodeError = '*';
