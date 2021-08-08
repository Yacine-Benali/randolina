// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:randolina/services/auth.dart';

// enum Options {
//   moreInfo,
// }

// class MoreInfoPopUp extends StatefulWidget {
//   const MoreInfoPopUp({
//     Key? key,
//     required this.onMoreInfoPressed,
//   }) : super(key: key);
//   final VoidCallback onMoreInfoPressed;
//   @override
//   _MoreInfoPopUpState createState() => _MoreInfoPopUpState();
// }

// class _MoreInfoPopUpState extends State<MoreInfoPopUp> {
//   late bool showPopMenu;

//   @override
//   Widget build(BuildContext context) {
//     final Auth auth = context.read<Auth>();

//     return PopupMenuButton(
//       onSelected: (Options selectedValue) {
//         if (selectedValue == Options.moreInfo) {
//           widget.onMoreInfoPressed();
//         }
//       },
//       itemBuilder: (_) => [
//         PopupMenuItem(
//           value: Options.moreInfo,
//           child: Text(
//             'More info',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         PopupMenuItem(
//           height: 5,
//           value: Options.moreInfo,
//           child: Divider(
//             height: 3,
//             color: Colors.black,
//           ),
//         ),
//       ],
//       child: Icon(
//         Icons.more_horiz_outlined,
//         size: 25,
//       ),
//     );
//   }
// }
