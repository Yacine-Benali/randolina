import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/new_event/new_event_screen.dart';
import 'package:randolina/app/home/events/widgets/client_event_card.dart';
import 'package:randolina/app/home/events/widgets/club_event_card.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextStyle textstyle;
  late int tabIndex;
  late final EventsBloc eventsBloc;
  late final bool isClient;
  late final Stream<List<Event>> myEventsStream;
  late final Stream<List<Event>> allEventsStream;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => setState(() {}));
    textstyle = TextStyle(
      color: darkBlue,
      fontWeight: FontWeight.w800,
    );
    final AuthUser auth = context.read<AuthUser>();
    final Database database = context.read<Database>();
    eventsBloc = EventsBloc(
      database: database,
      authUser: auth,
    );
    if (context.read<User>() is Club || context.read<User>() is Agency) {
      isClient = false;
      myEventsStream = eventsBloc.getClubMyEvents();
      allEventsStream = eventsBloc.getClubAllEvents();
    } else {
      isClient = true;
      myEventsStream = eventsBloc.getClientMyEvents();
      allEventsStream = eventsBloc.getClubAllEvents();
    }
    super.initState();
  }

  Widget buildEvents({required bool isMyEvent}) {
    return StreamBuilder<List<Event>>(
      stream: isMyEvent ? myEventsStream : allEventsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final List<Event> events = snapshot.data!;
          if (events.isNotEmpty) {
            logger.severe('update');
            final List<Widget> widgets = events
                .map(
                  (e) => isClient
                      ? ClientEventCard(
                          key: UniqueKey(),
                          event: e,
                          eventsBloc: eventsBloc,
                        )
                      : ClubEventCard(
                          event: e,
                          eventsBloc: eventsBloc,
                          showControls: isMyEvent,
                        ),
                )
                .toList();
            return Column(children: widgets);
          } else {
            return EmptyContent(
              title: '',
              message: 'You dont have any events',
            );
          }
        } else if (snapshot.hasError) {
          return EmptyContent(
            title: 'Something went wrong',
            message:
                "Can't load items right now\n ${snapshot.error.toString()}",
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 50,
              width: 50,
              color: Colors.amber,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: Material(
                color: Colors.blueGrey[100],
                elevation: 5,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: textstyle,
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                  ),
                  labelColor: Color.fromRGBO(51, 77, 115, 0.78),
                  unselectedLabelColor: Color.fromRGBO(51, 77, 115, 0.78),
                  tabs: [
                    Tab(text: 'My events'),
                    Tab(text: 'All events'),
                  ],
                ),
              ),
            ),
          ),
          if (!isClient && _tabController.index == 0) ...[
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 8.0, right: 8, left: 8),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewEventScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add',
                      style:
                          TextStyle(color: Color.fromRGBO(51, 77, 115, 0.78)),
                    ),
                    Icon(Icons.add, color: Color.fromRGBO(51, 77, 115, 0.78))
                  ],
                ),
              ),
            ),
          ],
          if (_tabController.index == 0) ...[buildEvents(isMyEvent: true)],
          if (_tabController.index == 1) ...[buildEvents(isMyEvent: false)],
        ],
      ),
    );
  }
}
