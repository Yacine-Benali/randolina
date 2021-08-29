import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/size_config.dart';

class NextButton extends StatelessWidget {
  const NextButton({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          minimumSize:
              MaterialStateProperty.all(Size(SizeConfig.screenWidth, 60)),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
        ),
        child: Container(
          width: SizeConfig.screenWidth,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.7],
              colors: [
                Color.fromRGBO(51, 77, 115, 0.64),
                Color.fromRGBO(64, 191, 255, 1),
              ],
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
