import 'package:flutter/material.dart';
import 'package:randolina/constants/app_constants.dart';

class RoleSelectorRadio extends StatelessWidget {
  const RoleSelectorRadio({
    Key? key,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  /// The currently selected value for a group of radio buttons.
  /// This radio button is considered selected if its [value] matches the [groupValue].
  final Role? groupValue;

  ///The value represented by this radio button.
  final Role value;

  final ValueChanged<Role?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset(
            'assets/sign_up_tiles/$value.png'.replaceAll('Role.', ''),
            // height: 150,
          ),
          Positioned(
            left: 20,
            bottom: 5,
            child: Radio<Role>(
              activeColor: Colors.green,
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ),
          Positioned(
            left: 35,
            top: 8,
            child: Text(
              roleToText[value]!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2, -3),
                    blurRadius: 13.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
