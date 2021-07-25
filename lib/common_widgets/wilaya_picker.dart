import 'package:flutter/material.dart';
import 'package:randolina/constants/algeria_cities.dart';

class WilayaPicker extends StatefulWidget {
  const WilayaPicker({Key? key}) : super(key: key);

  @override
  _WilayaPickerState createState() => _WilayaPickerState();
}

class _WilayaPickerState extends State<WilayaPicker> {
  late Set<String> wilayate;
  String? dropdownValue;
  @override
  void initState() {
    wilayate = algeria_cites
        .map((e) => e['wilaya_name_ascii'].toString())
        .toList()
        .toSet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Wilaya:',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              border: Border.all(
                color: Color.fromRGBO(119, 138, 164, 1),
              ),
            ),
            height: 58,
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue ?? wilayate.first,
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.expand_more),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                print(newValue);
                setState(() => dropdownValue = newValue);
              },
              items: wilayate.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(value),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
