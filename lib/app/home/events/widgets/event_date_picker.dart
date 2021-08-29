import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDatePicker extends StatelessWidget {
  const EventDatePicker({
    Key? key,
    required this.title,
    required this.selectedDate,
    required this.onSelectedDate,
    required this.hintText,
  }) : super(key: key);

  final String hintText;
  final String title;
  final Timestamp? selectedDate;
  final ValueChanged<Timestamp> onSelectedDate;

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(34, 50, 99, 1),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 2),

          // because it not redondant
          // ignore: avoid_unnecessary_containers
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: Colors.blueGrey,
              ),
            ),
            child: Material(
              type: MaterialType.button,
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              elevation: 5.0,
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // ignore: prefer_if_elements_to_conditional_expressions
                    selectedDate != null
                        ? Text(date(selectedDate!.toDate()), style: on)
                        : Text(hintText, style: off),
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
