import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home_admin/moderators/moderators_bloc.dart';
import 'package:randolina/app/home_admin/moderators/user_tile.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/algolia_service.dart';

class AdminSearch extends SearchDelegate<String> {
  AdminSearch({
    required this.modsIds,
    required this.moderatorsBloc,
  });

  final List<String> modsIds;
  final ModeratorsBloc moderatorsBloc;

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
    final User currentUser = context.read<User>();
    return FutureBuilder<List<MiniUser>>(
      future: algoliaService.performUserQuery(text: query),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final List<Widget> userTile = snapshot.data!.map((f) {
            if (currentUser.id != f.id) {
              return UserTile(
                moderatorsBloc: moderatorsBloc,
                miniUser: f,
                initialValue: modsIds.contains(f.id),
              );
            } else {
              return Container();
            }
          }).toList();

          return ListView(children: userTile);
        } else if (snapshot.hasError) {
          return EmptyContent(
            title: '',
            message: internetError,
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
