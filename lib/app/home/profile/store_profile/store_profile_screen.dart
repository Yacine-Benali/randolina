import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_widget.dart';
import 'package:randolina/app/home/profile/club_profile/club_header/club_header.dart';
import 'package:randolina/app/home/profile/common/profile_posts_tab_bar.dart';
import 'package:randolina/app/home/profile/common/saved_posts_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/home/profile/store_profile/store_edit_profile.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/services/database.dart';

class StoreProfileScreen extends StatefulWidget {
  const StoreProfileScreen({
    Key? key,
    required this.store,
    required this.showProfileAsOther,
    required this.isFollowingOther,
    required this.bloc,
  }) : super(key: key);

  // this is either a club or an agency
  final User store;
  final ProfileBloc bloc;
  final bool showProfileAsOther;
  final bool? isFollowingOther;

  @override
  _StoreProfileScreenState createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
  int type = 0;
  late List<Post> posts;
  late List<Post> sortedPosts;
  late final PostBloc postBloc;
  late final List<Widget> postsWidget;
  late Future<List<Post>> postsFuture;

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

  @override
  void didUpdateWidget(StoreProfileScreen oldWidget) {
    postsFuture =
        widget.bloc.getPosts(showProfileAsOther: widget.showProfileAsOther);
    super.didUpdateWidget(oldWidget);
  }

  List<Widget> buildList() {
    postsWidget.clear();
    sortedPosts = widget.bloc.sortPost(posts, type);
    return sortedPosts.map((post) {
      return PostWidget(key: UniqueKey(), post: post, postBloc: postBloc);
    }).toList();
  }

  List<Widget> buildMiddleText() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Voir tous les événements',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('événements récents...'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data != null)) {
          posts = snapshot.data!;
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                ClubHeader(
                  clubOrAgency: widget.store,
                  bloc: widget.bloc,
                  showProfileAsOther: widget.showProfileAsOther,
                  onSavePressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SavedPostsScreen(bloc: widget.bloc),
                      ),
                    );
                  },
                  onEditPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StoreEditProfile(
                          bloc: widget.bloc,
                        ),
                      ),
                    );
                  },
                  onMoreInfoPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ClubMoreInfoScreen(
                    //       clubOrAgency: widget.clubOrAgency,
                    //       bloc: widget.bloc,
                    //       isFollowingOther: widget.isFollowingOther!,
                    //     ),
                    //   ),
                    // );
                  },
                  isFollowingOther: widget.isFollowingOther,
                ),
                // ...buildMiddleText(),
                Container(
                  color: Colors.purple,
                  height: 150,
                  width: SizeConfig.screenWidth,
                ),
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
