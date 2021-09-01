import 'package:flutter/material.dart';
import 'package:randolina/app/models/event.dart';

class ClubParticipantScreen extends StatefulWidget {
  const ClubParticipantScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  @override
  _ClubParticipantScreenState createState() => _ClubParticipantScreenState();
}

class _ClubParticipantScreenState extends State<ClubParticipantScreen> {
  bool isSelectAll = false;
  bool showConfirmedOnly = false;

  Widget buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.20),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Particiapnt List',
            style: TextStyle(
              color: Color.fromRGBO(51, 77, 115, 0.7),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
      child: ClipRect(
        child: Banner(
          location: BannerLocation.topEnd,
          message: "${widget.event.price.toInt()} DA",
          color: Colors.red.withOpacity(0.6),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          //textDirection: TextDirection.ltr,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(widget.event.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTableOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('select all'),
            Checkbox(
                value: isSelectAll,
                onChanged: (t) {
                  if (t != null) {
                    setState(() {
                      isSelectAll = t;
                    });
                  }
                }),
          ],
        ),
        Switch(
          value: showConfirmedOnly,
          onChanged: (t) {
            setState(() {
              showConfirmedOnly = t;
            });
          },
        )
      ],
    );
  }

  Widget buildRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
        ),
        Container(
          width: 60,
          height: 20,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildAppBar(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
            child: buildEventCard(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: buildTableOptions(),
          ),
          buildRow(),
        ],
      ),
    );
  }
}
