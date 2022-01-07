import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/miniuser_to_profile.dart';
import 'package:randolina/constants/strings.dart';
import 'package:randolina/services/algolia_service.dart';

class DataSearch extends SearchDelegate<String> {
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
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(47),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: f.profilePicture,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                title: Text(f.name),
                subtitle: Text(f.username),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => MiniuserToProfile(miniUser: f),
                    ),
                  );
                },
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
