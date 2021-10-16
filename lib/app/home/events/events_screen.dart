import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/new_event/new_event_screen.dart';
import 'package:randolina/app/home/events/widgets/client_event_card.dart';
import 'package:randolina/app/home/events/widgets/club_event_card.dart';
import 'package:randolina/app/home/events/widgets/events_search.dart';
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
  final RefreshController _refreshController = RefreshController();
  late ValueNotifier<List<Event>> currentlyChosenEventsNotifier;

  String searchText = '';

  @override
  void initState() {
    currentlyChosenEventsNotifier = ValueNotifier([]);
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
    return FutureBuilder(
      future: isClient
          ? eventsBloc.getSavedEvents()
          : Future.delayed(Duration(microseconds: 200)),
      builder: (_, snapshot) {
        return StreamBuilder<List<Event>>(
          stream: isMyEvent ? myEventsStream : allEventsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final List<Event> events = snapshot.data!;
              if (events.isNotEmpty) {
                final List<Event> matchedEvents = eventsBloc.eventsTextSearch(
                  events,
                  searchText,
                );
                Future.delayed(Duration(milliseconds: 500)).then((value) =>
                    currentlyChosenEventsNotifier.value = matchedEvents);
                final List<Widget> widgets = [];
                for (final Event event in matchedEvents) {
                  Widget w;
                  if (isClient) {
                    w = ClientEventCard(
                      key: Key(event.id),
                      event: event,
                      eventsBloc: eventsBloc,
                    );
                  } else {
                    w = ClubEventCard(
                      event: event,
                      eventsBloc: eventsBloc,
                      showControls: isMyEvent,
                    );
                  }
                  widgets.add(w);
                }

                return Column(children: widgets);
              } else {
                return EmptyContent(
                  title: '',
                  message: "Vous n'avez aucun événement",
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
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            ChangeNotifierProvider.value(
              value: currentlyChosenEventsNotifier,
              child: EventsSearch(
                onWilayaChanged: (int wilaya) {
                  logger.severe(wilaya);
                },
                eventsBloc: eventsBloc,
                // ignore: avoid_bool_literals_in_conditional_expressions
                isMyevent: _tabController.index == 0 ? true : false,
                onTextChanged: (t) {
                  setState(() => searchText = t);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: SizedBox(
                height: 30,
                child: Material(
                  color: Colors.grey[300],
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
                      Tab(text: 'Mes événements'),
                      Tab(text: 'Tous les évènements'),
                    ],
                  ),
                ),
              ),
            ),
            if (isClient) ...[SizedBox(height: 36)],
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
                        'Ajouter',
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
            if (_tabController.index == 1) ...[
              SizedBox(height: 20),
              buildEvents(isMyEvent: false)
            ],
          ],
        ),
      ),
    );
  }
}
