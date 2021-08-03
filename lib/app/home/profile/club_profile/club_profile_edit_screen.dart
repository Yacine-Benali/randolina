import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
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
    required this.clubOrAgency,
    required this.bloc,
  }) : super(key: key);
  final User clubOrAgency;
  final ProfileBloc bloc;
  @override
  _ClubProfileEditScreenState createState() => _ClubProfileEditScreenState();
}

class _ClubProfileEditScreenState extends State<ClubProfileEditScreen> {
  late final TextStyle titleStyle;
  String? bio;
  late List<String>? activities;

  @override
  void initState() {
    titleStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
    if (widget.clubOrAgency is Club) {
      activities = (widget.clubOrAgency as Club).activities;
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
            Stack(
              children: [
                ClubHeader(
                  clubOrAgency: widget.clubOrAgency,
                  showProfileAsOther: false,
                  onEditPressed: () {},
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
                    initialValue: widget.clubOrAgency.bio,
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
                    onPressed: () {
                      if (widget.clubOrAgency is Club && activities != null) {
                        widget.bloc.saveClubProfile(bio, activities!);
                      } else if (widget.clubOrAgency is Agency) {
                        widget.bloc.saveAgencyProfile(bio);
                      }
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
