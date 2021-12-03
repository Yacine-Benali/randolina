import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddProductForm1 extends StatefulWidget {
  const AddProductForm1({
    Key? key,
    required this.onPictureChanged,
    this.profilePicture,
  }) : super(key: key);
  final ValueChanged<File?> onPictureChanged;
  final String? profilePicture;
  @override
  _AddProductForm1State createState() => _AddProductForm1State();
}

class _AddProductForm1State extends State<AddProductForm1> {
  File? imageFile;
  //Product? product;
  Future<void> pickImage() async {
    List<AssetEntity>? pickedAssets = <AssetEntity>[];
    pickedAssets = await AssetPicker.pickAssets(
      context,
      textDelegate: EnglishTextDelegate(),
      maxAssets: 1,
      selectedAssets: pickedAssets,
      themeColor: Colors.blue,
    );
    if (pickedAssets != null) {
      final File? file = await pickedAssets[0].file;
      if (file != null) {
        final File? croppedImage = await ImageCropper.cropImage(
          androidUiSettings: AndroidUiSettings(
            backgroundColor: Colors.black,
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            toolbarTitle: 'Recadrer la photo',
            activeControlsWidgetColor: Colors.blue,
          ),
          sourcePath: file.path,
          aspectRatio: CropAspectRatio(ratioX: 16.0, ratioY: 9.0),
        );
        if (croppedImage != null) {
          imageFile = croppedImage;
          setState(() {});
        }
      }
    }
  }

  Widget buildUploadButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: pickImage,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          minimumSize: MaterialStateProperty.all(Size(200, 70)),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload pictures',
              style: TextStyle(
                color: Color.fromRGBO(51, 77, 115, 0.88),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Icon(
                Icons.file_upload,
                color: Color.fromRGBO(51, 77, 115, 0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoto() {
    return GestureDetector(
      onTap: pickImage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: imageFile != null
            ? Image.memory(imageFile!.readAsBytesSync())
            : CachedNetworkImage(imageUrl: widget.profilePicture!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              "Image principale du produit\nVeuillez choisir une image horizontale ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(34, 50, 99, 1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (imageFile == null && widget.profilePicture == null)
            Align(child: buildUploadButton()),
          if (!(imageFile == null && widget.profilePicture == null))
            Align(child: buildPhoto()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 20),
              child: NextButton(
                onPressed: () {
                  if (imageFile != null) {
                    widget.onPictureChanged(imageFile);
                  } else if (widget.profilePicture != null) {
                    widget.onPictureChanged(null);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
