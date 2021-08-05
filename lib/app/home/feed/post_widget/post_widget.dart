import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:randolina/app/home/feed/post_widget/content_loader/post_content_loader.dart';
import 'package:randolina/app/home/feed/post_widget/post_action_bar.dart';
import 'package:randolina/app/home/feed/post_widget/post_bloc.dart';
import 'package:randolina/app/home/feed/post_widget/post_widget_popup.dart';
import 'package:randolina/app/models/post.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.post,
    required this.postBloc,
  }) : super(key: key);
  final Post post;
  final PostBloc postBloc;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final FlareControls flareControls = FlareControls();
  bool isLiked = false;
  late final Future<bool> isLikedFuture;
  PostBloc get postBloc => widget.postBloc;

  @override
  void initState() {
    // isLikedFuture = postBloc.isLiked(widget.post);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF334D73).withOpacity(0.20),
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 78,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(left: 20),
                        child: CachedNetworkImage(
                          imageUrl: widget.post.miniUser.profilePicture,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          ' ${widget.post.miniUser.username}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  PostWidgetPopUp(),
                ],
              ),
            ),
            SizedBox(
              height: 245,
              child: PostContentLoader(
                type: widget.post.type,
                content: widget.post.content,
              ),
            ),
            PostActionBar(
              post: widget.post,
              postBloc: postBloc,
            ),
            Container(
              //  height: 42,
              margin: const EdgeInsets.only(left: 12),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '${widget.post.miniUser.username}\t',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: widget.post.description,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 9.0, left: 12.0),
              alignment: Alignment.centerLeft,
              child: Text(
                GetTimeAgo.parse(widget.post.createdAt.toDate()),
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.55),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
