import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/feed/post_widget/post_bloc.dart';
import 'package:randolina/app/home/feed/post_widget/post_widget.dart';
import 'package:randolina/app/home/profile/client_profile/client_header/client_header.dart';
import 'package:randolina/app/home/profile/client_profile/client_profile_edit_screen.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/home/profile/profile_posts.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/services/database.dart';

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
  late final PostBloc postBloc;
  late final List<Widget> list2;
  late final Future<List<Post>> postsFuture;

  @override
  void initState() {
    list2 = [];
    postsFuture = widget.bloc.getPosts();
    postBloc = PostBloc(
      currentUser: context.read<User>(),
      database: context.read<Database>(),
    );
    super.initState();
  }

  List<Widget> buildList() {
    list2.clear();
    for (final Post post in posts) {
      switch (type) {
        case 0:
          final PostWidget w =
              PostWidget(key: UniqueKey(), post: post, postBloc: postBloc);
          list2.add(w);
          break;
        case 1:
          if (post.type == 0) {
            final PostWidget w =
                PostWidget(key: UniqueKey(), post: post, postBloc: postBloc);
            list2.add(w);
          }
          break;
        case 2:
          if (post.type > 0) {
            final PostWidget w =
                PostWidget(key: UniqueKey(), post: post, postBloc: postBloc);
            list2.add(w);
          }
          break;
      }
    }

    return list2;
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
                ),
                ProfilePosts(
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
                    }),
              ],
            ),
          );
        }
        return SizedBox(
          height: SizeConfig.screenHeight,
          child: LoadingScreen(),
        );
      },
    );
  }
}
