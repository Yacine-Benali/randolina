import 'package:blur/blur.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/participant_card.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/participant.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/utils.dart';

class ClubParticipantScreen extends StatefulWidget {
  const ClubParticipantScreen({
    Key? key,
    required this.event,
    required this.eventsBloc,
  }) : super(key: key);
  final Event event;
  final EventsBloc eventsBloc;
  @override
  _ClubParticipantScreenState createState() => _ClubParticipantScreenState();
}

class _ClubParticipantScreenState extends State<ClubParticipantScreen> {
  bool isSelectAll = false;
  bool showConfirmedOnly = false;
  final List<Participant> participants = [];

  Widget buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.20),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              await widget.eventsBloc
                  .saveParticipants(participants, widget.event);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.save_outlined),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Particiapnt List',
                style: TextStyle(
                  color: Color.fromRGBO(51, 77, 115, 0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEventCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
      child: ClipRect(
        child: Banner(
          location: BannerLocation.topEnd,
          message: "${widget.event.price.toInt()} DA",
          color: Colors.red.withOpacity(0.6),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          //textDirection: TextDirection.ltr,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.event.profileImage),
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
                        eventCardDateFormat(widget.event.startDateTime),
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
                                widget.event.destination,
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
    );
  }

  Widget buildTableOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('select all'),
            Checkbox(
              value: isSelectAll,
              onChanged: (t) {
                if (t != null) {
                  if (t == true) {
                    for (final Participant element in participants) {
                      element.isConfirmed = true;
                    }
                  }
                  setState(() {
                    isSelectAll = t;
                  });
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Text('show confirmed only'),
            Switch(
              value: showConfirmedOnly,
              onChanged: (t) {
                setState(() {
                  showConfirmedOnly = t;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildList() {
    return FutureBuilder<List<Participant>>(
      future: widget.eventsBloc.getEventParticipant(widget.event),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (participants.isEmpty) participants.addAll(snapshot.data!);
          if (participants.isNotEmpty) {
            final List<Widget> widgets = [];
            int index = 1;
            for (final Participant participant in participants) {
              if (showConfirmedOnly) {
                if (participant.isConfirmed) {
                  final w = Padding(
                    padding: const EdgeInsets.all(8),
                    child: ParticipantCard(
                      key: UniqueKey(),
                      onSelected: (t) {
                        participant.isConfirmed = t;
                      },
                      participant: participant,
                      index: index,
                    ),
                  );
                  widgets.add(w);
                  index++;
                }
              } else {
                final w = Padding(
                  padding: const EdgeInsets.all(8),
                  child: ParticipantCard(
                    key: UniqueKey(),
                    onSelected: (t) {
                      participant.isConfirmed = t;
                    },
                    participant: participant,
                    index: index,
                  ),
                );
                widgets.add(w);
                index++;
              }
            }

            return Column(children: widgets);
          } else {
            return EmptyContent(
              title: '',
              message: 'You dont have any participants',
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        children: [
          buildAppBar(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
            child: buildEventCard(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: buildTableOptions(),
          ),
          buildList(),
          // FutureBuilder(
          //     future: Future.delayed(Duration(seconds: 1)),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         return buildList();
          //       } else {
          //         return Padding(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: SizeConfig.screenWidth / 2.2,
          //           ),
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //     }),
        ],
      ),
    );
  }
}
