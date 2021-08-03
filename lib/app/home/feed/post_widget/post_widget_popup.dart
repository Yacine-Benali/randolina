import 'package:flutter/material.dart';

enum FilterOptions {
  reportthispost,
}

class PostWidgetPopUp extends StatefulWidget {
  const PostWidgetPopUp({Key? key}) : super(key: key);

  @override
  _PostWidgetPopUpState createState() => _PostWidgetPopUpState();
}

class _PostWidgetPopUpState extends State<PostWidgetPopUp> {
  late bool showPopMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      )),
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.reportthispost) {
          showPopMenu = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Post reported to admins'),
            ),
          );
          // todo @average call the report function
        } else {
          showPopMenu = false;
        }

        setState(() {});
      },
      icon: Container(
        height: 15,
        margin: const EdgeInsets.only(right: 5),
        child: Image.asset('assets/icons/options.png'),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: FilterOptions.reportthispost,
          child: SizedBox(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rport this post',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.85),
                        fontFamily: 'Lato-Black',
                      ),
                    ),
                    SizedBox(
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
                            child: SizedBox(
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
    );
  }
}
