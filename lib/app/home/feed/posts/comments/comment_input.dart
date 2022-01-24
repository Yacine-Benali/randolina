import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final void Function(String value) onPressed;
  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: 'Écrire un commentaire',
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
      trailing: TextButton(
        onPressed: _commentController.text == ''
            ? null
            : () {
                widget.onPressed(_commentController.text);
                _commentController.clear();
              },
        child: Text("Publiée"),
      ),
    );
  }
}
