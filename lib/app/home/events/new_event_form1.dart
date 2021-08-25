import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:randolina/app/home/events/next_button.dart';

class NewEventForm1 extends StatefulWidget {
  const NewEventForm1({
    Key? key,
    required this.onPictureChanged,
  }) : super(key: key);
  final ValueChanged<File> onPictureChanged;

  @override
  _NewEventForm1State createState() => _NewEventForm1State();
}

class _NewEventForm1State extends State<NewEventForm1> {
  File? imageFile;

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
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            imageFile = File(image.path);
            setState(() {});
          }
        },
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
              'Upload picture',
              style: TextStyle(
                color: Color.fromRGBO(51, 77, 115, 0.88),
                fontSize: 18,
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
    print(imageFile);
    return GestureDetector(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          imageFile = File(image.path);
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.memory(imageFile!.readAsBytesSync()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'Principal picture of event',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(34, 50, 99, 1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: imageFile == null ? buildUploadButton() : buildPhoto(),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, right: 8, left: 8),
            child: NextButton(
              onPressed: () {
                if (imageFile != null) {
                  widget.onPictureChanged(imageFile!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
