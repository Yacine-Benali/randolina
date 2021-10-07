import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key? key,
    this.title,
    required this.valueText,
    this.onPressed,
    this.textStyle,
  }) : super(key: key);

  final String? title;
  final TextStyle? textStyle;
  final Text valueText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (textStyle == null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BorderedText(
                strokeColor: Colors.black,
                strokeWidth: 3.0,
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
          ],
          if (textStyle != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title!,
                style: textStyle,
              ),
            ),
            SizedBox(height: 2),
          ],
          // because it not redondant
          // ignore: avoid_unnecessary_containers
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: Colors.blueGrey,
                width: textStyle != null ? 0 : 1,
              ),
            ),
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    valueText,
                    Icon(
                      Icons.expand_more,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade700
                          : Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
