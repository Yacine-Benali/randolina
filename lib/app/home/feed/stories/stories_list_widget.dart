import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/feed_bloc.dart';
import 'package:randolina/app/home/feed/stories/stories_screen.dart';
import 'package:randolina/app/models/mini_user.dart';
import 'package:randolina/app/models/user_followers_stories.dart';
import 'package:randolina/common_widgets/size_config.dart';

class StoriesListWidget extends StatelessWidget {
  const StoriesListWidget({
    Key? key,
    required this.feedBloc,
  }) : super(key: key);
  final FeedBloc feedBloc;

  Widget buildStoryAvatar(
    BuildContext context,
    MiniUser user,
    List<UserFollowersStories> list,
    int index,
  ) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StoriesScreen(
                  usersStories: list,
                  initialPage: index,
                  feedBloc: feedBloc,
                ),
              ),
            );
          },
          child: SizedBox(
            width: SizeConfig.blockSizeHorizontal * 16,
            height: SizeConfig.blockSizeHorizontal * 16,
            child: CachedNetworkImage(
              imageUrl: user.profilePicture,
              imageBuilder: (context, imageProvider) =>
                  CircleAvatar(backgroundImage: imageProvider),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            user.username,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 9.0, left: 21.0, bottom: 4),
          alignment: Alignment.centerLeft,
          child: Text(
            'recent stories ...',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.58),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FutureBuilder<List<UserFollowersStories>>(
            future: feedBloc.getStoriesIdsAndUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData && (snapshot.data != null)) {
                final List<UserFollowersStories> usersStories = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: 110,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: usersStories.length,
                      itemBuilder: (context, index) {
                        final MiniUser user = usersStories[index].miniUser;

                        if (feedBloc.haveStories(user)) {
                          return buildStoryAvatar(
                              context, user, snapshot.data!, index);
                        }
                        return Container();
                      },
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            }),
      ],
    );
  }
}
