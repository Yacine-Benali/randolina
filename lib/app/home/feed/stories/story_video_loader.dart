import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:story/story_page_view/story_page_view.dart';

class StoryVideoLoader extends StatefulWidget {
  const StoryVideoLoader({
    Key? key,
    required this.indicatorAnimationController,
    required this.url,
  }) : super(key: key);
  final ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  final String url;
  @override
  _StoryVideoLoaderState createState() => _StoryVideoLoaderState();
}

class _StoryVideoLoaderState extends State<StoryVideoLoader> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    final BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
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
    final BetterPlayerDataSource dataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.url);

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
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
    return BetterPlayer(controller: _betterPlayerController);
  }
}
