import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_to_chat.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/common_widgets/profile_edit_pop_up.dart';
import 'package:randolina/common_widgets/size_config.dart';

class ClientHeaderTopPart extends StatelessWidget {
  const ClientHeaderTopPart({
    Key? key,
    required this.client,
    required this.showProfileAsOther,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.isFollowingOther,
  }) : super(key: key);
  final Client client;
  final bool showProfileAsOther;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final bool? isFollowingOther;

  @override
  Widget build(BuildContext context) {
    late final double textRowWidth;
    if (showProfileAsOther) {
      textRowWidth = SizeConfig.screenWidth - 120 - 8 - 55;
    } else {
      textRowWidth = SizeConfig.screenWidth - 120 - 55 - 30 - 8;
    }

    return Container(
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
              padding: const EdgeInsets.only(top: 14, left: 120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: textRowWidth,
                        child: Text(
                          client.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!showProfileAsOther) ...[
                        ProfileEditPopUp(onEditPressed: onEditPressed),
                      ],
                    ],
                  ),
                  Text(
                    client.activity,
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
          if (!showProfileAsOther) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.turned_in_not, size: 30),
                onPressed: onSavePressed,
              ),
            ),
          ],
          if (showProfileAsOther && isFollowingOther != null) ...[
            IconButton(
              icon: Icon(Icons.chat_bubble_outline, size: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserToChat(otherUser: client),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
