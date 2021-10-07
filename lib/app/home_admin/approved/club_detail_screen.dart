import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/date_picker.dart';
import 'package:randolina/constants/app_colors.dart';

class ClubDetailScreen extends StatefulWidget {
  const ClubDetailScreen({
    Key? key,
    required this.club,
  }) : super(key: key);
  final Club club;

  @override
  _ClubDetailScreenState createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "détail de l'utilisateur",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.presidentName,
                fillColor: Colors.white70,
                title: 'Nom et prénom:',
                hintText: 'Nom et prénom...',
                maxLength: 50,
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.name,
                fillColor: Colors.white70,
                title: 'Nom du club:',
                hintText: 'Nom du club...',
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              DatePicker(
                isEnabled: false,
                titleStyle: TextStyle(),
                title: 'date de création',
                hintText: 'DD/MM/YYYY',
                selectedDate: widget.club.creationDate,
                onSelectedDate: (Timestamp date) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.address,
                fillColor: Colors.white70,
                title: 'Localisation:',
                hintText: 'Oran,Alger...',
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.members.toString(),
                fillColor: Colors.white70,
                title: 'Nombre de membres:',
                hintText: 'Nombre de membres:',
                maxLength: 6,
                isPhoneNumber: true,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.username,
                fillColor: Colors.white70,
                title: "Nom d'utilisation:",
                hintText: "Nom d'utilisation...",
                maxLength: 50,
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.email,
                fillColor: Colors.white70,
                title: 'Email',
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.club.phoneNumber,
                fillColor: Colors.white70,
                title: 'Numéro de téléphone:',
                maxLength: 10,
                textInputAction: TextInputAction.done,
                isPhoneNumber: true,
                onChanged: (var value) {},
                prefix: Padding(
                  //padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                  padding: const EdgeInsets.all(0),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '+213',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 57,
                          child: VerticalDivider(
                            thickness: 1,
                            width: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                validator: (String? value) {},
              ),
              CustomElevatedButton(
                minHeight: 35,
                minWidth: 150,
                buttonText: Text('approve'),
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
