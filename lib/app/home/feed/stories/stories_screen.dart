import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/feed_bloc.dart';
import 'package:randolina/app/home/feed/stories/story_video_loader.dart';
import 'package:randolina/app/models/mini_story.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/story.dart';
import 'package:randolina/app/models/user_followers_stories.dart';
import 'package:randolina/utils/logger.dart';
import 'package:story/story_page_view/story_page_view.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({
    Key? key,
    required this.usersStories,
    required this.initialPage,
    required this.feedBloc,
  }) : super(key: key);
  final List<UserFollowersStories> usersStories;
  final int initialPage;
  final FeedBloc feedBloc;
  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  late final BetterPlayerConfiguration betterPlayerConfiguration;
  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);

    betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: true,
      fit: BoxFit.cover,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableProgressText: false,
        enableSkips: false,
        showControlsOnInitialize: false,
        showControls: false,
        enableSubtitles: false,
        enableMute: false,
        enableAudioTracks: false,
      ),
    );
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  Widget buildStoryView(Story story) {
    indicatorAnimationController.value = IndicatorAnimationCommand.pause;

    if (story.type == 0) {
      return Positioned.fill(
        child: CachedNetworkImage(
          imageUrl: story.content,
          imageBuilder: (context, imageProvider) {
            indicatorAnimationController.value =
                IndicatorAnimationCommand.resume;

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider),
              ),
            );
          },
          errorWidget: (context, url, error) {
            indicatorAnimationController.value =
                IndicatorAnimationCommand.resume;
            return Text('Unable to load story');
          },
        ),
      );
    } else if (story.type == 1) {
      // final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      //   BetterPlayerDataSourceType.network,
      //   story.content,
      // );
      // final BetterPlayerController betterPlayerController =
      //     BetterPlayerController(betterPlayerConfiguration);
      // betterPlayerController.setupDataSource(dataSource);

      return StoryVideoLoader(
        key: Key(story.content),
        indicatorAnimationController: indicatorAnimationController,
        url: story.content,
        //  betterPlayerController: betterPlayerController,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: StoryPageView(
          indicatorDuration: Duration(seconds: 30),
          indicatorAnimationController: indicatorAnimationController,

          initialPage: widget.initialPage,
          //
          pageLength: widget.usersStories.length,
          //
          storyLength: (int pageIndex) =>
              widget.usersStories[pageIndex].storiesIds.length,
          //
          initialStoryIndex: (pageIndex) => 0,
          //
          onPageLimitReached: () => Navigator.pop(context),
          //
          itemBuilder: (context, pageIndex, storyIndex) {
            logger.info('build page $pageIndex story: $storyIndex');
            final MiniUser user = widget.usersStories[pageIndex].miniUser;
            final MiniStory miniStory =
                widget.usersStories[pageIndex].storiesIds[storyIndex];

            return Stack(
              key: UniqueKey(),
              children: [
                Positioned.fill(child: Container(color: Colors.black)),
                FutureBuilder<Story?>(
                  future: widget.feedBloc.getStory(miniStory),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && (snapshot.data != null)) {
                      final Story story = snapshot.data!;
                      return buildStoryView(story);
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 8),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: user.profilePicture,
                        imageBuilder: (_, imageProvider) {
                          return Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          gestureItemBuilder: (context, pageIndex, storyIndex) {
            return Stack(children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
