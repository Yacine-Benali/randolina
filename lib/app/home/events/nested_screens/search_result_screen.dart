import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/client_event_card.dart';
import 'package:randolina/app/home/events/widgets/club_event_card.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({
    Key? key,
    required this.events,
    required this.eventsBloc,
    required this.isMyevent,
  }) : super(key: key);
  final List<Event> events;
  final EventsBloc eventsBloc;
  final bool isMyevent;

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late final bool isClient;

  @override
  void initState() {
    if (context.read<User>() is Club || context.read<User>() is Agency) {
      isClient = false;
    } else {
      isClient = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (widget.events.isNotEmpty) {
      final List<Widget> widgets = [];
      for (final Event event in widget.events) {
        Widget w;
        if (isClient) {
          w = ClientEventCard(
            key: Key(event.id),
            event: event,
            eventsBloc: widget.eventsBloc,
          );
        } else {
          w = ClubEventCard(
            event: event,
            eventsBloc: widget.eventsBloc,
            showControls: widget.isMyevent,
          );
        }
        widgets.add(w);
      }

      return Column(children: widgets);
    } else {
      return EmptyContent(
        title: '',
        message: 'aucun événement ne correspond au filtre de recherche ',
      );
    }
  }
}
