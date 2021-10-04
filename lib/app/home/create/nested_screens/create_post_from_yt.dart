import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/create/create_bloc.dart';
import 'package:randolina/app/home/create/nested_screens/create_post_from_yt2.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/logger.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class CreatePostFromYt extends StatefulWidget {
  const CreatePostFromYt({
    Key? key,
    required this.createBloc,
  }) : super(key: key);
  final CreateBloc createBloc;

  @override
  _CreatePostFromYtState createState() => _CreatePostFromYtState();
}

class _CreatePostFromYtState extends State<CreatePostFromYt> {
  List<String> urls = List.filled(5, '');
  int index = 5;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void publish() {
    logger.info(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      final List<String> validUrls = [];
      for (final String url in urls) {
        if (url != '') {
          validUrls.add(url);
        }
      }
      if (validUrls.isEmpty) {
        Fluttertoast.showToast(msg: "aucun lien n'est valide");
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostFromYt2(
              urls: validUrls,
              createBloc: widget.createBloc,
            ),
          ),
        );
      }
    }
  }

  String? sharedValidator(String? t) {
    if (t != null && t != '') {
      final String? result = YoutubePlayerController.convertUrlToId(t);
      if (result == null) {
        return 'le lien est invalide';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'publier une vidéo youtube',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: publish,
            child: Text('Suivant', style: TextStyle(color: Colors.blueGrey)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: urls[0],
                  decoration: InputDecoration(
                    hintText: 'collez le lien de la vidéo youtube ici',
                  ),
                  onChanged: (t) {
                    urls[0] = t;
                    logger.info(urls);
                  },
                  validator: sharedValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: urls[1],
                  decoration: InputDecoration(
                    hintText: 'collez le lien de la vidéo youtube ici',
                  ),
                  onChanged: (t) {
                    urls[1] = t;
                    logger.info(urls);
                  },
                  validator: sharedValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: urls[2],
                  decoration: InputDecoration(
                    hintText: 'collez le lien de la vidéo youtube ici',
                  ),
                  onChanged: (t) {
                    urls[2] = t;
                    logger.info(urls);
                  },
                  validator: sharedValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: urls[3],
                  decoration: InputDecoration(
                    hintText: 'collez le lien de la vidéo youtube ici',
                  ),
                  onChanged: (t) {
                    urls[3] = t;
                    logger.info(urls);
                  },
                  validator: sharedValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: urls[4],
                  decoration: InputDecoration(
                    hintText: 'collez le lien de la vidéo youtube ici',
                  ),
                  onChanged: (t) {
                    urls[4] = t;
                    logger.info(urls);
                  },
                  validator: sharedValidator,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
