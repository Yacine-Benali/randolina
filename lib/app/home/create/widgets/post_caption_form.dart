import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostCaptionForm extends StatefulWidget {
  final File? contentFile;
  final String? contentUrl;
  final TextEditingController controller;
  final Size screenSize;
  final ValueChanged<String> onChanged;
  final PostContentType postContentType;

  const PostCaptionForm({
    required this.contentFile,
    required this.contentUrl,
    required this.controller,
    required this.screenSize,
    required this.onChanged,
    required this.postContentType,
  }) : assert(contentUrl != null || contentFile != null);
  @override
  _PostCaptionFormState createState() => _PostCaptionFormState();
}

class _PostCaptionFormState extends State<PostCaptionForm> {
  Uint8List? videoThumbnailInMemory;

  Future<void> initVideoThumbnail() async {
    if (widget.contentFile != null &&
        widget.postContentType == PostContentType.video) {
      final Uint8List? v = await VideoThumbnail.thumbnailData(
        video: widget.contentFile!.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );
      setState(() {
        videoThumbnailInMemory = v;
      });
    }
  }

  @override
  void initState() {
    initVideoThumbnail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (widget.postContentType == PostContentType.image)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            height: 45.0,
            width: 45.0,
            child: AspectRatio(
              aspectRatio: 487 / 451,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                    image: widget.contentFile == null
                        ? CachedNetworkImageProvider(widget.contentUrl!)
                            as ImageProvider
                        : FileImage(widget.contentFile!),
                  ),
                ),
              ),
            ),
          ),
        if (widget.postContentType == PostContentType.video)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            height: 45.0,
            width: 45.0,
            child: AspectRatio(
              aspectRatio: 487 / 451,
              child: Container(
                decoration: BoxDecoration(),
                child: videoThumbnailInMemory == null
                    ? Container()
                    : Image.memory(videoThumbnailInMemory!),
              ),
            ),
          ),
        SizedBox(
          width: widget.screenSize.width - 92,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              maxLength: 100,
              onChanged: (value) => widget.onChanged(value),
              validator: (String? input) {
                if (input != null) {
                  final numLines = '\n'.allMatches(input).length + 1;
                  if (numLines > 4) {
                    return 'le nombre de lignes ne peut pas dépasser 3';
                  }
                  if (input.trim().length > 150) {
                    return 'Veuillez saisir une légende de moins de 150 caractères';
                  }
                  if (input.trim().length < 3) {
                    return 'Veuillez saisir une légende de plus de 3 caractères';
                  }
                }
              },
              controller: widget.controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Écrivez une légende...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }
}
