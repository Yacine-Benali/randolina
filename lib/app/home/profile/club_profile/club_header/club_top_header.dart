import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/profile_edit_pop_up.dart';

class ClubTopHeader extends StatelessWidget {
  const ClubTopHeader({
    Key? key,
    required this.onEditPressed,
    required this.showProfileAsOther,
  }) : super(key: key);
  final VoidCallback onEditPressed;
  final bool showProfileAsOther;

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    late String subtitle;
    if (user is Club) {
      subtitle = 'Club de Randonnée';
    } else if (user is Agency) {
      subtitle = 'Agence de Voyage';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showProfileAsOther) ...[
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.close,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (!showProfileAsOther) ...[
                    ProfileEditPopUp(
                      onEditPressed: onEditPressed,
                    ),
                  ]
                ],
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF40A3DB),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 26),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.turned_in_not,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
