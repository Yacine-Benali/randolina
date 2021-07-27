import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key? key, required this.onChanged}) : super(key: key);
  final ValueChanged<File> onChanged;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //! ios plist config
        //! https://pub.dev/packages/image_picker
        //
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);

        if (image?.path != null) {
          imageFile = File(image!.path);
          widget.onChanged(imageFile!);
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: CircleAvatar(
          radius: 75,
          backgroundImage: imageFile == null
              ? null
              : MemoryImage(imageFile!.readAsBytesSync()),
          backgroundColor: Colors.black12,
          child: imageFile == null
              ? Icon(
                  Icons.upload,
                  size: 75,
                  color: Colors.black,
                )
              : null,
        ),
      ),
    );
  }
}
