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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 20),
      child: Material(
        type: MaterialType.button,
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        elevation: 5.0,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(9),
          child: Row(
            children: <Widget>[
              // send image Button
              IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.image),
                onPressed: sendImageMessage, //getImage,
                color: Colors.indigo,
              ),
              // Edit text
              Flexible(
                child: TextField(
                  maxLines: 4,
                  minLines: 1,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
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
                        color: Colors.indigo,
                        iconSize: 30.0,
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
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
