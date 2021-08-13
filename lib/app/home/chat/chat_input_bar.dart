import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    Key? key,
    //required this.bloc,
  }) : super(key: key);
  //final ChatBloc bloc;

  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  Color color = Color.fromRGBO(51, 77, 115, 1);
  bool isWriting = false;

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
              onPressed: sendImageMessage, //getImage,
              color: color,
            ),
            IconButton(
              iconSize: 25,
              icon: Icon(Icons.image),
              onPressed: sendImageMessage, //getImage,
              color: color,
            ),
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
                  maxLines: 1,
                  onChanged: (v) {
                    setState(() {
                      isWriting = true;
                    });
                  },
                  decoration: InputDecoration(
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
                        sendTextMessage(textEditingController.text, 0),
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
  void sendTextMessage(String content, int type) {
    // type: 0 = text, 1 = image
    // if (content.trim() != '') {
    //   textEditingController.clear();

    //   bloc.sendMessage(content, type);
    // } else {
    //   Fluttertoast.showToast(msg: 'Nothing to send');
    // }
  }

  /// called on pressing the photo button
  /// calls image_picker package to chose image from gallery
  Future<void> sendImageMessage() async {
    // imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    // // print('image file: ');
    // // print(imageFile);
    // if (imageFile == null) {
    //   return;
    // }
    // // set loading state
    // setState(() {
    //   isLoading = true;
    // });
    // bool result = await bloc.sendImageMessage(imageFile, 1);
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
