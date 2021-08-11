import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:uuid/uuid.dart';

enum PopUpOptions {
  reportPost,
  downloadPhoto,
}

Map<PopUpOptions, String> popOptionsText = {
  PopUpOptions.reportPost: 'report post',
  PopUpOptions.downloadPhoto: 'download photo',
};

Map<PopUpOptions, Icon> popOptionsIcon = {
  PopUpOptions.reportPost: Icon(Icons.report_gmailerrorred_outlined),
  PopUpOptions.downloadPhoto: Icon(Icons.download_outlined),
};

//? should i stop passing values to widget and just use provider ?
class PostWidgetPopUp extends StatefulWidget {
  const PostWidgetPopUp({
    Key? key,
    required this.post,
    required this.contentIndex,
  }) : super(key: key);
  final Post post;
  final int contentIndex;

  @override
  _PostWidgetPopUpState createState() => _PostWidgetPopUpState();
}

class _PostWidgetPopUpState extends State<PostWidgetPopUp> {
  PopupMenuItem<PopUpOptions> buildTile(PopUpOptions value) {
    return PopupMenuItem(
      value: value,
      child: SizedBox(
        width: 191,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 3),
            Divider(
              height: 3,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  popOptionsText[value]!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.85),
                    fontFamily: 'Lato-Black',
                  ),
                ),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: SizedBox(
                    width: 5,
                    height: 5,
                    child: popOptionsIcon[value]!,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              height: 3,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
            SizedBox(height: 3),
          ],
        ),
      ),
    );
  }

  void _toastInfo(String info) {}

  Future<void> downloadPhoto() async {
    final response = await Dio().get(
      widget.post.content[widget.contentIndex],
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data as List<int>),
      quality: 60,
      name: Uuid().v1(),
    );
    Fluttertoast.showToast(msg: '$result', toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopUpOptions>(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      )),
      onSelected: (PopUpOptions selectedValue) async {
        if (selectedValue == PopUpOptions.reportPost) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Post reported to admins')));
          // todo @average call the report function
          //
        } else if (selectedValue == PopUpOptions.downloadPhoto) {
          try {
            downloadPhoto();
          } on Exception catch (e) {
            PlatformExceptionAlertDialog(exception: e).show(context);
          }
        }
      },
      icon: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Icon(Icons.more_horiz_outlined, size: 35),
      ),
      itemBuilder: (_v) {
        return [
          buildTile(PopUpOptions.reportPost),
          if (widget.post.type == 0) ...[buildTile(PopUpOptions.downloadPhoto)],
        ];
      },
    );
  }
}
