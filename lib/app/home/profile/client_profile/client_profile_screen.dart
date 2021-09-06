import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_widget.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/common/profile_posts_tab_bar.dart';
import 'package:randolina/app/home/profile/common/saved_posts_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
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
  int type = 0;
  late List<Post> posts;
  late List<Post> sortedPosts;
  late final PostBloc postBloc;
  late final List<Widget> postsWidget;
  late final Future<List<Post>> postsFuture;

  @override
  void initState() {
    postsWidget = [];
    postsFuture =
        widget.bloc.getPosts(showProfileAsOther: widget.showProfileAsOther);
    postBloc = PostBloc(
      currentUser: context.read<User>(),
      database: context.read<Database>(),
    );
    super.initState();
  }

  List<Widget> buildList() {
    postsWidget.clear();
    sortedPosts = widget.bloc.sortPost(posts, type);
    return sortedPosts.map((post) {
      return PostWidget(post: post, postBloc: postBloc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    logger.info('rebuilding the whole screen');
    return FutureBuilder<List<Post>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          posts = snapshot.data!;
          return DefaultTabController(
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
                          bloc: widget.bloc,
                        ),
                      ),
                    );
                  },
                  onSavePressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SavedPostsScreen(bloc: widget.bloc),
                      ),
                    );
                  },
                ),
                if (true) ...[
                  ProfilePostsTabBar(
                    onTabChanged: (t) {
                      type = t;
                      setState(() {});
                    },
                  ),
                  FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 500)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: buildList(),
                        );
                      } else {
                        return CircularProgressIndicator(
                          color: Colors.grey,
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        }
        return SizedBox(
          height: SizeConfig.screenHeight,
          child: LoadingScreen(showAppBar: false),
        );
      },
    );
  }
}
