import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:randolina/app/home/create/create_bloc.dart';
import 'package:randolina/common_widgets/circular_icon_button.dart';

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
  late final BetterPlayerController _betterPlayerController;

  final String _filterTitle = '';
  final bool _newFilterTitle = false;
  final bool _isLoading = false;

  @override
  void initState() {
    if (widget.postContentType == PostContentType.video) {
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
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
        betterPlayerDataSource:
            BetterPlayerDataSource.file(widget.finalFile.path),
      );

      _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          _betterPlayerController.setOverriddenAspectRatio(
              _betterPlayerController.videoPlayerController!.value.aspectRatio);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            if (widget.postContentType == PostContentType.image) ...[
              Center(child: Image.file(widget.finalFile)),
              if (_newFilterTitle)
                // displays filter title once filtered changed
                _displayStoryFilterTitle(),
            ],
            if (widget.postContentType == PostContentType.video) ...[
              Center(child: BetterPlayer(controller: _betterPlayerController)),
            ],

            // desplays circular indicator if posting story
            if (_isLoading) Align(child: CircularProgressIndicator()),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: _createStory,
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.east_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: CircularIconButton(
                  splashColor: Colors.blue.withOpacity(0.8),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 22,
                  ),
                  onTap: Navigator.of(context).pop,
                ),
              ),
            ),

            // displays post buttons on bottom of the screen
          ],
        ),
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
      //setState(() => _isLoading = true);
      File? finalFile = widget.finalFile;

      if (widget.postContentType == PostContentType.image) {
        // finalFile = await FilteredImageConverter.convert(globalKey: _globalKey);
        // if (finalFile == null) {
        //   PlatformAlertDialog(
        //     title: 'Could not convert image.',
        //     content: '',
        //   ).show(context);
        //   return;
        // }
      } else {
        // its a video
        finalFile = widget.finalFile;
      }

      widget.createBloc
          .createStory(finalFile.path, widget.postContentType)
          .then(
            (value) => Fluttertoast.showToast(
              msg: 'Article publié avec succès',
              toastLength: Toast.LENGTH_SHORT,
            ),
          );

      setState(() => _isLoading == false);

      Navigator.of(context).pop();

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();

    super.dispose();
  }
}
