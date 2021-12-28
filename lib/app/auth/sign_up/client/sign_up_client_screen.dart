import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_client_form.dart';
import 'package:randolina/app/auth/sign_up/client/sign_up_client_form2.dart';
import 'package:randolina/app/auth/sign_up/sign_up_bloc.dart';
import 'package:randolina/app/auth/sign_up/sign_up_phone_confirmation.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/assets_constants.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SignUpClientScreen extends StatefulWidget {
  const SignUpClientScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpClientScreenState createState() => _SignUpClientScreenState();
}

class _SignUpClientScreenState extends State<SignUpClientScreen> {
  late final SignUpBloc bloc;
  late final PageController _pageController;

  late String _fullname;
  late String _username;
  late int _wilaya;
  late String _password;
  late String _phoneNumber;
  late File _imageFile;
  String? _bio;
  late String _activity;
  late Timestamp _dateOfBirth;

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

  Future<void> sendClientInfo() async {
    // start loading widget
    try {
      final ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: "Téléchargement d'images...");

      final String profilePictureUrl =
          await bloc.uploadProfilePicture(_imageFile);
      final Client client = Client(
        id: 'id',
        type: 0,
        username: _username,
        name: _fullname,
        profilePicture: profilePictureUrl,
        profilePicturePath: bloc.getProfilePicturePath(),
        bio: _bio,
        posts: 0,
        followers: 0,
        following: 0,
        wilaya: _wilaya,
        phoneNumber: _phoneNumber,
        isModerator: false,
        activity: _activity,
        dateOfBirth: _dateOfBirth,

        // this field is left for future usage
        physicalCondition: '',
      );
      await bloc.saveClientInfo(client);
      pd.close();
      // ignore: use_build_context_synchronously
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
      child: SizedBox(
        height: SizeConfig.screenHeight,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            SignUpClientForm(
              onSaved: ({
                required String fullname,
                required String password,
                required String phoneNumber,
                required String username,
                required int wilaya,
                required Timestamp dateOfBirth,
              }) async {
                try {
                  _fullname = fullname;
                  _password = password;
                  _phoneNumber = phoneNumber;
                  _username = username;
                  _wilaya = wilaya;
                  _dateOfBirth = dateOfBirth;

                  await bloc.verifyPhoneNumber(_phoneNumber);
                  swipePage(1);
                } on Exception catch (e) {
                  logger.severe('Error in verifyPhoneNumber');
                  PlatformExceptionAlertDialog(exception: e).show(context);
                }
              },
            ),
            SignUpPhoneConfirmation(
              backgroundImagePath: clientBackgroundImage,
              onNextPressed: (String code) async {
                try {
                  final bool isLoggedIn = await bloc.magic(
                    _username,
                    _password,
                    code,
                  );
                  if (isLoggedIn) {
                    swipePage(2);
                  }
                } on Exception catch (e) {
                  PlatformExceptionAlertDialog(exception: e).show(context);
                }
              },
            ),
            SignUpClientForm2(
              onSaved: ({
                required File imageFile,
                required String? bio,
                required String activity,
              }) {
                _imageFile = imageFile;
                _bio = bio;
                _activity = activity;
                sendClientInfo();
              },
            ),
          ],
        ),
      ),
    );
  }
}
