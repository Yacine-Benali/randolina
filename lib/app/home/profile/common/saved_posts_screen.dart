import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_widget.dart';
import 'package:randolina/app/home/profile/common/profile_posts_tab_bar.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final ProfileBloc bloc;

  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  int type = 0;
  late List<Post> posts;
  late List<Post> sortedPosts;
  late final PostBloc postBloc;
  late final List<Widget> postsWidget;
  late final Future<List<Post>> postsFuture;

  @override
  void initState() {
    postsWidget = [];
    postsFuture = widget.bloc.getSavedPosts();
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
      return PostWidget(key: UniqueKey(), post: post, postBloc: postBloc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>?>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          posts = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Saved posts', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
            ),
            body: DefaultTabController(
              length: 3,
              child: SingleChildScrollView(
                child: Material(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      ProfilePostsTabBar(
                        onTabChanged: (t) {
                          type = t;
                          setState(() {});
                        },
                      ),
                      FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 500)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                  ),
                ),
              ),
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
