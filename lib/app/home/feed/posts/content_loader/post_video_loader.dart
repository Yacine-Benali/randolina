import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class PostVideoLoader extends StatefulWidget {
  const PostVideoLoader({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  _PostVideoLoaderState createState() => _PostVideoLoaderState();
}

class _PostVideoLoaderState extends State<PostVideoLoader> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    final BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fit: BoxFit.contain,
      aspectRatio: 1,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableProgressText: false,
        enableSkips: false,
        enableSubtitles: false,
        enableMute: false,
        enableAudioTracks: false,
      ),
    );
    final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _betterPlayerController);
  }
}
