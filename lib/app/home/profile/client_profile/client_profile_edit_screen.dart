import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
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
    required this.currentClient,
    required this.bloc,
  }) : super(key: key);

  final Client currentClient;
  final ProfileBloc bloc;
  @override
  _ClientProfileEditScreenState createState() =>
      _ClientProfileEditScreenState();
}

class _ClientProfileEditScreenState extends State<ClientProfileEditScreen> {
  late final TextStyle titleStyle;
  String? bio;
  late String activity;

  @override
  void initState() {
    titleStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
    activity = widget.currentClient.activity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo @high remove this line and use the given object or choose but not
    // both
    final Client client = context.read<User>() as Client;

    return SafeArea(
      child: CustomScaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Stack(
              children: [
                ClientHeader(
                  client: client,
                  isFollowingOther: false,
                  onEditPressed: () {},
                  showProfileAsOther: false,
                ),
                Positioned(
                  top: 5,
                  left: 8,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      color: Colors.black87,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  CustomTextForm(
                    initialValue: client.bio,
                    title: 'Bio:',
                    titleStyle: titleStyle,
                    lines: 4,
                    hintText: 'Bio...',
                    maxLength: 200,
                    onChanged: (String value) {
                      bio = value;
                    },
                    validator: (v) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomDropDown(
                      titleStyle: titleStyle,
                      initialValue: client.activity,
                      validator: (String? value) {
                        if (value == null) {
                          return invalidActivityError;
                        }
                        return null;
                      },
                      title: 'Activity:',
                      hint: 'Chose...',
                      options: clientActivities,
                      onChanged: (String value) {
                        activity = value;
                      },
                    ),
                  ),
                  SizedBox(height: 70),
                  CustomElevatedButton(
                    buttonText: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => widget.bloc.saveChanges(bio, activity),
                    minHeight: 30,
                    minWidth: 130,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
