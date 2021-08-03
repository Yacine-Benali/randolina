import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/feed/post_widget/post_widget.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/home/profile/profile_posts.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class ClientProfileScreen extends StatefulWidget {
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
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  int max = 0;
  late List<Post> posts;

  List<Widget> buildList() {
    logger.info("**************");

    List<Widget> list2 = posts.map((e) => PostWidget(post: e)).toList();

    return list2;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: context.read<Database>().fetchCollection(
            path: APIPath.postsCollection(),
            builder: (data, id) => Post.fromMap(data, id),
          ),
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          posts = snapshot.data!;
          return Container(
            color: backgroundColor,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  ClientHeader(
                    client: widget.client,
                    isFollowingOther: widget.isFollowingOther,
                    showProfileAsOther: widget.showProfileAsOther,
                    onEditPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ClientProfileEditScreen(
                            currentClient: widget.client,
                            bloc: widget.bloc,
                          ),
                        ),
                      );
                    },
                  ),
                  ProfilePosts(
                    onTabChanged: (t) {
                      logger.severe(t);
                      max = 2;
                      setState(() {});
                    },
                  ),
                  ...buildList(),
                ],
              ),
            ),
          );
        }
        return SizedBox(
            height: SizeConfig.screenHeight, child: LoadingScreen());
      },
    );
  }
}
