import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/club/sign_up_club_form.dart';
import 'package:randolina/app/auth/sign_up/club/sign_up_club_form2.dart';
import 'package:randolina/app/auth/sign_up/club/sign_up_club_form3.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_phone_confirmation.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/assets_constants.dart';
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
  late String _address;
  late int _members;
  late String _username;
  late String _email;
  late String _password;
  late String _phoneNumber;
  late File _imageFile;
  late String? _bio;
  late List<String> _clubActivities;

  @override
  void initState() {
    _pageController = PageController();
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

  Future<void> sendClubInfo() async {
    // start loading widget
    try {
      final ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Image uploading...');

      final String profilePictureUrl =
          await bloc.uploadProfilePicture(_imageFile);
      // creat club account
      final Club club = Club(
        id: '',
        type: 1,
        username: _username,
        name: _clubname,
        profilePicture: profilePictureUrl,
        bio: _bio,
        posts: 0,
        followers: 0,
        following: 0,
        address: _address,
        phoneNumber: _phoneNumber,
        activities: _clubActivities,
        presidentName: _fullname,
        creationDate: _creationDate,
        email: _email,
        members: _members,
      );
      await bloc.saveClientInfo(club);
      pd.close();
      Navigator.of(context).pop();
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.hasClients) {
          if (_pageController.page == 0) {
            return true;
          } else {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
        return false;
      },
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          SignUpClubForm(
            onSaved: ({
              required String fullname,
              required String clubname,
              required Timestamp creationDate,
              required String address,
              required int members,
            }) {
              _fullname = fullname;
              _clubname = clubname;
              _creationDate = creationDate;
              _address = address;
              _members = members;
              swipePage(1);
            },
          ),
          SignUpClubForm2(
            onSaved: ({
              required String username,
              required String email,
              required String password,
              required String phoneNumber,
            }) async {
              try {
                _username = username;
                _email = email;
                _password = password;
                _phoneNumber = phoneNumber;

                await bloc.verifyPhoneNumber(_phoneNumber);
                swipePage(2);
              } on Exception catch (e) {
                logger.severe('Error in verifyPhoneNumber');
                PlatformExceptionAlertDialog(exception: e).show(context);
              }
            },
          ),
          SignUpPhoneConfirmation(
            backgroundImagePath: clubBackgroundImage,
            bloc: bloc,
            onNextPressed: (String code) async {
              try {
                final bool isLoggedIn = await bloc.magic(
                  _username,
                  _password,
                  code,
                );
                if (isLoggedIn) {
                  swipePage(3);
                }
              } on Exception catch (e) {
                PlatformExceptionAlertDialog(exception: e).show(context);
              }
            },
          ),
          SignUpClubForm3(
            onSaved: ({
              required File imageFile,
              required String? bio,
              required List<String> clubActivities,
            }) {
              _imageFile = imageFile;
              _bio = bio;
              _clubActivities = clubActivities;

              sendClubInfo();
            },
          ),
        ],
      ),
    );
  }
}
