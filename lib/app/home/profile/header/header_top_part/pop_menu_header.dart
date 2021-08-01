import 'package:flutter/material.dart';

enum FilterOptions {
  editprofile,
  singout,
}

class PopMenuHeader extends StatefulWidget {
  const PopMenuHeader({Key? key}) : super(key: key);

  @override
  _PopMenuHeaderState createState() => _PopMenuHeaderState();
}

class _PopMenuHeaderState extends State<PopMenuHeader> {
  late bool showPopMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        setState(() {
          if (selectedValue == FilterOptions.editprofile) {
            showPopMenu = true;
          } else {
            showPopMenu = false;
          }
          if (selectedValue == FilterOptions.singout) {
            showPopMenu = true;
          } else {
            showPopMenu = false;
          }
        });
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: FilterOptions.editprofile,
          child: Text(
            'Edit profil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        PopupMenuItem(
          height: 5,
          value: FilterOptions.editprofile,
          child: Divider(
            height: 3,
            color: Colors.black,
          ),
        ),
        PopupMenuItem(
          value: FilterOptions.singout,
          child: Text(
            'Sign out',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
      ],
      child: Container(
        height: 15,
        width: 15,
        alignment: Alignment.center,
        child: Icon(
          Icons.keyboard_arrow_down,
          size: 15,
        ),
      ),
    );
  }
}
