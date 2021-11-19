import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:tuple/tuple.dart';

// todo @low move this somewhere else
enum ActionButtonState { subscribe, unsubscribe, unavailable }

class SubTile extends StatefulWidget {
  const SubTile({
    Key? key,
    required this.user,
    //  required this.eventsBloc,
  }) : super(key: key);

  // final EventsBloc eventsBloc;
  final Tuple2<Subscription, User> user;
  @override
  _SubTileState createState() => _SubTileState();
}

class _SubTileState extends State<SubTile> {
  late List<Color> actionButtonGradient;
  late String actionButtonText;
  late VoidCallback callback;
  late bool isSaved;
  double? topPartHeight;
  late final Client client;

  @override
  void initState() {
    setButtonState();

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
          // widget.eventsBloc.subscribeToEvent(widget.user);
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
          // widget.eventsBloc.unsubscribeFromEvent(widget.user);
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
    setbuttonProperties(ActionButtonState.subscribe);
  }

  void goToEventDetails() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => ClientEventDetailScreen(
    //       event: widget.user,
    //       eventsBloc: widget.eventsBloc,
    //     ),
    //   ),
    // );
  }

  Widget buildTopPart() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      topPartHeight = boxConstraints.maxHeight;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.user.item2.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            widget.user.runtimeType.toString(),
            style: TextStyle(fontSize: 14, color: Colors.blue),
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
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                    ),
                    child: Text(actionButtonText),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.info_outline),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget buildBottomPart() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.9],
              colors: [
                Color.fromRGBO(64, 163, 219, 0.0),
                Color.fromRGBO(64, 163, 219, 0.8)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStart(),
              buildStart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStart() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Du:',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          GestureDetector(
            onTap: () async {
              // final DateTime temp = selectedDate != null
              //     ? selectedDate!.toDate()
              //     : DateTime.now();
              // final pickedDate = await showDatePicker(
              //   context: context,
              //   initialDate: temp,
              //   firstDate: DateTime(1960),
              //   lastDate: DateTime(2100),
              // );
              // if (pickedDate != null) {
              //   onSelectedDate(Timestamp.fromDate(pickedDate));
              // }
            },
            child: Text(
              '15/08/2021',
              style: TextStyle(fontSize: 16),
            ).frosted(
              blur: 5,
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //setButtonState();

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
                onTap: () {},
                child: ImageProfile(
                  url: widget.user.item2.profilePicture,
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
