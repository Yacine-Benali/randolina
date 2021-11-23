import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/subscribers/sub_bloc.dart';
import 'package:randolina/app/home_admin/subscribers/sub_tile.dart';
import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/algolia_service.dart';
import 'package:tuple/tuple.dart';

class SubSearch extends SearchDelegate<String> {
  SubSearch({
    required this.users,
    required this.subBloc,
  });

  final List<Tuple2<Subscription, User>> users;
  final SubBloc subBloc;

  final algoliaService = AlgoliaService.instance;

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
        if (users[index]
            .item2
            .name
            .toLowerCase()
            .contains(query.toLowerCase())) {
          return SubTile(
            key: Key(users[index].item1.id),
            tuple: users[index],
            subBloc: subBloc,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
