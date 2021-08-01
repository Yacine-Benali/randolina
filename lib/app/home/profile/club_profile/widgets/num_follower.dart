import 'package:flutter/material.dart';

class NumFollowers extends StatelessWidget {
  const NumFollowers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      bottom: 6,
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 5,
                color: Color(0xFFE5E5E5),
              ),
              // Border(
              //   top: BorderSide(
              //     width: 5,
              //     color: Color(0xFFE5E5E5),
              //   ),
              //   left: BorderSide(
              //     width: 5,
              //     color: Color(0xFFE5E5E5),
              //   ),
              //   right: BorderSide(
              //     width: 5,
              //     color: Color(0xFFE5E5E5),
              //   ),

              // ),
              borderRadius: BorderRadius.circular(70),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(1, 3),
                  color: Color(0xFF334D73).withOpacity(0.20),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Ellipse 10.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
