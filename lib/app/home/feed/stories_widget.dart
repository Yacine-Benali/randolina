import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/temp.dart';

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 9.0, left: 21.0, bottom: 4),
          alignment: Alignment.centerLeft,
          child: Text(
            'recent stories ...',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.58),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 90,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: store.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(37),
                          boxShadow: [
                            // BoxShadow(
                            //   color: Color(0xFF334D73),
                            //   spreadRadius: 0.025,
                            //   blurRadius: 10,
                            //   offset: Offset(0, 4),
                            // ),
                          ],
                        ),
                        child: Image.asset(store[index]['image']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${store[index]['nom']!}*****',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
