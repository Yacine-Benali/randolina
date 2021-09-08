import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

// import 'package:instagram/screens/camera_screen/nested_screens/create_post_screen.dart';
import '../core/filtered_image_converter.dart';
import '../core/filters.dart';
import '../core/liquid_swipe_pages.dart';

class EditPhotoScreen extends StatefulWidget {
  final File imageFile;
  const EditPhotoScreen({required this.imageFile});

  @override
  _EditPhotoScreenState createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen>
    with TickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();
  final LiquidController _liquidController = LiquidController();
  late List<Container> _filterPages;
  String _filterTitle = '';
  bool _newFilterTitle = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    setState(() {
      _filterPages = LiquidSwipePagesService.getImageFilteredPaged(
          imageFile: widget.imageFile, height: size.width, width: size.width);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Photo", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        // leading: Container(),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: convertFilteredImageToImageFile,
          )
        ],
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width,
                    maxHeight: size.width,
                  ),
                  child: LiquidSwipe(
                    pages: _filterPages,
                    onPageChangeCallback: (value) {
                      setState(() => _selectedIndex = value);
                      _setFilterTitle(value);
                    },
                    liquidController: _liquidController,
                    ignoreUserGestureWhileAnimating: true,
                  ),
                ),
                if (_newFilterTitle) _displayStoryTitle(size),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: SizedBox()),
                Container(
                  color: Theme.of(context).backgroundColor,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 140,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() => _selectedIndex = index);
                              _liquidController.jumpToPage(page: index);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  _buildFilterThumbnail(index, size),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    filters[index].name,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> convertFilteredImageToImageFile() async {
    final File? file =
        await FilteredImageConverter.convert(globalKey: _globalKey);
    if (file != null) {
      Navigator.of(context).pop(file);
      // Navigator.of(_globalKey.currentContext!).push(
      //   MaterialPageRoute(
      //     builder: (context) => CreatePostScreen(
      //       imageFile: file,
      //     ),
      //   ),
      // );
    }
  }

  Container _buildFilterThumbnail(int index, Size size) {
    final Image image = Image.file(
      widget.imageFile,
      width: size.width,
      fit: BoxFit.cover,
    );

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: _selectedIndex == index
                ? Colors.blue
                : Theme.of(context).primaryColor,
            width: 4.0),
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(filters[index].matrixValues),
        child: SizedBox(
          height: 80,
          width: 80,
          child: image,
        ),
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

  Align _displayStoryTitle(Size screenSize) {
    return Align(
      child: Padding(
        padding: EdgeInsets.only(top: screenSize.width * 0.49),
        child: Text(
          _filterTitle,
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
