// import 'package:flutter/material.dart';
// import 'package:multiselect_formfield/multiselect_formfield.dart';
// import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';
// import 'package:randolina/app/home/profile/club_profile/club_profile_events_slider.dart';
// import 'package:randolina/app/home/profile/profile_bloc.dart';
// import 'package:randolina/app/models/club.dart';
// import 'package:randolina/app/models/user.dart';
// import 'package:randolina/constants/app_colors.dart';
// import 'package:randolina/constants/app_constants.dart';
// import 'package:randolina/constants/strings.dart';

// class ClubMoreInfoScreen extends StatefulWidget {
//   const ClubMoreInfoScreen({
//     Key? key,
//     required this.clubOrAgency,
//     required this.bloc,
//     required this.isFollowingOther,
//   }) : super(key: key);
//   final User clubOrAgency;
//   final ProfileBloc bloc;
//   final bool isFollowingOther;
//   @override
//   _ClubMoreInfoScreenState createState() => _ClubMoreInfoScreenState();
// }

// class _ClubMoreInfoScreenState extends State<ClubMoreInfoScreen> {
//   late final TextStyle titleStyle;
//   String? bio;
//   late List<String>? activities;

//   @override
//   void initState() {
//     titleStyle = TextStyle(
//       color: Colors.grey,
//       fontSize: 14,
//     );
//     if (widget.clubOrAgency is Club) {
//       activities = (widget.clubOrAgency as Club).activities;
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(
//         children: [
//           ClubHeader(
//             clubOrAgency: widget.clubOrAgency,
//             showProfileAsOther: true,
//             bloc: widget.bloc,
//             onEditPressed: () {},
//             onMoreInfoPressed: () {},
//             isFollowingOther: widget.isFollowingOther,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextButton(
//               onPressed: () {},
//               child: Text(
//                 'See all events',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ),
//           ClubProfileEventSlider(),
//           if (activities != null) ...[
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: MultiSelectFormField(
//                 initialValue: activities,
//                 validator: (values) {
//                   if (values != null) {
//                     final List<dynamic> temp = values as List<dynamic>;

//                     if (temp.isEmpty) {
//                       return invalidClubActivitiesError;
//                     }
//                   } else {
//                     return invalidClubActivitiesError;
//                   }
//                 },
//                 chipBackGroundColor: gradientStart,
//                 //  errorText: '*',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                 ),
//                 chipLabelStyle: TextStyle(color: Colors.white),
//                 dialogTextStyle: TextStyle(color: Colors.black),
//                 checkBoxActiveColor: Colors.blue,
//                 checkBoxCheckColor: Colors.white,
//                 title: Text('Choose activities', style: titleStyle),
//                 dataSource: clubActivities,
//                 textField: clubKey,
//                 valueField: clubValue,
//                 hintWidget: Text(
//                   'Please choose one or more activities',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 onSaved: (values) {
//                   if (values == null) return;
//                   final List<String> temp = (values as List<dynamic>)
//                       .map((e) => e.toString())
//                       .toList();
//                   setState(() {
//                     activities = temp;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
