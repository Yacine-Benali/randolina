import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/events_detail_form.dart';
import 'package:randolina/app/home/events/widgets/next_button.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/constants/app_colors.dart';

class ClientEventDetailScreen extends StatefulWidget {
  const ClientEventDetailScreen({
    Key? key,
    required this.event,
    required this.eventsBloc,
  }) : super(key: key);
  final Event event;
  final EventsBloc eventsBloc;

  @override
  _ClientEventDetailScreenState createState() =>
      _ClientEventDetailScreenState();
}

class _ClientEventDetailScreenState extends State<ClientEventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'event info',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              EventsDetailForm(event: widget.event),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NextButton(
                  onPressed: () async {
                    await widget.eventsBloc.subscribeToEvent(widget.event);
                    Navigator.of(context).pop();
                  },
                  title: 'Apply',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
