import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/services/database.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  late final User currentUser;
  late final ProfileBloc bloc;
  late final bool showProfileAsOther;
  Future<bool>? isFollowingOther;

  @override
  void initState() {
    currentUser = context.read<User>();

    bloc = ProfileBloc(
      database: context.read<Database>(),
      currentUser: currentUser,
      otherUser: widget.client,
    );
    if (currentUser.id != widget.client.id) {
      showProfileAsOther = true;
      isFollowingOther = bloc.isFollowing();
    } else {
      showProfileAsOther = false;
      isFollowingOther = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProfileBloc>.value(
      value: bloc,
      child: Material(
        child: FutureBuilder<bool>(
            future: isFollowingOther,
            builder: (context, snapshot) {
              if (snapshot.hasData || showProfileAsOther == false) {
                return SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ClientHeader(
                              client: widget.client,
                              isFollowingOther: snapshot.data,
                              showProfileAsOther: showProfileAsOther,
                              onEditPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClientProfileEditScreen(
                                      currentClient: currentUser as Client,
                                      bloc: bloc,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showProfileAsOther) ...[
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
                        ),
                      ],
                    ],
                  ),
                );
              }
              return LoadingScreen();
            }),
      ),
    );
  }
}
