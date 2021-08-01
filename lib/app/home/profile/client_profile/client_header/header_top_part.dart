import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/pop_menu_header.dart';
import 'package:randolina/app/models/user.dart';

class ClientHeaderTopPart extends StatelessWidget {
  const ClientHeaderTopPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    return Container(
      height: 82 - 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
        ),
        border: Border.all(
          color: Colors.black.withOpacity(0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.20),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, left: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PopMenuClientHeader(
                        onEditPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClientProfileEditScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Vloger',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF40A3DB),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.turned_in_not, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
