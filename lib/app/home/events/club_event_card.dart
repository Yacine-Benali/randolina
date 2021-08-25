import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClubEventCard extends StatefulWidget {
  const ClubEventCard({Key? key}) : super(key: key);

  @override
  _ClubEventCardState createState() => _ClubEventCardState();
}

class _ClubEventCardState extends State<ClubEventCard> {
  String formatDate() {
    final Timestamp tempDay = Timestamp.now();
    final DateTime tempDay2 = tempDay.toDate();
    final DateFormat formatter = DateFormat('dd LLLL');
    final String formatted = formatter.format(tempDay2);
    return formatted;
  }

  Widget buildTopPart() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Text(
            "O'rando Adeventure",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: 30,
                width: 80,
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
                    stops: const [0, 1],
                    colors: [
                      Color.fromRGBO(64, 163, 219, 1),
                      Color.fromRGBO(64, 163, 219, 0.5)
                    ],
                  ),
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                  ),
                  child: Text('Edit'),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_outline_outlined),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBottomPart() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
      child: ClipRect(
        child: Banner(
          location: BannerLocation.topEnd,
          message: "1200 da",
          color: Colors.red.withOpacity(0.6),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          //textDirection: TextDirection.ltr,
          child: Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue[200],
              image: DecorationImage(
                image:
                    NetworkImage('https://source.unsplash.com/random/?sig=15'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        formatDate(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.33,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ).frosted(
                        blur: 1,
                        borderRadius: BorderRadius.circular(20),
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              // todo textoverflow
                              "Montange tikajda tikajda ***** ***** **** *****",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.33,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ).frosted(
                              blur: 1,
                              borderRadius: BorderRadius.circular(20),
                              padding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                buildTopPart(),
                buildBottomPart(),
              ],
            ),
            Positioned(
              top: 50,
              child: Container(
                width: 75,
                height: 75,
                margin: const EdgeInsets.only(left: 20),
                child: CachedNetworkImage(
                  imageUrl: 'https://source.unsplash.com/random/?sig=92',
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(backgroundImage: imageProvider),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
