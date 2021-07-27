import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    required this.title,
    required this.content,
    this.cancelActionText = 'Cancel',
    this.defaultActionText = 'Ok',
  });

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool?> show(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) => this,
      );
    } else {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => this,
      );
    }
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      PlatformAlertDialogAction(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(cancelActionText),
      ),
      PlatformAlertDialogAction(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText),
      ),
    ];
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({required this.child, required this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
