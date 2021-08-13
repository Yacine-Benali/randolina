import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/feed/posts/comments/comments_screen.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/saved_posts.dart';
import 'package:randolina/utils/logger.dart';

class PostActionBar extends StatefulWidget {
  const PostActionBar({
    Key? key,
    required this.postBloc,
    required this.post,
  }) : super(key: key);
  final PostBloc postBloc;
  final Post post;

  @override
  _PostActionBarState createState() => _PostActionBarState();
}

class _PostActionBarState extends State<PostActionBar> {
  late bool isLiked = false;
  late bool isSaved = false;
  late int numberOfLikes;
  SavedPost? savedPost;

  @override
  void initState() {
    numberOfLikes = widget.post.numberOfLikes;
    widget.postBloc.isLiked(widget.post).then((value) {
      isLiked = value;
      setState(() {});
    });

    widget.postBloc.isSaved(widget.post).then((SavedPost? value) {
      if (value != null) {
        savedPost = value;
        isSaved = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    iconSize: 30,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      if (isLiked == false) {
                        logger.info('like this post ${widget.post.id}');
                        widget.postBloc.like(widget.post);
                        isLiked = true;
                        numberOfLikes++;
                      } else {
                        logger.info('unlike this post ${widget.post.id}');
                        widget.postBloc.unlike(widget.post);
                        isLiked = false;
                        numberOfLikes--;
                      }
                      setState(() {});
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      logger.info('open comments screen');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            postBloc: widget.postBloc,
                            post: widget.post,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border_outlined),
                color: Colors.black,
                onPressed: () async {
                  if (isSaved == false) {
                    logger.info('save this post ${widget.post.id}');
                    widget.postBloc.savePost(widget.post).then(
                          (value) => Fluttertoast.showToast(
                            msg: 'Post saved successfully',
                            toastLength: Toast.LENGTH_SHORT,
                          ),
                        );

                    isSaved = true;
                  } else if (savedPost != null) {
                    logger.info('unsave this post ${widget.post.id}');
                    widget.postBloc.unsavePost(savedPost!);
                    isSaved = false;
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 12.0, bottom: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            '$numberOfLikes likes',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
