import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:randolina/app/models/comment.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);
  final Comment comment;

  Widget fun(BuildContext a, Widget b, ImageChunkEvent? c) {
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 35,
        width: 35,
        child: CachedNetworkImage(
          imageUrl: comment.miniUser.profilePicture,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '${comment.miniUser.name}\t',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: comment.content,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      subtitle: Text(GetTimeAgo.parse(comment.createdAt.toDate())),
    );
  }
}
