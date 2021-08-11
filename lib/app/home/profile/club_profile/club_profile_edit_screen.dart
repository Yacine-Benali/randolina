import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_scaffold.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/constants/app_constants.dart';
import 'package:randolina/constants/strings.dart';

class ClubProfileEditScreen extends StatefulWidget {
  const ClubProfileEditScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final ProfileBloc bloc;
  @override
  _ClubProfileEditScreenState createState() => _ClubProfileEditScreenState();
}

class _ClubProfileEditScreenState extends State<ClubProfileEditScreen> {
  late final TextStyle titleStyle;
  String? bio;
  late List<String>? activities;
  late User clubOrAgency;

  @override
  void initState() {
    clubOrAgency = context.read<User>();
    titleStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
    if (clubOrAgency is Club) {
      activities = (clubOrAgency as Club).activities;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    clubOrAgency = context.read<User>();

    return SafeArea(
      child: CustomScaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            ClubHeader(
              clubOrAgency: clubOrAgency,
              showProfileAsOther: false,
              bloc: widget.bloc,
              onEditPressed: () {},
              isFollowingOther: false,
              onMoreInfoPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  CustomTextForm(
                    textInputAction: TextInputAction.newline,
                    textInputType: TextInputType.multiline,
                    lines: 3,
                    maxLength: 100,
                    initialValue: clubOrAgency.bio,
                    title: 'Bio:',
                    titleStyle: titleStyle,
                    hintText: 'Bio...',
                    onChanged: (String value) {
                      bio = value;
                    },
                    validator: (v) {},
                  ),
                  if (activities != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: MultiSelectFormField(
                        initialValue: activities,
                        validator: (values) {
                          if (values != null) {
                            final List<dynamic> temp = values as List<dynamic>;

                            if (temp.isEmpty) {
                              return invalidClubActivitiesError;
                            }
                          } else {
                            return invalidClubActivitiesError;
                          }
                        },
                        chipBackGroundColor: gradientStart,
                        //  errorText: '*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        chipLabelStyle: TextStyle(color: Colors.white),
                        dialogTextStyle: TextStyle(color: Colors.black),
                        checkBoxActiveColor: Colors.blue,
                        checkBoxCheckColor: Colors.white,
                        title: Text('Choose activities', style: titleStyle),
                        dataSource: clubActivities,
                        textField: clubKey,
                        valueField: clubValue,
                        hintWidget: Text(
                          'Please choose one or more activities',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onSaved: (values) {
                          if (values == null) return;
                          final List<String> temp = (values as List<dynamic>)
                              .map((e) => e.toString())
                              .toList();
                          setState(() {
                            activities = temp;
                          });
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 70),
                  CustomElevatedButton(
                    buttonText: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      if (clubOrAgency is Club && activities != null) {
                        await widget.bloc.saveClubProfile(bio, activities!);
                      } else if (clubOrAgency is Agency) {
                        await widget.bloc.saveAgencyProfile(bio);
                      }
                      Navigator.of(context).pop();
                    },
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
