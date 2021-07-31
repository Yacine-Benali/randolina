import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:randolina/constants/algeria_cities.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    Key? key,
    required this.onChanged,
    required this.hint,
    required this.title,
    this.validator,
    this.options,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final String hint;
  final String title;
  final List<String>? options;
  final String? Function(String?)? validator;
  @override
  _WilayaPickerState createState() => _WilayaPickerState();
}

class _WilayaPickerState extends State<CustomDropDown> {
  late Set<String> options;
  String? dropdownValue;
  @override
  void initState() {
    //! fix this, this is a temp fixs
    if (widget.options != null) {
      options = widget.options!.toSet();
    } else {
      options = algeriaCities
          .map((e) {
            return "${e['wilaya_code']} - ${e['wilaya_name_ascii']}";
          })
          .toList()
          .toSet();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: BorderedText(
            strokeColor: Colors.black,
            strokeWidth: 3.0,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 2),
        DropdownButtonFormField<String>(
          focusColor: Colors.transparent,
          validator: widget.validator,
          hint: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              widget.hint,
              style: TextStyle(fontSize: 16),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(119, 138, 164, 1),
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(119, 138, 164, 1),
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: Color.fromRGBO(119, 138, 164, 1),
              ),
            ),
          ),
          isExpanded: true,
          value: dropdownValue,
          icon: Icon(Icons.expand_more),
          style: TextStyle(color: Colors.black),
          onChanged: (String? newValue) {
            setState(() => dropdownValue = newValue);
            if (dropdownValue != null) {
              widget.onChanged(dropdownValue!);
            }
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
