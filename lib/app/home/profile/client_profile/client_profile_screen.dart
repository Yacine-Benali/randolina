import 'package:flutter/material.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/client.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({
    Key? key,
    required this.client,
    required this.isFollowingOther,
    required this.showProfileAsOther,
    required this.bloc,
  }) : super(key: key);
  final Client client;
  final bool? isFollowingOther;
  final bool showProfileAsOther;
  final ProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClientHeader(
          client: client,
          isFollowingOther: isFollowingOther,
          showProfileAsOther: showProfileAsOther,
          onEditPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClientProfileEditScreen(
                  currentClient: client,
                  bloc: bloc,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [],
          ),
        ),
      ],
    );
  }
}
