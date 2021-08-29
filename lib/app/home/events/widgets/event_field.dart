import 'package:flutter/material.dart';

class EventField extends StatefulWidget {
  const EventField({
    Key? key,
    required this.title,
    required this.hint,
    required this.onChanged,
    required this.validator,
    this.lines = 1,
    this.isNumber = false,
    this.suffix,
    this.textInputAction,
    this.maxLength,
    this.initialValue,
    this.textInputType,
  }) : super(key: key);
  final String title;
  final String hint;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final bool isNumber;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int lines;
  final String? initialValue;
  final TextInputType? textInputType;

  @override
  _EventFieldState createState() => _EventFieldState();
}

class _EventFieldState extends State<EventField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(34, 50, 99, 1),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 20),
            child: Material(
              type: MaterialType.button,
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  enabled: false,
                  textInputAction: widget.textInputAction,
                  minLines: widget.lines,
                  maxLines: widget.lines,
                  initialValue: widget.initialValue,
                  keyboardType: widget.textInputType,
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                    hintText: widget.hint,
                    suffix: widget.suffix,
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => widget.onChanged(value),
                  validator: widget.validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
