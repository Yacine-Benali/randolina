import 'package:flutter/material.dart';

class NameLocationClub extends StatelessWidget {
  const NameLocationClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O’rando Adventure',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              //   fontFamily: 'Lato-Black',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Club de Randonnée',
            style: TextStyle(
              //   fontFamily: 'Lato-Black',
              fontSize: 17,
              color: Color(0xFF40A3DB),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Oran, Algeria',
            style: TextStyle(
              //     fontFamily: 'Lato-Black',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.87),
            ),
          ),
        ],
      ),
    );
  }
}
