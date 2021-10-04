import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/create/create_bloc.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/logger.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class CreatePostFromYt2 extends StatefulWidget {
  const CreatePostFromYt2({
    Key? key,
    required this.urls,
    required this.createBloc,
  }) : super(key: key);

  final List<String> urls;
  final CreateBloc createBloc;

  @override
  _CreatePostFromYt2State createState() => _CreatePostFromYt2State();
}

class _CreatePostFromYt2State extends State<CreatePostFromYt2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _caption = '';
  late final String thumbnail;

  Future<void> _submit() async {
    widget.createBloc
        .createPostFromYoutube(
          _caption,
          widget.urls,
        )
        .then(
          (value) => Fluttertoast.showToast(
            msg: 'publication publié avec succès',
            toastLength: Toast.LENGTH_SHORT,
          ),
        );

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    thumbnail = YoutubePlayerController.getThumbnail(
      videoId: widget.urls[0],
      webp: false,
    );
    logger.warning(thumbnail);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'publier',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _caption.trim().length > 3 ? _submit : null,
            child: Text(
              'Partager',
              style: TextStyle(
                color: _caption.trim().length > 3 ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _caption = value;
                    });
                  },
                  validator: (String? input) {
                    if (input != null) {
                      if (input.trim().length > 150) {
                        return 'Veuillez saisir une légende de moins de 150 caractères';
                      }
                      if (input.trim().length < 3) {
                        return 'Veuillez saisir une légende de plus de 3 caractères';
                      }
                    }
                  },
                  maxLength: 150,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Écrivez une légende...',
                      border: InputBorder.none),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
