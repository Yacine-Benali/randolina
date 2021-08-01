import 'package:flutter/material.dart';

class IconHeader extends StatelessWidget {
  const IconHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 26, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/icons/menu.png',
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 27,
            height: 27,
            child: Image.asset(
              'assets/icons/search icon.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 27,
            width: 27,
            child: Image.asset(
              'assets/icons/bookmark.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
