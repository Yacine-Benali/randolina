import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/search_screen.dart';

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
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      color: Colors.blue[900],
                      onPressed: () {
                        showSearch(context: context, delegate: DataSearch());
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      size: 26,
                    ),
                    color: Colors.blue[900],
                    onPressed: () {},
                  ),
                ],
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
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.turned_in_not,
                  size: 30,
                ),
                color: Colors.blue[900],
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
