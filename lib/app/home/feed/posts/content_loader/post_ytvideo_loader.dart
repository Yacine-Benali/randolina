import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class PostYTVideoLoader extends StatefulWidget {
  const PostYTVideoLoader({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  _PostYTVideoLoaderState createState() => _PostYTVideoLoaderState();
}

class _PostYTVideoLoaderState extends State<PostYTVideoLoader> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(widget.url) ?? '',
      params: YoutubePlayerParams(
        playlist: [],
        showFullscreenButton: true,
        autoPlay: false,
        enableCaption: false,
        showVideoAnnotations: false,
        enableJavaScript: false,
        privacyEnhanced: true,
        useHybridComposition: false,
        playsInline: true,
      ),
    )..listen((value) {
        if (value.playerState == PlayerState.buffering) {
          String _time(Duration duration) {
            return "${duration.inMinutes}:${duration.inSeconds}";
          }

          Future.delayed(Duration(milliseconds: 1000), () {
            final bufferedTime = _controller.value.position;
            return print(_time(bufferedTime));
          });
        }

        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            ..play()
            ..hideTopMenu();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: player,
    );
  }
}
