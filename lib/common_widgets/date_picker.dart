import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:randolina/common_widgets/input_dropdown.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key? key,
    required this.title,
    required this.selectedDate,
    required this.onSelectedDate,
    required this.hintText,
    this.titleStyle,
    this.isEnabled = true,
  }) : super(key: key);

  final String hintText;
  final String title;
  final Timestamp? selectedDate;
  final ValueChanged<Timestamp> onSelectedDate;
  final TextStyle? titleStyle;
  final bool isEnabled;

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime temp =
        selectedDate != null ? selectedDate!.toDate() : DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: temp,
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      onSelectedDate(Timestamp.fromDate(pickedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final off = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w300,
    );
    final on = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            textStyle: titleStyle,
            title: title,
            valueText: selectedDate != null
                ? Text(date(selectedDate!.toDate()), style: on)
                : Text(hintText, style: off),
            onPressed: () {
              if (isEnabled) _selectDate(context);
            },
          ),
        ),
      ],
    );
  }
}
