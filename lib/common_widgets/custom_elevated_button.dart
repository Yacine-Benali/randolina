import 'package:flutter/material.dart';
import 'package:randolina/constants/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.minHeight,
    required this.minWidth,
    this.color,
  }) : super(key: key);

  final Widget buttonText;
  final VoidCallback? onPressed;
  final double minHeight;
  final double minWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          )
        ],
        gradient: color == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
                colors: [gradientStart, gradientEnd],
              )
            : null,
        color: color ?? Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(60),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all(Size(minWidth, minHeight)),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
        ),
        child: buttonText,
      ),
    );
  }
}
