import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key, required this.callback}) : super(key: key);
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      buttonText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SIGN IN',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 30,
          ),
        ],
      ),
      onPressed: callback,
      minHeight: 35,
      minWidth: 200,
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //     decoration: BoxDecoration(
    //       boxShadow: const [
    //         BoxShadow(
    //             color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
    //       ],
    //       gradient: LinearGradient(
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //         stops: const [0, 1],
    //         colors: [
    //           Color.fromRGBO(64, 163, 219, 1.0),
    //           Color.fromRGBO(156, 210, 239, 1.0),
    //         ],
    //       ),
    //       color: Colors.deepPurple.shade300,
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     child: ElevatedButton(
    //       onPressed: callback,
    //       style: ButtonStyle(
    //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    //         ),
    //         backgroundColor: MaterialStateProperty.all(Colors.transparent),
    //         // elevation: MaterialStateProperty.all(3),
    //         minimumSize: MaterialStateProperty.all(Size(200, 35)),
    //         shadowColor: MaterialStateProperty.all(Colors.transparent),
    //       ),
    //       child:
    //     ),
    //   ),
    // );
  }
}
