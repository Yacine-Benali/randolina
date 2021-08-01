import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/services/auth.dart';

enum FilterOptions {
  editprofile,
  singout,
}

class PopMenuClientHeader extends StatefulWidget {
  const PopMenuClientHeader({Key? key}) : super(key: key);

  @override
  _PopMenuClientHeaderState createState() => _PopMenuClientHeaderState();
}

class _PopMenuClientHeaderState extends State<PopMenuClientHeader> {
  late bool showPopMenu;

  @override
  Widget build(BuildContext context) {
    final Auth auth = context.read<Auth>();

    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        setState(() {
          if (selectedValue == FilterOptions.editprofile) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClientProfileEditScreen(),
              ),
            );
          } else if (selectedValue == FilterOptions.singout) {
            auth.signOut();
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
