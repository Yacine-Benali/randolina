import 'package:flutter/material.dart';

class SignUpDivider extends StatelessWidget {
  SignUpDivider({
    Key? key,
    required this.imagePath,
    required this.start,
    required this.end,
  }) : super(key: key);
  final String imagePath;
  final int start;
  final int end;

  final double thickness = 4;
  final Color color = Color.fromRGBO(255, 255, 255, 0.5);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: start,
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        Image.asset(
          imagePath,
        ),
        Expanded(
          flex: end,
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
      ],
    );
  }
}
