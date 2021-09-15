import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:randolina/app/home/feed/feed_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_widget.dart';
import 'package:randolina/app/home/feed/stories/stories_list_widget.dart';
import 'package:randolina/app/home/feed/widgets/feed_app_bar.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late FeedBloc bloc;
  late Stream<List<Post>> postsStream;
  late List<Post> posts;
  late PostBloc postBloc;
  final ScrollController listScrollController = ScrollController();
  late bool isLoadingNextMessages;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    isLoadingNextMessages = false;
    bloc = FeedBloc(
      currentUser: context.read<User>(),
      database: context.read<Database>(),
    );
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
        logger.info('load more messages');

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
                      itemCount: posts.length + 1 + 1 + 1,
                      controller: listScrollController,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return FeedAppBar();
                        } else if (index == 1) {
                          return StoriesListWidget(feedBloc: bloc);
                        }
                        if (index == posts.length + 2) {
                          return _buildProgressIndicator();
                        } else {
                          return PostWidget(
                            post: posts[index - 1 - 1],
                            postBloc: postBloc,
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
                        FeedAppBar(),
                        StoriesListWidget(feedBloc: bloc),
                        EmptyContent(
                          title: 'feed is empty',
                          message: '',
                        ),
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return EmptyContent(
                  title: 'Something went wrong',
                  message: "Can't load items right now",
                );
              } else {
                return Column(
                  children: [
                    FeedAppBar(),
                    StoriesListWidget(feedBloc: bloc),
                    CircularProgressIndicator(),
                  ],
                );
              }
            }),
      ),
    );
  }
}
