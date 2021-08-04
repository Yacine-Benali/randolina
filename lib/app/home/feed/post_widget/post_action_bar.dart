import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/post_widget/post_bloc.dart';
import 'package:randolina/app/models/post.dart';
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
  late bool remoteisLiked = false;
  late Future<bool> isLikedFuture;
  late int numberOfLikes;

  @override
  void initState() {
    numberOfLikes = widget.post.numberOfLikes;
    widget.postBloc.isLiked(widget.post).then((value) {
      remoteisLiked = value;
      setState(() {});
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
                      remoteisLiked ? Icons.favorite : Icons.favorite_border,
                      color: remoteisLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      if (remoteisLiked == false) {
                        logger.info('like this post ${widget.post.id}');
                        widget.postBloc.like(widget.post);
                        remoteisLiked = true;
                        numberOfLikes++;
                      } else {
                        logger.info('unlike this post ${widget.post.id}');
                        widget.postBloc.unlike(widget.post);
                        remoteisLiked = false;
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
                    },
                  ),
                ],
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.bookmark_border),
                onPressed: () {
                  logger.info('bookmark this post');
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
