import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_colors.dart';

class StoreEditProfile extends StatefulWidget {
  const StoreEditProfile({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final ProfileBloc bloc;
  @override
  _StoreEditProfileState createState() => _StoreEditProfileState();
}

class _StoreEditProfileState extends State<StoreEditProfile> {
  late final TextStyle titleStyle;
  String? bio;
  late String activity;
  File? profileImage;
  late Store store;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );

    store = context.read<User>() as Store;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            ClubHeader(
              clubOrAgency: store,
              showProfileAsOther: false,
              bloc: widget.bloc,
              onSavePressed: () {},
              onEditPressed: () {},
              onImageChange: (f) {
                profileImage = f;
                setState(() {});
              },
              isImageChangable: true,
              isFollowingOther: false,
              onMoreInfoPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextForm(
                      textInputAction: TextInputAction.newline,
                      textInputType: TextInputType.multiline,
                      lines: 3,
                      maxLength: 100,
                      initialValue: store.bio,
                      title: 'Bio:',
                      titleStyle: titleStyle,
                      hintText: 'Bio...',
                      onChanged: (String value) {
                        bio = value;
                      },
                      validator: (v) {
                        if (v != null) {
                          final numLines = '\n'.allMatches(v).length + 1;
                          if (numLines > 3) {
                            return 'le nombre de lignes ne peut pas dépasser 3';
                          }
                        }
                      },
                    ),
                    SizedBox(height: 70),
                    CustomElevatedButton(
                      buttonText: Text(
                        'sauvegarder',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          widget.bloc
                              .saveAgencyStoreProfile(bio, profileImage)
                              .then((value) => Fluttertoast.showToast(
                                  msg:
                                      'photo de profil mise a jour avec succès'));
                          Navigator.of(context).pop();
                        }
                      },
                      minHeight: 30,
                      minWidth: 130,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
