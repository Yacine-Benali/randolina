import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/client_event_card.dart';
import 'package:randolina/app/home/events/widgets/events_detail_form.dart';
import 'package:randolina/app/home/events/widgets/next_button.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/user.dart';
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
  late String actionButtonText;
  late VoidCallback callback;
  late final Client client;

  void setbuttonProperties(ActionButtonState actionButtonState) {
    switch (actionButtonState) {
      case ActionButtonState.subscribe:
        actionButtonText = 'Participer';
        callback = () {
          widget.eventsBloc.subscribeToEvent(widget.event);
          // buttonState(ActionButtonState.unsubscribe);
          // setState(() {});
        };
        break;
      case ActionButtonState.unsubscribe:
        actionButtonText = 'Annuler';
        callback = () {
          widget.eventsBloc.unsubscribeFromEvent(widget.event);
          // buttonState(ActionButtonState.subscribe);
          // setState(() {});
        };
        break;
      case ActionButtonState.unavailable:
        actionButtonText = 'Complet';
        callback = () {};
        break;
      default:
    }
  }

  void setButtonState() {
    bool isSet = false;

    if (widget.event.subscribersLength == widget.event.availableSeats) {
      setbuttonProperties(ActionButtonState.unavailable);
      isSet = true;
    }
    for (final MiniSubscriber miniSubscriber in widget.event.subscribers) {
      if (miniSubscriber.id == client.id) {
        setbuttonProperties(ActionButtonState.unsubscribe);
        isSet = true;
      }
    }
    if (!isSet) {
      setbuttonProperties(ActionButtonState.subscribe);
    }
  }

  @override
  void initState() {
    client = context.read<User>() as Client;
    setButtonState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setButtonState();

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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              EventsDetailForm(event: widget.event),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NextButton(
                  onPressed: () async {
                    callback();
                    Navigator.of(context).pop();
                  },
                  title: actionButtonText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
