import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/widgets/club_event_card.dart';
import 'package:randolina/app/home/events/new_event_screen.dart';
import 'package:randolina/constants/app_colors.dart';

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
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => setState(() {}));
    textstyle = TextStyle(
      color: darkBlue,
      fontWeight: FontWeight.w800,
    );
    super.initState();
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
          Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 8.0, right: 8, left: 8),
            child: ElevatedButton(
              onPressed: () {
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
                    style: TextStyle(color: Color.fromRGBO(51, 77, 115, 0.78)),
                  ),
                  Icon(Icons.add, color: Color.fromRGBO(51, 77, 115, 0.78))
                ],
              ),
            ),
          ),
          if (_tabController.index == 0) ...[
            ClubEventCard(),
          ],
          if (_tabController.index == 1) ...[
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
