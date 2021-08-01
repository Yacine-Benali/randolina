import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/pop_menu_header.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';

class NameLocationClub extends StatelessWidget {
  const NameLocationClub({Key? key}) : super(key: key);

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

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25, left: 23),
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
                    PopMenuClientHeader(),
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF40A3DB),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.87),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 26, bottom: 15),
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 27,
                height: 27,
                child: Icon(Icons.turned_in_not),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
