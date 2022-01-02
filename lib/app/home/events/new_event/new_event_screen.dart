import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/new_event/new_event_form1.dart';
import 'package:randolina/app/home/events/new_event/new_event_form2.dart';
import 'package:randolina/app/home/events/new_event/new_events_form3.dart';
import 'package:randolina/app/home_admin/sites/site.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/loading_screen.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({
    Key? key,
    this.event,
  }) : super(key: key);
  final Event? event;

  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  late final PageController _pageController;
  late final EventsBloc eventsBloc;

  Event? event;
  File? profilePicture;
  List<File>? images;

  @override
  void initState() {
    _pageController = PageController();
    final AuthUser auth = context.read<AuthUser>();
    final Database database = context.read<Database>();
    eventsBloc = EventsBloc(
      database: database,
      authUser: auth,
    );

    super.initState();
  }

  void swipePage(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.hasClients) {
          if (_pageController.page == 0) {
            return true;
          } else {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blueGrey),
          title: Text(
            widget.event == null ? 'ajouter un événement' : 'modifier un événement',
            style: TextStyle(
              color: Color.fromRGBO(34, 50, 99, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: FutureBuilder<List<Site>>(
            future: eventsBloc.getSites(),
            builder: (context, snapshot) {
              if (snapshot.hasData && (snapshot.data != null)) {
                final List<Site> sites = snapshot.data!;
                return PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    NewEventForm1(
                      profilePicture: widget.event?.profileImage,
                      onPictureChanged: (File? value) async {
                        profilePicture = value;
                        setState(() {});
                        swipePage(1);
                      },
                    ),
                    NewEventForm2(
                      event: widget.event,
                      profilePicture: profilePicture,
                      eventsBloc: eventsBloc,
                      sites: sites,
                      onNextPressed: ({
                        required Event event,
                        required List<File> images,
                      }) {
                        this.event = event;
                        this.images = images;
                        setState(() {});

                        swipePage(2);
                      },
                    ),
                    NewEventsForm3(
                      images: images,
                      event: event,
                      profilePicture: profilePicture,
                      eventsBloc: eventsBloc,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                // TODO @low work on this screen
                return Material(
                  child: EmptyContent(
                    title: '',
                    message: snapshot.error.toString(),
                  ),
                );
              }
              return LoadingScreen(showAppBar: false);
            }),
      ),
    );
  }
}
