import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/feed_screen.dart';
import 'package:randolina/app/home/feed/temp.dart';

class PostWidget extends StatefulWidget {
  PostWidget({Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final index = 0;

  late bool showPopMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 473,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.20),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 4, left: 25, right: 25),
      child: Column(
        children: [
          Container(
            height: 78,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(top: 10, left: 20),
                        child: Image.asset(post[index]['profile']!),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16, left: 10),
                        child: Text(
                          post[index]['nom']!,
                          style: TextStyle(
                            fontFamily: 'Lato-Light',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
                  onSelected: (FilterOptions selectedValue) {
                    setState(() {
                      if (selectedValue == FilterOptions.Report_this_post) {
                        showPopMenu = true;
                      } else {
                        showPopMenu = false;
                      }
                    });
                  },
                  icon: Container(
                    height: 15,
                    margin: const EdgeInsets.only(top: 17, right: 5),
                    child: Image.asset('assets/icons/options.png'),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: FilterOptions.Report_this_post,
                      child: Container(
                        width: 191,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Divider(
                              height: 3,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rport this post',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.85),
                                      fontFamily: 'Lato-Light',
                                    ),
                                  ),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/icons/Vector 4.png',
                                        ),
                                        Positioned(
                                          top: 7,
                                          left: 7,
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            child: Image.asset(
                                              'assets/icons/Vector 5.png',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 3,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 245,
            margin: const EdgeInsets.only(left: 7, right: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              image: DecorationImage(
                image: AssetImage(post[index]['image']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(top: 17, right: 20),
                          child: Image.asset('assets/icons/Vector 1.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(top: 17, right: 5),
                          child: Image.asset('assets/icons/Vector 2.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 17, right: 5),
                  child: Image.asset('assets/icons/Vector 3.png'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 9.0, left: 21.0),
            alignment: Alignment.centerLeft,
            child: Text(
              '55 likes',
              style: TextStyle(
                fontFamily: 'Lato-Light',
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 42,
            margin: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 10),
                  child: Text(
                    post[index]['nom']!,
                    style: TextStyle(
                      fontFamily: 'Lato-Light',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  margin: const EdgeInsets.only(top: 16, left: 10),
                  child: Text(
                    post[index]['commentaire']!,
                    style: TextStyle(
                      fontFamily: 'Lato-Light',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 9.0, left: 21.0),
            alignment: Alignment.centerLeft,
            child: Text(
              '15 minutes ago',
              style: TextStyle(
                fontFamily: 'Lato-Light',
                color: Color.fromRGBO(0, 0, 0, 0.55),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
