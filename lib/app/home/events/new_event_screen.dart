import 'package:flutter/material.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  Widget buildButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.25],
          colors: [
            Color.fromRGBO(51, 77, 115, 0.64),
            Color.fromRGBO(64, 191, 255, 1),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all(
            Size(SizeConfig.screenWidth, 60),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: Text(
          'add an event',
          style: TextStyle(
            color: Color.fromRGBO(34, 50, 99, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                'Principal picture of event',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(34, 50, 99, 1),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 5.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 70)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Upload picture',
                        style: TextStyle(
                          color: Color.fromRGBO(51, 77, 115, 0.88),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Icon(
                          Icons.file_upload,
                          color: Color.fromRGBO(51, 77, 115, 0.95),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, right: 8, left: 8),
              child: buildButton(context),
            ),
          ],
        ),
      ),
    );
  }
}
