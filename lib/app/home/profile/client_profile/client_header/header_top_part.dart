import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/pop_menu_header.dart';
import 'package:randolina/app/models/client.dart';

class ClientHeaderTopPart extends StatelessWidget {
  const ClientHeaderTopPart({
    Key? key,
    required this.client,
    required this.showEditButton,
    required this.onEditPressed,
  }) : super(key: key);
  final Client client;
  final bool showEditButton;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(top: 14, left: 90),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: (client.name.length > 15) ? 120 : null,
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
                      if (showEditButton) ...[
                        PopMenuClientHeader(onEditPressed: onEditPressed),
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
