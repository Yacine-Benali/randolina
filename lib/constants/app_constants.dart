enum Role {
  client,
  club,
  agency,
  store,
}

const Map<Role, String> roleToText = {
  Role.client: 'Utilisateur',
  Role.club: 'Club',
  Role.agency: 'Agence',
  Role.store: 'E-commerce',
};

List<String> clientActivities = [
  'Photographe',
  'Vlogueur',
  'Randonneur',
  'Video maker',
  'Athlète',
  'Touriste',
  'Autre'
];

List<dynamic> clubActivities = [
  {
    'display': 'Kayak',
    'value': 'Kayak',
  },
  {
    'display': 'Randonée',
    'value': 'Hiking',
  },
  {
    'display': 'Voyage OR',
    'value': 'Voyage OR',
  },
  {
    'display': 'Camping',
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
    'display': 'Plongée',
    'value': 'Diving',
  },
  {
    'display': 'Alpinisme',
    'value': 'Mountaineering',
  },
  {
    'display': 'Autre...',
    'value': 'Others...',
  },
];
String clubKey = 'display';
String clubValue = 'value';
