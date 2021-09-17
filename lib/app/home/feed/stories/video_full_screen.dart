import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/feed_bloc.dart';
import 'package:randolina/app/models/mini_story.dart';
import 'package:randolina/app/models/story.dart';

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen({
    Key? key,
    required this.miniStory,
    required this.feedBloc,
  }) : super(key: key);
  final MiniStory miniStory;
  final FeedBloc feedBloc;

  @override
  _VideoFullScreenState createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  late final BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    final BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: true,
      fit: BoxFit.cover,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableProgressText: false,
        enableSkips: false,
        enableFullscreen: false,
        enableSubtitles: false,
        enableMute: false,
        enableAudioTracks: false,
        enableQualities: false,
      ),
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: FutureBuilder<Story?>(
          future: widget.feedBloc.getStory(widget.miniStory),
          builder: (context, snapshot) {
            if (snapshot.hasData && (snapshot.data != null)) {
              final Story story = snapshot.data!;
              final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
                  BetterPlayerDataSourceType.network, story.content);
              _betterPlayerController.setupDataSource(dataSource);

              return BetterPlayer(controller: _betterPlayerController);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
