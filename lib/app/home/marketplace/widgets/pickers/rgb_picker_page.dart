import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:randolina/common_widgets/size_config.dart';

class RGBPickerPage extends StatefulWidget {
  @override
  _RGBPickerPageState createState() => _RGBPickerPageState();
}

class _RGBPickerPageState extends State<RGBPickerPage> {
  Color color = Colors.blue;
  // ignore: use_setters_to_change_properties
  void onChanged(Color value) => color = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisir une couleur'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, null);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            child: SizedBox(
              width: 300,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1.0),
                  ),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 2.0,
                  ),

                  ///---------------------------------
                  child: ColorPicker(
                    color: color,
                    onChanged: (value) {
                      color = value;
                    },
                  ),

                  ///---------------------------------
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, color),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(
                        Size(SizeConfig.screenWidth, 60)),
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
                      'Couleur choisie',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
