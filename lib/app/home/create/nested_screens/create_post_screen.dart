import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:randolina/app/home/create/create_bloc.dart';
import 'package:randolina/app/home/create/widgets/post_caption_form.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/constants/app_colors.dart';

enum PostStatus {
  feedPost,
  deletedPost,
  archivedPost,
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    this.post,
    this.postStatus,
    required this.finalFiles,
    required this.postContentType,
    required this.createBloc,
  }) : assert(finalFiles != null || post != null);
  final Post? post;
  final PostStatus? postStatus;
  final List<File>? finalFiles;
  final PostContentType postContentType;
  final CreateBloc createBloc;

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _caption = '';
  bool _isLoading = false;
  Post? _post;

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      setState(() {
        _captionController.value =
            TextEditingValue(text: widget.post!.description);
        _caption = widget.post!.description;
        _post = widget.post;
      });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_isLoading && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      if (_post != null) {
        // Edit existing Post
        // Post post = Post(
        //   id: _post.id,
        //   imageUrl: _post.imageUrl,
        //   caption: _captionController.text.trim(),
        //   location: _locationController.text.trim(),
        //   likeCount: _post.likeCount,
        //   authorId: _post.authorId,
        //   timestamp: _post.timestamp,
        //   commentsAllowed: _post.commentsAllowed,
        // );

        // DatabaseService.editPost(post, widget.postStatus);
      } else if (widget.finalFiles != null) {
        //Create new Post working
        await widget.createBloc
            .createPost(
              widget.finalFiles!,
              widget.postContentType,
              _caption,
            )
            .then(
              (value) => Fluttertoast.showToast(
                msg: 'post successfully published',
                toastLength: Toast.LENGTH_SHORT,
              ),
            );
      }
      _goToHomeScreen();
    }
  }

  void _goToHomeScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.finalFiles == null ? 'Edit Post' : 'Post',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            if (!_isLoading) ...[
              TextButton(
                onPressed: _caption.trim().length > 3 ? _submit : null,
                child: Text(
                  widget.finalFiles == null ? 'Save' : 'Share',
                  style: TextStyle(
                    color:
                        _caption.trim().length > 3 ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              )
            ],
            if (_isLoading) ...[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ]
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                if (widget.finalFiles != null)
                  PostCaptionForm(
                    screenSize: screenSize,
                    contentUrl: _post?.content[0],
                    controller: _captionController,
                    contentFile: widget.finalFiles![0],
                    postContentType: widget.postContentType,
                    onChanged: (val) {
                      setState(() {
                        _caption = val;
                      });
                    },
                  ),
                Divider(),
              ],
            ),
          ),
        ));
  }
}
