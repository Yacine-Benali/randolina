import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:randolina/app/home/feed/posts/comments/comment_input.dart';
import 'package:randolina/app/home/feed/posts/comments/comment_widget.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/models/comment.dart';
import 'package:randolina/app/models/post.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
    required this.postBloc,
    required this.post,
  }) : super(key: key);
  final PostBloc postBloc;
  final Post post;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('comments', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: PaginateFirestore(
              itemBuilder: (index, context, documentSnapshot) {
                final data = documentSnapshot.data();
                if (data != null) {
                  final Comment comment = Comment.fromMap(
                    data as Map<String, dynamic>,
                  );
                  return CommentWidget(comment: comment);
                } else {
                  return Container(
                    color: Colors.red,
                  );
                }
              },
              query: FirebaseFirestore.instance
                  .collection('posts/${widget.post.id}/comments')
                  .orderBy('createdAt', descending: true),
              itemBuilderType: PaginateBuilderType.listView,
              isLive: true,
            ),
          ),
          Divider(),
          CommentInput(onPressed: (String content) {
            widget.postBloc.publishComment(
              widget.post,
              content,
            );
          })
        ],
      ),
    );
  }
}
