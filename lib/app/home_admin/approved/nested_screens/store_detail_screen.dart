import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/approved/approved_bloc.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/logger.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({
    Key? key,
    required this.store,
    required this.bloc,
  }) : super(key: key);
  final Store store;
  final ApprovedBloc bloc;

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  @override
  void initState() {
    logger.info(widget.store.id);

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
                initialValue: widget.store.ownerName,
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
                initialValue: widget.store.name,
                fillColor: Colors.white70,
                title: "Nom d'agence:",
                hintText: "Nom d'agence...",
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.store.address,
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
                initialValue: widget.store.username,
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
                initialValue: widget.store.email,
                fillColor: Colors.white70,
                title: 'Email',
                textInputAction: TextInputAction.next,
                onChanged: (var value) {},
                validator: (String? value) {},
              ),
              CustomTextForm(
                isEnabled: false,
                titleStyle: TextStyle(),
                initialValue: widget.store.phoneNumber,
                fillColor: Colors.white70,
                title: 'Numéro de téléphone:',
                maxLength: 10,
                textInputAction: TextInputAction.done,
                isPhoneNumber: true,
                onChanged: (var value) {},
                prefix: IntrinsicHeight(
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
                validator: (String? value) {},
              ),
              CustomElevatedButton(
                minHeight: 35,
                minWidth: 150,
                buttonText: Text('approve'),
                onPressed: () {
                  widget.bloc.approveUser(widget.store);
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
