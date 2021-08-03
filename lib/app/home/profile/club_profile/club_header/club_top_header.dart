import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/profile_edit_pop_up.dart';

class ClubTopHeader extends StatelessWidget {
  const ClubTopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    late String address;
    late String subtitle;
    if (user is Club) {
      address = user.address;
      subtitle = 'Club de Randonnée';
    } else if (user is Agency) {
      address = user.address;
      subtitle = 'Agence de Voyage';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 23),
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
                  ProfileEditPopUp(
                    onEditPressed: () {},
                  ),
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
              Text(
                address,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.87),
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
