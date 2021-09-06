import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:randolina/app/home/create/core/filtered_image_converter.dart';
import 'package:randolina/app/home/create/core/filters.dart';
import 'package:randolina/app/home/create/core/liquid_swipe_pages.dart';
import 'package:randolina/app/models/story.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

const kBlueColorTextStyle = TextStyle(color: Colors.blue);
final Color kBlueColorWithOpacity = Colors.blue.withOpacity(0.8);

class CreateStoryScreen extends StatefulWidget {
  final File imageFile;
  final PostContentType postContentType;
  const CreateStoryScreen({
    required this.imageFile,
    required this.postContentType,
  });
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
    final User _currentUser = Provider.of<User>(context);

    setState(() {
      _screenSize = MediaQuery.of(context).size;
      _filterPages = LiquidSwipePagesService.getImageFilteredPaged(
        imageFile: widget.imageFile,
        height: _screenSize.height,
        width: _screenSize.width,
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: SizedBox(
                child: LiquidSwipe(
                  pages: _filterPages,
                  onPageChangeCallback: (value) {
                    _setFilterTitle(value);
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

          if (_isLoading)
            // desplays circular indicator if posting story
            Align(
              child: CircularProgressIndicator(),
            ),

          // displays post buttons on bottom of the screen
          if (!_isLoading) _displayBottomButtons(_currentUser),
        ],
      ),
    );
  }

  void _setFilterTitle(int title) {
    setState(() {
      _filterTitle = filters[title].name;
      _newFilterTitle = true;
    });
    Timer(Duration(milliseconds: 1000), () {
      if (_filterTitle == filters[title].name) {
        setState(() => _newFilterTitle = false);
      }
    });
  }

  Align _displayBottomButtons(User _currentUser) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () => _createStory(_currentUser.id),
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 15.0,
                  backgroundImage:
                      CachedNetworkImageProvider(_currentUser.profilePicture),
                ),
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

  Future<void> _createStory(String currentUserId) async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      final File? imageFile =
          await FilteredImageConverter.convert(globalKey: _globalKey);
      if (imageFile == null) {
        PlatformAlertDialog(
          title: 'Could not convert image.',
          content: '',
        ).show(context);
        return;
      }

      final Database database = context.read<Database>();
      final User user = context.read<User>();
      final String storyId = database.getUniqueId();

      final String imageUrl = await database.uploadFile(
        path: APIPath.storyFiles(user.id, storyId, database.getUniqueId()),
        filePath: widget.imageFile.path,
      );

      final Story story = Story(
        type: widget.postContentType.index,
        createdBy: context.read<User>().id,
        createdAt: Timestamp.now(),
        content: imageUrl,
      );

      await database.setData(
        path: APIPath.storyDocument(storyId),
        data: story.toMap(),
      );

      setState(() => _isLoading == false);
      Navigator.of(context).pop();
    }
  }
}
