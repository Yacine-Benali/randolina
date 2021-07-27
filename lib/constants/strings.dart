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
const String invalidUsernameError = '*';
const String invalidWilayaError = '*';
const String invalidPasswordError = '*';
const String invalidPhoneNumberError = '*';
const String invalidVerificationCodeError = '*';
