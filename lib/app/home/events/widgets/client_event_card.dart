import 'package:blur/blur.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/client_event_detail_screen.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/feed/miniuser_to_profile.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/mini_subscriber.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/utils/utils.dart';

// todo @low move this somewhere else
enum ActionButtonState { subscribe, unsubscribe, unavailable }

class ClientEventCard extends StatefulWidget {
  const ClientEventCard({
    Key? key,
    required this.event,
    required this.eventsBloc,
  }) : super(key: key);

  final EventsBloc eventsBloc;
  final Event event;
  @override
  _ClientEventCardState createState() => _ClientEventCardState();
}

class _ClientEventCardState extends State<ClientEventCard> {
  late List<Color> actionButtonGradient;
  late String actionButtonText;
  late VoidCallback callback;
  late bool isSaved;
  late final Client client;

  @override
  void initState() {
    client = context.read<User>() as Client;
    setButtonState();
    isSaved = widget.eventsBloc.isEventSaved(widget.event);

    super.initState();
  }

  void setbuttonProperties(ActionButtonState actionButtonState) {
    switch (actionButtonState) {
      case ActionButtonState.subscribe:
        actionButtonGradient = [
          Color.fromRGBO(125, 207, 123, 1),
          Color.fromRGBO(125, 207, 123, 0.8),
        ];
        actionButtonText = 'Participer';
        callback = () {
          widget.eventsBloc.subscribeToEvent(widget.event);
          // buttonState(ActionButtonState.unsubscribe);
          // setState(() {});
        };
        break;
      case ActionButtonState.unsubscribe:
        actionButtonGradient = [
          Color.fromRGBO(251, 106, 106, 1),
          Color.fromRGBO(251, 106, 106, 0.8),
        ];
        actionButtonText = 'Annuler';
        callback = () {
          widget.eventsBloc.unsubscribeFromEvent(widget.event);
          // buttonState(ActionButtonState.subscribe);
          // setState(() {});
        };
        break;
      case ActionButtonState.unavailable:
        actionButtonGradient = [
          Color.fromRGBO(251, 106, 106, 1),
          Color.fromRGBO(251, 106, 106, 0.8),
        ];
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

  void goToEventDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientEventDetailScreen(
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
                    colors: actionButtonGradient,
                  ),
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    callback();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                  ),
                  child: Text(actionButtonText),
                ),
              ),
            ),
            Row(
              children: [
                //! todo @low for later
                // IconButton(
                //   onPressed: () {
                //     if (isSaved == false) {
                //       widget.eventsBloc.saveEventToFavorite(widget.event);
                //       print("SAVE");

                //       isSaved = true;
                //     } else if (isSaved == true) {
                //       print("UNSAVE");
                //       widget.eventsBloc.unsaveEventFromFavorite(widget.event);
                //       isSaved = false;
                //     }
                //     setState(() {});
                //   },
                //   icon: Icon(isSaved
                //       ? Icons.bookmark
                //       : Icons.bookmark_border_outlined),
                //   color: Colors.black,
                //   // iconSize: 28,
                // ),
                IconButton(
                  onPressed: goToEventDetails,
                  icon: Icon(Icons.info_outline),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBottomPart() {
    return GestureDetector(
      onTap: goToEventDetails,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
        child: ClipRect(
          child: Banner(
            location: BannerLocation.topEnd,
            message: "${widget.event.price.toInt()} DA",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setButtonState();

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
                buildBottomPart(),
              ],
            ),
            Positioned(
              top: 50,
              child: GestureDetector(
                onTap: () {
                  if (context.read<User>().id != widget.event.createdBy.id) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MiniuserToProfile(
                          miniUser: widget.event.createdBy,
                        ),
                      ),
                    );
                  }
                },
                child: ImageProfile(
                  url: widget.event.createdBy.profilePicture,
                  width: 75,
                  height: 75,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
