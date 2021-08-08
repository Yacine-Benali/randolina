import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class SignUpTitle extends StatelessWidget {
  const SignUpTitle({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return BorderedText(
      strokeColor: Colors.black,
      strokeWidth: 4.0,
      child: Text(
        title,
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 0.72),
          fontWeight: FontWeight.w700,
          fontSize: 16,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2, -3),
              blurRadius: 20.0,
              color: Colors.white60,
            ),
          ],
        ),
      ),
    );
  }
}
