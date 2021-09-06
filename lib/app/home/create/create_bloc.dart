import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randolina/app/home/create/camera_screen.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/story.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/services/api_path.dart';
import 'package:randolina/services/database.dart';

class CreateBloc {
  CreateBloc({
    required this.database,
    required this.currentUser,
  });
  final Database database;
  final User currentUser;

  Future<void> createStory(
      String imagePath, PostContentType postContentType) async {
    final String storyId = database.getUniqueId();

    final String imageUrl = await database.uploadFile(
      path: APIPath.storyFiles(currentUser.id, storyId, database.getUniqueId()),
      filePath: imagePath,
    );

    final Story story = Story(
      type: postContentType.index,
      createdBy: currentUser.id,
      createdAt: Timestamp.now(),
      content: imageUrl,
    );

    await database.setData(
      path: APIPath.storyDocument(storyId),
      data: story.toMap(),
    );
  }

  Future<void> createPost(
    List<File> finalFiles,
    PostContentType postContentType,
    String caption,
  ) async {
    final String postId = database.getUniqueId();
    final List<Future<String>> futureUrls = [];
    for (final File asset in finalFiles) {
      final futureImageUrl = database.uploadFile(
        path: APIPath.postFiles(currentUser.id, postId, database.getUniqueId()),
        filePath: asset.path,
      );
      futureUrls.add(futureImageUrl);
    }
    final List<String> urls = await Future.wait(futureUrls);

    final Post post = Post(
      id: postId,
      type: postContentType.index,
      description: caption,
      content: urls,
      createdAt: Timestamp.now(),
      numberOfLikes: 0,
      miniUser: currentUser.toMiniUser(),
    );

    database.setData(
      path: APIPath.postDocument(postId),
      data: post.toMap(),
    );
  }
}
