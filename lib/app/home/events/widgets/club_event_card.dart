import 'package:blur/blur.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/club_participants_screen.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/new_event/new_event_screen.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:randolina/utils/utils.dart';

class ClubEventCard extends StatefulWidget {
  const ClubEventCard({
    Key? key,
    required this.event,
    required this.eventsBloc,
    this.showControls = true,
  }) : super(key: key);

  final EventsBloc eventsBloc;
  final Event event;
  final bool showControls;
  @override
  _ClubEventCardState createState() => _ClubEventCardState();
}

class _ClubEventCardState extends State<ClubEventCard> {
  Future<void> deleteEvent() async {
    final bool? didRequestSignOut = await PlatformAlertDialog(
      title: 'Confirm',
      content: 'are you sure you want to delete this event',
      cancelActionText: 'cancel',
      defaultActionText: 'yes',
    ).show(context);
    if (didRequestSignOut == true) {
      widget.eventsBloc.deleteEvent(widget.event);
    }
  }

  void goToEventDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClubParticipantScreen(
          event: widget.event,
          eventsBloc: widget.eventsBloc,
        ),
      ),
    );
  }

  Widget buildTopPart() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            widget.event.createdBy.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.showControls) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0,
                      )
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0, 1],
                      colors: [
                        Color.fromRGBO(64, 163, 219, 1),
                        Color.fromRGBO(64, 163, 219, 0.5)
                      ],
                    ),
                    color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewEventScreen(
                            event: widget.event,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                    ),
                    child: Text('Edit'),
                  ),
                ),
              ),
              IconButton(
                onPressed: deleteEvent,
                icon: Icon(Icons.delete_outline_outlined),
              ),
            ],
          ),
        ],
        if (!widget.showControls) ...[
          SizedBox(
            height: 30,
            width: 80,
          ),
        ],
      ],
    );
  }

  Widget buildBottomPart() {
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
                image: NetworkImage(widget.event.profileImage),
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
                      SizedBox(width: 50),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: goToEventDetails,
                          icon: Icon(Icons.info_outlined),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                buildTopPart(),
                GestureDetector(
                  onTap: goToEventDetails,
                  child: buildBottomPart(),
                ),
              ],
            ),
            Positioned(
              top: 50,
              child: SizedBox(
                width: 75,
                height: 75,
                child: CachedNetworkImage(
                  imageUrl: widget.event.createdBy.profilePicture,
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(backgroundImage: imageProvider),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
