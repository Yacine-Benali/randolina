import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_widget.dart';
import 'package:randolina/app/home_admin/admin_logout.dart';
import 'package:randolina/app/home_admin/reported_posts/reported_posts_bloc.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class ReportedPostsScreen extends StatefulWidget {
  const ReportedPostsScreen({Key? key}) : super(key: key);

  @override
  _ReportedPostsScreenState createState() => _ReportedPostsScreenState();
}

class _ReportedPostsScreenState extends State<ReportedPostsScreen> {
  late final ReportedPostsBloc bloc;
  late Stream<List<Post>> postsStream;
  late List<Post> posts;
  late PostBloc postBloc;
  final ScrollController listScrollController = ScrollController();
  late bool isLoadingNextMessages;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    isLoadingNextMessages = false;

    bloc = ReportedPostsBloc(database: context.read<Database>());

    bloc.fetch10Posts();
    postsStream = bloc.postsStream;
    postBloc = PostBloc(
      currentUser: context.read<User>(),
      database: context.read<Database>(),
    );

    listScrollController.addListener(() {
      final double maxScroll = listScrollController.position.maxScrollExtent;
      final double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        if (posts.isNotEmpty) {
          setState(() {
            isLoadingNextMessages = true;
          });
          bloc.fetch10Posts().then((value) {
            setState(() {
              isLoadingNextMessages = false;
            });
          });
        }
      }
    });
    super.initState();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoadingNextMessages ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await bloc.startFresh();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [AdminLogout()],
          backgroundColor: Colors.white,
        ),
        backgroundColor: backgroundColor,
        body: StreamBuilder<List<Post>>(
            stream: postsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                posts = snapshot.data!;

                if (posts.isNotEmpty) {
                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      // +1 to include the loading widget
                      itemCount: posts.length + 1 + 1,
                      controller: listScrollController,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(height: 50);
                        }
                        if (index == posts.length + 1) {
                          return _buildProgressIndicator();
                        } else {
                          return PostWidget(
                            post: posts[index - 1],
                            postBloc: postBloc,
                            showDeleteOption: true,
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: Column(
                      children: [
                        EmptyContent(
                          title: "fil d'actualité est vide",
                          message: '',
                        ),
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return EmptyContent(
                  title: "Quelque chose s'est mal passé",
                  message: "Impossible de charger les éléments pour le moment",
                );
              } else {
                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              }
            }),
      ),
    );
  }
}
