import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/chat/image_full_screen.dart';
import 'package:randolina/app/models/message.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/size_config.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.message,
    required this.isSelf,
    required this.avatarUrl,
  }) : super(key: key);
  final Message message;
  final bool isSelf;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSelf) ...[
            if (avatarUrl != null) ...[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ImageProfile(
                  url: avatarUrl!,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
            if (avatarUrl == null) ...[
              SizedBox(width: 20, height: 20),
            ],
          ],
          buildMessageContainer(
            isSelf: isSelf,
            message: message,
            context: context,
          ),
          if (isSelf) ...[
            SizedBox(width: 20, height: 20),
            // if (avatarUrl != null) ...[
            //   Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: ImageProfile(
            //       url: avatarUrl!,
            //       width: 20,
            //       height: 20,
            //     ),
            //   ),
            // ],
            // if (avatarUrl == null) ...[
            //   SizedBox(width: 20, height: 20),
            // ],
          ],
        ],
      ),
    );
  }

  Widget buildMessageContainer({
    required bool isSelf,
    required Message message,
    required BuildContext context,
  }) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    if (message.type == 0) {
      lrEdgeInsets = 15.0;
      tbEdgeInsets = 10.0;
    }
    return Row(
      mainAxisAlignment:
          isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(
            lrEdgeInsets,
            tbEdgeInsets,
            lrEdgeInsets,
            tbEdgeInsets,
          ),
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 2),
          decoration: BoxDecoration(
            color: (message.type == 0)
                ? isSelf
                    ? Color.fromRGBO(64, 163, 219, 0.46)
                    : Color.fromRGBO(51, 77, 115, 0.29)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
          ),
          // margin: EdgeInsets.only(
          //   right: isSelf ? 10.0 : 0,
          //   left: isSelf ? 0 : 10.0,
          // ),
          child: buildMessageContent(
            isSelf: isSelf,
            message: message,
            context: context,
          ),
        )
      ],
      // aligns the chatitem to right end
    );
  }

  Widget buildMessageContent({
    required bool isSelf,
    required Message message,
    required BuildContext context,
  }) {
    if (message.type == 0) {
      return Text(
        message.content,
        style: TextStyle(
          color: isSelf ? Colors.white : Colors.white,
        ),
      );
    } else if (message.type == 1) {
      return Hero(
        tag: 'ImageMessage_${message.createdAt.toDate()}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageBuilder: (_, imageProvider) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageFullScreen(
                          imageProvider: imageProvider,
                        ),
                      ),
                    );
                  },
                  child: Image(image: imageProvider));
            },
            imageUrl: message.content,
            errorWidget: (context, url, error) => Icon(Icons.error),
            placeholder: (_, url) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
