import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:randolina/utils/logger.dart';
import 'package:story/story_page_view/story_page_view.dart';

class StoryVideoLoader extends StatefulWidget {
  const StoryVideoLoader({
    Key? key,
    required this.indicatorAnimationController,
    required this.url,
    //  required this.betterPlayerController,
  }) : super(key: key);
  final ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  //final BetterPlayerController betterPlayerController;
  final String url;
  @override
  _StoryVideoLoaderState createState() => _StoryVideoLoaderState();
}

class _StoryVideoLoaderState extends State<StoryVideoLoader> {
  late final BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    final BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: true,
      fit: BoxFit.cover,
      autoDispose: false,
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
    final BetterPlayerDataSource dataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    logger.severe('_betterPlayerController built with ${widget.url}');

    //
    _betterPlayerController.setupDataSource(dataSource);
    //
    _betterPlayerController.addEventsListener((BetterPlayerEvent b) {
      if (b.betterPlayerEventType == BetterPlayerEventType.play) {
        widget.indicatorAnimationController.value =
            IndicatorAnimationCommand.resume;
      }
    });

    widget.indicatorAnimationController.addListener(listner);

    super.initState();
  }

  @override
  void dispose() {
    widget.indicatorAnimationController.removeListener(listner);
    _betterPlayerController.dispose();
    logger.severe('_betterPlayerController disposed');
    super.dispose();
  }

  void listner() {
    switch (widget.indicatorAnimationController.value) {
      case IndicatorAnimationCommand.pause:
        _betterPlayerController.pause();
        break;
      case IndicatorAnimationCommand.resume:
      default:
        _betterPlayerController.play();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      logger.info('video is mounted');
      return Container(
        color: Colors.green,
      );
      // return BetterPlayer(
      //   key: Key(widget.url),
      //   controller: _betterPlayerController,
      // );
    } else {
      logger.info('video is not  mounted');

      return Container(
        color: Colors.red,
      );
    }
  }
}
