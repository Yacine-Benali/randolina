import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/feed/posts/post_bloc.dart';
import 'package:randolina/app/models/post.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/utils/logger.dart';
import 'package:uuid/uuid.dart';

enum PopUpOptions {
  reportPost,
  downloadPhoto,
  deletePost,
  removeReport,
}

Map<PopUpOptions, String> popOptionsText = {
  PopUpOptions.reportPost: 'signaler la publication',
  PopUpOptions.downloadPhoto: 'télécharger la photo',
  PopUpOptions.deletePost: 'Supprimer la publication',
  PopUpOptions.removeReport: 'Annuler le signal',
};

Map<PopUpOptions, Icon> popOptionsIcon = {
  PopUpOptions.reportPost: Icon(Icons.report_gmailerrorred_outlined),
  PopUpOptions.downloadPhoto: Icon(Icons.download_outlined),
  PopUpOptions.deletePost: Icon(Icons.delete_outline),
  PopUpOptions.removeReport: Icon(Icons.delete_outline),
};

//? should i stop passing values to widget and just use provider ?
class PostWidgetPopUp extends StatefulWidget {
  const PostWidgetPopUp({
    Key? key,
    required this.post,
    required this.postBloc,
    required this.contentIndex,
    this.showDeleteOption = false,
  }) : super(key: key);
  final Post post;
  final int contentIndex;
  final PostBloc postBloc;
  final bool showDeleteOption;
  @override
  _PostWidgetPopUpState createState() => _PostWidgetPopUpState();
}

class _PostWidgetPopUpState extends State<PostWidgetPopUp> {
  late final User currentUser;

  @override
  void initState() {
    currentUser = context.read<User>();
    super.initState();
  }

  PopupMenuItem<PopUpOptions> buildTile(PopUpOptions value) {
    return PopupMenuItem(
      value: value,
      child: SizedBox(
        width: 191,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 3),
            Divider(
              height: 3,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  popOptionsText[value] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.85),
                    fontFamily: 'Lato-Black',
                  ),
                ),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: SizedBox(
                    width: 5,
                    height: 5,
                    child: popOptionsIcon[value],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              height: 3,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
            SizedBox(height: 3),
          ],
        ),
      ),
    );
  }

  Future<void> downloadPhoto() async {
    final response = await Dio().get(
      widget.post.content[widget.contentIndex],
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data as List<int>),
      quality: 60,
      name: Uuid().v1(),
    );
    Fluttertoast.showToast(msg: '$result', toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopUpOptions>(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      )),
      onSelected: (PopUpOptions selectedValue) async {
        logger.info(selectedValue);
        if (selectedValue == PopUpOptions.reportPost) {
          await widget.postBloc.reportPost(widget.post);

          Fluttertoast.showToast(
            msg: 'publication signalé aux administrateurs',
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (selectedValue == PopUpOptions.downloadPhoto) {
          try {
            downloadPhoto();
          } on Exception catch (e) {
            PlatformExceptionAlertDialog(exception: e).show(context);
          }
        } else if (selectedValue == PopUpOptions.deletePost) {
          final bool? didRequestSignOut = await PlatformAlertDialog(
            title: 'Confirmer',
            content: 'es-tu sûr ?',
            cancelActionText: 'annuler',
            defaultActionText: 'oui',
          ).show(context);
          if (didRequestSignOut == true) {
            widget.postBloc.deletePost(widget.post).then(
                  (value) => Fluttertoast.showToast(
                    msg:
                        'poste supprimé avec succès, actualisez la page pour voir les changements',
                    toastLength: Toast.LENGTH_LONG,
                  ),
                );
          }
        } else if (selectedValue == PopUpOptions.removeReport) {
          final bool? didRequestSignOut = await PlatformAlertDialog(
            title: 'Confirmer',
            content: 'es-tu sûr ?',
            cancelActionText: 'annuler',
            defaultActionText: 'oui',
          ).show(context);
          if (didRequestSignOut == true) {
            widget.postBloc.unReportPost(widget.post).then(
                  (value) => Fluttertoast.showToast(
                    msg: 'signal annuler avec success',
                    toastLength: Toast.LENGTH_LONG,
                  ),
                );
          }
        }
      },
      icon: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Icon(Icons.more_horiz_outlined, size: 35),
      ),
      itemBuilder: (_v) {
        return [
          buildTile(PopUpOptions.reportPost),
          if (widget.post.type == 0) ...[buildTile(PopUpOptions.downloadPhoto)],
          if (widget.post.miniUser.id == currentUser.id ||
              widget.showDeleteOption) ...[buildTile(PopUpOptions.deletePost)],
          if (widget.post.miniUser.id == currentUser.id ||
              widget.showDeleteOption) ...[
            buildTile(PopUpOptions.removeReport)
          ],
        ];
      },
    );
  }
}
