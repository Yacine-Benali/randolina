enum Role { client, club, agency, brand }

const String wrongNameError = '';
const String invalidUsernameError = '';
const String invalidWilayaError = '';
const String invalidPasswordError = '';
const String invalidPhoneNumberError = '';
const Map<Role, String> roleToText = {
  Role.client: 'User',
  Role.club: 'Club',
  Role.agency: 'Agency',
  Role.brand: 'Store',
};
