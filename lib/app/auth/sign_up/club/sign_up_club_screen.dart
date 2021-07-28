import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/club/sign_up_club_form.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/common_widgets/custom_app_bar.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SignUpClubScreen extends StatefulWidget {
  const SignUpClubScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpClubScreenState createState() => _SignUpClubScreenState();
}

class _SignUpClubScreenState extends State<SignUpClubScreen> {
  late final SignUpBloc bloc;
  late final PageController _pageController;

  late String _fullname;
  late String _clubname;
  late Timestamp _creationDate;
  late int _wilaya;
  late int _members;
  late String _username;
  late String _email;
  late String _password;
  late String _phoneNumber;
  late File _imageFile;
  late String _bio;
  late List<String> _activities;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    final Auth auth = context.read<Auth>();
    final Database database = context.read<Database>();
    bloc = SignUpBloc(auth: auth, database: database);

    super.initState();
  }

  void swipePage(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> sendClientInfo() async {
    // start loading widget
    try {
      final ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Image uploading...');

      final String profilePictureUrl =
          await bloc.uploadProfilePicture(_imageFile);
      // creat club account
      //  await bloc.saveClientInfo(client);
      pd.close();
      Navigator.of(context).pop();
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return CustomScaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          SignUpClubForm(
            onSaved: ({
              required String fullname,
              required String clubname,
              required Timestamp creationDate,
              required int wilaya,
              required int members,
            }) {
              logger.info({
                'fullname': fullname,
                'clubname': clubname,
                'creationDate': creationDate,
                'wilaya': wilaya,
                'members': members,
              });
            },
          ),
        ],
      ),
    );
  }
}
