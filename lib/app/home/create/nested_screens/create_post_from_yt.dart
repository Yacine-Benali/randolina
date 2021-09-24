import 'package:flutter/material.dart';

class CreatePostFromYt extends StatefulWidget {
  const CreatePostFromYt({Key? key}) : super(key: key);

  @override
  _CreatePostFromYtState createState() => _CreatePostFromYtState();
}

class _CreatePostFromYtState extends State<CreatePostFromYt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'publish youtube video',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [TextFormField()],
      ),
    );
  }
}
