import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/widgets/events_detail_form.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubEventDetailScreen extends StatefulWidget {
  const ClubEventDetailScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  @override
  _ClubEventDetailScreenState createState() => _ClubEventDetailScreenState();
}

class _ClubEventDetailScreenState extends State<ClubEventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "informations sur l'événement",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            if (widget.event.site != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF334D73), shape: BoxShape.circle),
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        launch('http:${widget.event.site!.url}');
                      },
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              EventsDetailForm(event: widget.event),
            ],
          ),
        ),
      ),
    );
  }
}
