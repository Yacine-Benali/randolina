import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_to_chat.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopUpOptions {
  call,
  sendMessage,
}

//? should i stop passing values to widget and just use provider ?
class ClubProfilePopUp extends StatefulWidget {
  const ClubProfilePopUp({
    Key? key,
    required this.clubOrAgency,
  }) : super(key: key);

  final User clubOrAgency;
  @override
  _ClubProfilePopUpState createState() => _ClubProfilePopUpState();
}

class _ClubProfilePopUpState extends State<ClubProfilePopUp> {
  PopupMenuItem<PopUpOptions> buildTile(
    PopUpOptions value,
    String text,
    Icon icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: SizedBox(
        width: 191,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 3),
            Divider(
              height: 3,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.85),
                    fontFamily: 'Lato-Black',
                  ),
                ),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: SizedBox(
                    width: 5,
                    height: 5,
                    child: icon,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              height: 3,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
            SizedBox(height: 3),
          ],
        ),
      ),
    );
  }

  Future<void> call(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      logger.severe('cant launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Color(0xFF334D73),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.black.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(51, 77, 115, 0.42),
            blurRadius: 4,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: PopupMenuButton<PopUpOptions>(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
        onSelected: (PopUpOptions selectedValue) async {
          if (selectedValue == PopUpOptions.sendMessage) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    UserToChat(otherUser: widget.clubOrAgency),
              ),
            );
          } else if (selectedValue == PopUpOptions.call) {
            call('tel:${widget.clubOrAgency.phoneNumber}');
          }
        },
        icon: Icon(
          Icons.phone,
          color: Colors.white,
          size: 20,
        ),
        itemBuilder: (_v) {
          return [
            buildTile(
              PopUpOptions.call,
              'Appel tel',
              Icon(Icons.call),
            ),
            buildTile(
              PopUpOptions.sendMessage,
              'envoi un message',
              Icon(Icons.message_outlined),
            ),
          ];
        },
      ),
    );
  }
}
