import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/create/create_bloc.dart';
import 'package:randolina/app/home/create/nested_screens/create_post_screen.dart';
import 'package:randolina/app/home/create/nested_screens/create_story_screen.dart';
import 'package:randolina/app/home/create/nested_screens/edit_photo_screen.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/circular_icon_button.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum CameraConsumer { post, story }
enum PostContentType { image, video }

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    required this.cameras,
    required this.backToHomeScreen,
    required this.cameraConsumer,
  });

  final List<CameraDescription> cameras;
  final CameraConsumer cameraConsumer;
  final VoidCallback backToHomeScreen;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _toggleCamera = false;
  CameraController? controller;
  CameraConsumer _cameraConsumer = CameraConsumer.post;
  late CreateBloc createBloc;

  @override
  void initState() {
    createBloc = CreateBloc(
      database: context.read<Database>(),
      currentUser: context.read<User>(),
    );

    try {
      setCamera(widget.cameras[0]);
    } catch (e) {
      print(e.toString());
    }
    if (widget.cameraConsumer != CameraConsumer.post) {
      changeConsumer(widget.cameraConsumer);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!(controller?.value.isInitialized ?? false)) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Transform.scale(
              scale: controller!.value.aspectRatio / deviceRatio,
              child: AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: controller == null
                    ? Container()
                    : CameraPreview(controller!),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularIconButton(
                splashColor: Colors.blue.withOpacity(0.8),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 22,
                ),
                onTap: widget.backToHomeScreen,
              ),
            ),
          ),
          buildCameraControllers(),
        ],
      ),
    );
  }

  Widget buildCameraControllers() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // change between post and story tab
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: deprecated_member_use
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15))),
                onPressed: () => changeConsumer(CameraConsumer.post),
                color: _cameraConsumer == CameraConsumer.post
                    ? Colors.white.withOpacity(0.85)
                    : Colors.black38,
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 18,
                    color: _cameraConsumer == CameraConsumer.post
                        ? Colors.black
                        : Colors.white,
                    fontWeight: _cameraConsumer == CameraConsumer.post
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15))),
                onPressed: () => changeConsumer(CameraConsumer.story),
                color: _cameraConsumer == CameraConsumer.story
                    ? Colors.white.withOpacity(0.85)
                    : Colors.black38,
                child: Text(
                  'Story',
                  style: TextStyle(
                    fontSize: 18,
                    color: _cameraConsumer == CameraConsumer.story
                        ? Colors.black
                        : Colors.white,
                    fontWeight: _cameraConsumer == CameraConsumer.story
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // capture image
          Container(
            width: double.infinity,
            height: 120.0,
            padding: EdgeInsets.all(20.0),
            color: Colors.black45,
            child: Stack(
              children: <Widget>[
                Align(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      onTap: () {
                        _captureImage();
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/camera_images/shutter.png',
                          width: 72.0,
                          height: 72.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      onTap: () {
                        if (!_toggleCamera) {
                          setCamera(widget.cameras[1]);
                          setState(() {
                            _toggleCamera = true;
                          });
                        } else {
                          setCamera(widget.cameras[0]);
                          setState(() {
                            _toggleCamera = false;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/camera_images/switch_camera.png',
                          color: Colors.grey[200],
                          width: 42.0,
                          height: 42.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          onTap: getGalleryImage,
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/camera_images/gallery_button.png',
                              color: Colors.grey[200],
                              width: 42.0,
                              height: 42.0,
                            ),
                          ),
                        ),
                      ),
                      //! todo @high change icon
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          onTap: getGalleryVideos,
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/camera_images/gallery_button.png',
                              color: Colors.red[200],
                              width: 42.0,
                              height: 42.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeConsumer(CameraConsumer cameraConsumer) {
    if (_cameraConsumer != cameraConsumer) {
      setState(() => _cameraConsumer = cameraConsumer);
    }
  }

  Future<void> setCamera(CameraDescription cameraDescription) async {
    if (controller != null) await controller?.dispose();
    controller =
        CameraController(cameraDescription, ResolutionPreset.ultraHigh);

    controller?.addListener(() {
      if (mounted) setState(() {});
      if (controller?.value.hasError ?? false) {
        showMessage('Camera Error: ${controller?.value.errorDescription}');
      }
    });

    try {
      await controller?.initialize();
    } on CameraException catch (e) {
      showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _captureImage() async {
    if (!(controller?.value.isInitialized ?? false)) {
      showMessage('Error: select a camera first.');
    }

    try {
      final XFile xfile = await controller!.takePicture();
      if (mounted) {
        setState(() {});
        showMessage('Picture saved to ${xfile.path}');
        prepareImagesToPublish([xfile.path]);
      }
    } on CameraException catch (e) {
      showException(e);
    }
  }

  Future<void> getGalleryVideos() async {
    if (_cameraConsumer == CameraConsumer.post) {
      //List<Asset> resultList = <Asset>[];
      List<AssetEntity>? resultList2 = <AssetEntity>[];
      final List<File> finalFiles = [];

      try {
        resultList2 = await AssetPicker.pickAssets(
          context,
          textDelegate: EnglishTextDelegate(),
          maxAssets: 5,
          selectedAssets: resultList2,
          requestType: RequestType.video,
        );
        if (resultList2 == null) return;

        for (final AssetEntity asset in resultList2) {
          final File? file = await asset.file;
          if (file != null) finalFiles.add(file);
        }
        if (finalFiles.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreatePostScreen(
                finalFiles: finalFiles,
                postContentType: PostContentType.video,
                createBloc: createBloc,
              ),
            ),
          );
        }
      } on Exception catch (e) {
        PlatformExceptionAlertDialog(exception: e).show(context);
      }
    } else {
      // PickedFile? pickedFile =
      //     await _picker.getImage(source: ImageSource.gallery);
      // if (pickedFile != null) {
      //   setState(() {
      //     imagesPathList = pickedFile.path;
      //   });
      //   setCameraResult();
      // } else {
      //   print('No image selected.');
      // }
    }
  }

  Future<void> getGalleryImage() async {
    if (_cameraConsumer == CameraConsumer.post) {
      //List<Asset> resultList = <Asset>[];
      List<AssetEntity>? resultList2 = <AssetEntity>[];

      final List<String> imagesPathsList = [];
      try {
        resultList2 = await AssetPicker.pickAssets(
          context,
          textDelegate: EnglishTextDelegate(),
          maxAssets: 5,
          selectedAssets: resultList2,
        );
        if (resultList2 == null) return;

        for (final AssetEntity asset in resultList2) {
          final File? file = await asset.file;
          if (file != null) imagesPathsList.add(file.path);
        }
        if (imagesPathsList.isNotEmpty) {
          prepareImagesToPublish(imagesPathsList);
        }
      } on Exception catch (e) {
        PlatformExceptionAlertDialog(exception: e).show(context);
      }
    } else {
      // PickedFile? pickedFile =
      //     await _picker.getImage(source: ImageSource.gallery);
      // if (pickedFile != null) {
      //   setState(() {
      //     imagesPathList = pickedFile.path;
      //   });
      //   setCameraResult();
      // } else {
      //   print('No image selected.');
      // }
    }
  }

  Future<void> prepareImagesToPublish(List<String> imagesPathsList) async {
    if (_cameraConsumer == CameraConsumer.post) {
      final List<File> finalFiles = [];
      for (final String imagePath in imagesPathsList) {
        final File? croppedImage = await ImageCropper.cropImage(
          androidUiSettings: AndroidUiSettings(
            backgroundColor: Theme.of(context).backgroundColor,
            toolbarColor: Theme.of(context).appBarTheme.color,
            toolbarWidgetColor: Theme.of(context).accentColor,
            toolbarTitle: 'Crop Photo',
            activeControlsWidgetColor: Colors.blue,
          ),
          sourcePath: imagePath,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        );

        if (croppedImage != null) {
          final File editedImage = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditPhotoScreen(imageFile: croppedImage),
            ),
          ) as File;
          finalFiles.add(editedImage);
          logger.info('edited images ${editedImage.path}');
        }
      }
      if (finalFiles.length == imagesPathsList.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreatePostScreen(
              finalFiles: finalFiles,
              postContentType: PostContentType.image,
              createBloc: createBloc,
            ),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateStoryScreen(
            imageFile: File(imagesPathsList[0]),
            postContentType: PostContentType.image,
            createBloc: createBloc,
          ),
        ),
      );
    }
  }

  void showException(CameraException e) {
    logger.severe('${e.code} ${e.description}');
    PlatformExceptionAlertDialog(exception: e).show(context);
  }

  void showMessage(String message) {
    logger.severe(message);
  }
}
