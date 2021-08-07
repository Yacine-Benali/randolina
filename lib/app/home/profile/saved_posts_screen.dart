// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:randolina/app/home/feed/post_widget/post_bloc.dart';
// import 'package:randolina/app/home/profile/profile_bloc.dart';
// import 'package:randolina/app/models/post.dart';
// import 'package:randolina/app/models/user.dart';
// import 'package:randolina/services/database.dart';

// class SavedPostsScreen extends StatefulWidget {
//   SavedPostsScreen({Key? key}) : super(key: key);

//   @override
//   _SavedPostsScreenState createState() => _SavedPostsScreenState();
// }

// class _SavedPostsScreenState extends State<SavedPostsScreen> {
//   int type = 0;
//   late List<Post> posts;
//   late final PostBloc postBloc;
//   late final List<Widget> list2;
//   late final Future<List<Post>> postsFuture;

//   @override
//   void initState() {
//     list2 = [];
//     postsFuture = widget.bloc.getPosts();
//     postBloc = PostBloc(
//       currentUser: context.read<User>(),
//       database: context.read<Database>(),
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: null,
//     );
//   }
// }
