import 'package:flutter/material.dart';
import 'package:randolina/app/home/conversation/conversation_screen.dart';
import 'package:randolina/app/home/feed/search_screen.dart';
import 'package:randolina/constants/app_colors.dart';

class FeedAppBar extends StatelessWidget {
  const FeedAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.25),
            blurRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.only(),
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                color: darkBlue,
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: 158,
              height: 53,
              child: Image.asset(
                'assets/home_logo.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 30,
                ),
                color: darkBlue,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (builder) => ConversationScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
