import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/approved/approved_bloc.dart';
import 'package:randolina/app/home_admin/approved/approved_user_tile.dart';
import 'package:randolina/app/models/user.dart';

class ApproveSearch extends SearchDelegate<String> {
  ApproveSearch({
    required this.users,
    required this.approvedBloc,
  });

  final List<User> users;
  final ApprovedBloc approvedBloc;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, 'value');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildResult(context);
  @override
  Widget buildSuggestions(BuildContext context) => buildResult(context);

  Widget buildResult(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (_, index) {
        if (users[index].name.toLowerCase().contains(query.toLowerCase())) {
          return ApprovedUserTile(user: users[index], bloc: approvedBloc);
        } else {
          return Container();
        }
      },
    );
  }
}
