import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/home/profile/common/saved_posts_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/custom_drop_down.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/app_constants.dart';
import 'package:randolina/constants/strings.dart';

class ClientProfileEditScreen extends StatefulWidget {
  const ClientProfileEditScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final ProfileBloc bloc;
  @override
  _ClientProfileEditScreenState createState() =>
      _ClientProfileEditScreenState();
}

class _ClientProfileEditScreenState extends State<ClientProfileEditScreen> {
  late final TextStyle titleStyle;
  String? bio;
  late String activity;
  File? profileImage;
  late Client currentClient;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
    currentClient = context.read<User>() as Client;
    if (clientActivities.contains(currentClient.activity)) {
      activity = currentClient.activity;
    } else {
      activity = clientActivities[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            ClientHeader(
              client: currentClient,
              isFollowingOther: false,
              onEditPressed: () {},
              showProfileAsOther: false,
              onImageChange: (f) {
                profileImage = f;
                setState(() {});
              },
              isImageChangable: true,
              onSavePressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SavedPostsScreen(bloc: widget.bloc),
                  ),
                );
              },
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
                      initialValue: currentClient.bio,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CustomDropDown(
                        titleStyle: titleStyle,
                        initialValue: activity,
                        validator: (String? value) {
                          if (value == null) {
                            return invalidActivityError;
                          }
                          return null;
                        },
                        title: 'Activité:',
                        hint: 'a choisi...',
                        options: clientActivities,
                        onChanged: (String value) {
                          activity = value;
                        },
                      ),
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
                              .saveClientProfile(bio, activity, profileImage)
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
