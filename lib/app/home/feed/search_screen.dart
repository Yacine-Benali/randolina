import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/miniuser_to_profile.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/services/algolia_service.dart';

class DataSearch extends SearchDelegate<String> {
  final algoliaService = AlgoliaService.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<MiniUser>>(
      future: algoliaService.performUserQuery(text: query),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final movies = snapshot.data!.map((f) {
            return ListTile(
              leading: Image.network(f.profilePicture),
              title: Text(f.name),
              subtitle: Text(f.username),
              onTap: () {
                //! todo @high you cant search and click on yourself
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => MiniuserToProfile(miniUser: f),
                  ),
                );
              },
            );
          }).toList();

          return ListView(children: movies);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
