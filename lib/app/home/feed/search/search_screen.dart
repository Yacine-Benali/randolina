import 'package:flutter/material.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/services/algolia_service.dart';
import 'package:randolina/utils/logger.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchWidgetState();
  }
}

class SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algolia Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: Center(
        child: Text('Tap on search icon to start'),
      ),
    );
  }
}

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
    // Leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        logger.info('leader');
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
            );
          }).toList();

          return ListView(children: movies);
        } else if (snapshot.hasError) {
          //logger.severe(snapshot.error.runtimeType);
          return Center(
            child: Text("${snapshot.error.toString()}"),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
