import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:randolina/app/home/chat/chat_bloc.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final ChatBloc bloc;

  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  Color color = Color.fromRGBO(51, 77, 115, 1);
  bool isWriting = false;
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.button,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      color: Colors.white,
      elevation: 5.0,
      child: Row(
        children: <Widget>[
          // send image Button
          if (!isWriting) ...[
            IconButton(
              iconSize: 25,
              icon: Icon(Icons.camera_alt),
              onPressed: () => sendImageMessage(ImageSource.camera), //getImage,
              color: color,
            ),
            IconButton(
              iconSize: 25,
              icon: Icon(Icons.image),
              onPressed: () =>
                  sendImageMessage(ImageSource.gallery), //getImage,
              color: color,
            ),
            // GestureDetector(
            //   child: IconButton(
            //     iconSize: 25,
            //     icon: Icon(Icons.mic),
            //     onPressed: () =>
            //         sendImageMessage(ImageSource.gallery), //getImage,
            //     color: color,
            //   ),
            // ),
          ],
          if (isWriting) ...[
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  isWriting = false;
                });
              }, //getImage,
              color: color,
            ),
          ],
          // Edit text
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(218, 218, 218, 0.37),
                  // color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: textEditingController,
                  //keyboardType: TextInputType.multiline,
                  minLines: 1,
                  onChanged: (v) {
                    setState(() {
                      isWriting = true;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: InputBorder.none,
                    // filled: true,
                    // fillColor: Colors.red[200],
                    // contentPadding: EdgeInsets.only(left: 4),
                    hintText: ' Aa...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          // send message button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: !isLoading
                ? IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () =>
                        sendTextMessage(textEditingController.text),
                    color: color,
                    iconSize: 25,
                  )
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  /// responsible for sending the message to the cloud
  void sendTextMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();

      widget.bloc.sendMessage(content, 0);
    } else {
      Fluttertoast.showToast(msg: 'Rien à envoyer');
    }
  }

  Future<void> sendImageMessage(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return;
    }
    final File imageFile = File(image.path);

    // set loading state
    // setState(() {
    //   isLoading = true;
    // });
    await widget.bloc.sendImageMessage(imageFile, 1);
    // if (result == true) {
    //   setState(() {
    //     isLoading = false;
    //   });
    // } else {
    //   Fluttertoast.showToast(msg: 'photo failed to upload');
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }
}
