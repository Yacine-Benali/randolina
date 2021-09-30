import 'package:blur/blur.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/nested_screens/client_event_detail_screen.dart';
import 'package:randolina/app/home/events/widgets/event_more_info.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/utils.dart';

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

  Widget buildList(Event event) {
    return GestureDetector(
      onTap: () {
        if (context.read<User>() is Client) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ClientEventDetailScreen(
                event: event,
                eventsBloc: eventsBloc,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventMoreInfo(event: event),
            ),
          );
        }
      },
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 2, left: 2),
              child: ClipRect(
                child: Banner(
                  location: BannerLocation.topEnd,
                  message: "${event.price.toInt()} DA",
                  color: Colors.red.withOpacity(0.6),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
                  ),
                  //textDirection: TextDirection.ltr,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(event.profileImage),
                        fit: BoxFit.cover,
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
                                eventCardDateFormat(event.startDateTime),
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
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: BorderedText(
                                      strokeColor: Colors.black,
                                      strokeWidth: 3.0,
                                      child: Text(
                                        event.destination,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
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
            ),
          ),
        ),
      ),
    );
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
                  return buildList(events[index]);
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
