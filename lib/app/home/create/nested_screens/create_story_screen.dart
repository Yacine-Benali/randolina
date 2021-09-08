import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:randolina/app/home/create/core/filtered_image_converter.dart';
import 'package:randolina/app/home/create/core/filters.dart';
import 'package:randolina/app/home/create/core/liquid_swipe_pages.dart';
import 'package:randolina/app/home/create/create_bloc.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:video_player/video_player.dart';

const kBlueColorTextStyle = TextStyle(color: Colors.blue);
final Color kBlueColorWithOpacity = Colors.blue.withOpacity(0.8);

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({
    required this.finalFile,
    required this.postContentType,
    required this.createBloc,
  });

  final File finalFile;
  final PostContentType postContentType;
  final CreateBloc createBloc;

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final GlobalKey _globalKey = GlobalKey();
  String _filterTitle = '';
  bool _newFilterTitle = false;
  bool _isLoading = false;
  final LiquidController _liquidController = LiquidController();
  late Size _screenSize;
  late List<Container> _filterPages;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _screenSize = MediaQuery.of(context).size;
      _filterPages = LiquidSwipePagesService.getImageFilteredPaged(
        imageFile: widget.finalFile,
        height: _screenSize.height,
        width: _screenSize.width,
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          if (widget.postContentType == PostContentType.image) ...[
            Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: SizedBox(
                  child: LiquidSwipe(
                    pages: _filterPages,
                    onPageChangeCallback: (value) {
                      setState(() {
                        _filterTitle = filters[value].name;
                        _newFilterTitle = true;
                      });
                      Timer(Duration(milliseconds: 1000), () {
                        if (_filterTitle == filters[value].name) {
                          setState(() => _newFilterTitle = false);
                        }
                      });
                    },
                    liquidController: _liquidController,
                    ignoreUserGestureWhileAnimating: true,
                  ),
                ),
              ),
            ),
            if (_newFilterTitle)
              // displays filter title once filtered changed
              _displayStoryFilterTitle(),
          ],
          if (widget.postContentType == PostContentType.video) ...[
            Center(
              child: BetterPlayer.file(
                widget.finalFile.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  fit: BoxFit.contain,
                  aspectRatio: 1,
                  autoDetectFullscreenDeviceOrientation: true,
                  controlsConfiguration: BetterPlayerControlsConfiguration(
                    enableProgressText: false,
                    enableSkips: false,
                    enableFullscreen: false,
                    enableSubtitles: false,
                    enableMute: false,
                    enableAudioTracks: false,
                    enableQualities: false,
                  ),
                ),
              ),
            ),
          ],

          if (_isLoading)
            // desplays circular indicator if posting story
            Align(
              child: CircularProgressIndicator(),
            ),

          // displays post buttons on bottom of the screen
          if (!_isLoading) _displayBottomButtons(),
        ],
      ),
    );
  }

  Align _displayBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () => _createStory(),
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Post Story',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Align _displayStoryFilterTitle() {
    return Align(
      child: Text(
        _filterTitle,
        style: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Future<void> _createStory() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      final File? finalFile;

      if (widget.postContentType == PostContentType.image) {
        finalFile = await FilteredImageConverter.convert(globalKey: _globalKey);
        if (finalFile == null) {
          PlatformAlertDialog(
            title: 'Could not convert image.',
            content: '',
          ).show(context);
          return;
        }
      } else {
        // its a video
        finalFile = widget.finalFile;

        final VideoPlayerController controller =
            VideoPlayerController.file(widget.finalFile);
        await controller.initialize();
        if (controller.value.duration.inSeconds > 15) {
          PlatformAlertDialog(
            title: 'Video exceeds 15 seconds can not post it to stories',
            content: '',
          ).show(context);
          return;
        }
      }

      await widget.createBloc
          .createStory(finalFile.path, widget.postContentType);

      setState(() => _isLoading == false);
      Navigator.of(context).pop();
    }
  }
}
