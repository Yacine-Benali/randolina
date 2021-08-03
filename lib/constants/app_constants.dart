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

List<dynamic> clubActivities = [
  {
    'display': 'Kayak',
    'value': 'Kayak',
  },
  {
    'display': 'Hiking',
    'value': 'Hiking',
  },
  {
    'display': 'Voyage OR',
    'value': 'Voyage OR',
  },
  {
    'display': 'Bivouac',
    'value': 'Bivouac',
  },
  {
    'display': 'Jet ski',
    'value': 'Jet ski',
  },
  {
    'display': 'Parachute',
    'value': 'Parachute',
  },
  {
    'display': 'Diving',
    'value': 'Diving',
  },
  {
    'display': 'Mountaineering',
    'value': 'Mountaineering',
  },
  {
    'display': 'Others...',
    'value': 'Others...',
  },
];
String clubKey = 'display';
String clubValue = 'value';
