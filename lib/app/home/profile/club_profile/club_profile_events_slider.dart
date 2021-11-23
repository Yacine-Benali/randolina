import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/profile/club_profile/club_profile_event_card.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class ClubProfileEventSlider extends StatefulWidget {
  const ClubProfileEventSlider({
    Key? key,
    required this.clubOrAgency,
    required this.profileBloc,
  }) : super(key: key);
  final User clubOrAgency;
  final ProfileBloc profileBloc;

  @override
  _ClubProfileEventSliderState createState() => _ClubProfileEventSliderState();
}

class _ClubProfileEventSliderState extends State<ClubProfileEventSlider> {
  late final Stream<List<Event>> stream;
  late final EventsBloc eventsBloc;

  @override
  void initState() {
    final AuthUser auth = context.read<AuthUser>();
    final Database database = context.read<Database>();
    eventsBloc = EventsBloc(
      database: database,
      authUser: auth,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<List<Event>>(
        stream: widget.profileBloc.getClubAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<Event> events = snapshot.data!;
            if (events.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (contex, index) {
                  return ClubProfileEventCard(
                    event: events[index],
                    eventsBloc: eventsBloc,
                  );
                },
              );
            } else {
              return EmptyContent(
                title: '',
                message: "ce club n'a pas d'événements",
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: "Quelque chose s'est mal passé",
              message:
                  "Impossible de charger les éléments pour le moment\n ${snapshot.error.toString()}",
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
