import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:randolina/app/home/feed/posts/content_loader/post_content_loader.dart';
import 'package:randolina/app/home/feed/posts/post_action_bar.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/home/feed/posts/post_widget_popup.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/common_widgets/miniuser_to_profile.dart';
import 'package:randolina/common_widgets/size_config.dart';

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
  PostBloc get postBloc => widget.postBloc;
  int contentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              height: 60,
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
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            enableFeedback: false,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (builder) => MiniuserToProfile(
                                  miniUser: widget.post.miniUser,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            ' ${widget.post.miniUser.username}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PostWidgetPopUp(
                    post: widget.post,
                    contentIndex: contentIndex,
                    postBloc: postBloc,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: PostContentLoader(
                type: widget.post.type,
                content: widget.post.content,
                onIndexChanged: (int index) {
                  setState(() {
                    contentIndex = index;
                  });
                },
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
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => MiniuserToProfile(
                                miniUser: widget.post.miniUser,
                              ),
                            ),
                          );
                        },
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
