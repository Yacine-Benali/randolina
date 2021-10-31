import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/approved/approved_bloc.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/common_widgets/date_picker.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/logger.dart';

class AgencyDetailScreen extends StatefulWidget {
  const AgencyDetailScreen({
    Key? key,
    required this.agency,
    required this.bloc,
  }) : super(key: key);
  final Agency agency;
  final ApprovedBloc bloc;

  @override
  _AgencyDetailScreenState createState() => _AgencyDetailScreenState();
}

class _AgencyDetailScreenState extends State<AgencyDetailScreen> {
  @override
  void initState() {
    logger.info(widget.agency.id);

    super.initState();
  }

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
                initialValue: widget.agency.presidentName,
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
                initialValue: widget.agency.name,
                fillColor: Colors.white70,
                title: "Nom d'agence:",
                hintText: "Nom d'agence...",
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              DatePicker(
                isEnabled: false,
                titleStyle: TextStyle(),
                title: 'date de création',
                hintText: 'DD/MM/YYYY',
                selectedDate: widget.agency.creationDate,
                onSelectedDate: (Timestamp date) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.agency.address,
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
                initialValue: widget.agency.username,
                fillColor: Colors.white70,
                title: "Nom d'utilisateur:",
                hintText: "Nom d'utilisateur...",
                maxLength: 50,
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.agency.email,
                fillColor: Colors.white70,
                title: 'Email',
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.agency.phoneNumber,
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
                onPressed: () {
                  widget.bloc.approveUser(widget.agency);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
