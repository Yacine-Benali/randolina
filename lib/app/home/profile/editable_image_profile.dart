import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// ignore: must_be_immutable
class EditableImageProfile extends StatefulWidget {
  const EditableImageProfile({
    required this.url,
    this.height = 95,
    this.width = 95,
    required this.onImageChange,
  });
  final String url;
  final double width;
  final double height;
  final ValueChanged<File> onImageChange;

  @override
  _EditableImageProfileState createState() => _EditableImageProfileState();
}

class _EditableImageProfileState extends State<EditableImageProfile> {
  File? f;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedAssets = await AssetPicker.pickAssets(
          context,
          textDelegate: EnglishTextDelegate(),
          maxAssets: 1,
          themeColor: Colors.blue,
        );

        if (pickedAssets != null) {
          f = await pickedAssets.elementAt(0).file;
          setState(() {});
          widget.onImageChange(f!);
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(47),
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF334D73).withOpacity(0.43),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: widget.url,
          imageBuilder: (context, imageProvider) {
            if (f == null) {
              return CircleAvatar(
                backgroundImage: imageProvider,
              );
            } else {
              return CircleAvatar(
                backgroundImage: FileImage(f!),
              );
            }
          },
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
