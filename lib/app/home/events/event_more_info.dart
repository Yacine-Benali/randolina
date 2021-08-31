import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/widgets/events_detail_form.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/constants/app_colors.dart';

class EventMoreInfo extends StatefulWidget {
  const EventMoreInfo({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  @override
  _EventMoreInfoState createState() => _EventMoreInfoState();
}

class _EventMoreInfoState extends State<EventMoreInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: backgroundColor,
        child: EventsDetailForm(
          event: widget.event,
        ),
      ),
    );
  }
}
