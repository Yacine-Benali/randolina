enum Role { client, club, agency, store }
//
const Map<Role, String> roleToText = {
  Role.client: 'User',
  Role.club: 'Club',
  Role.agency: 'Agency',
  Role.store: 'Store',
};

List<String> clientActivities = [
  'Photographer',
  'Vloger',
  'Hikinger',
  'Video maker',
  'Athlete',
  'Tourist',
  'Other'
];
