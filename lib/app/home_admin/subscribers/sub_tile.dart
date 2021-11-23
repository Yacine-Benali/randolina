import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/subscribers/sub_bloc.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/utils/logger.dart';
import 'package:randolina/utils/utils.dart';
import 'package:tuple/tuple.dart';

// todo @low move this somewhere else
enum ActionButtonState { active, inactive }

class SubTile extends StatefulWidget {
  const SubTile({
    Key? key,
    required this.tuple,
    required this.subBloc,
  }) : super(key: key);

  final SubBloc subBloc;
  final Tuple2<Subscription, User> tuple;
  @override
  _SubTileState createState() => _SubTileState();
}

class _SubTileState extends State<SubTile> {
  late bool isSaved;
  double? topPartHeight;
  late final Client client;
  late Subscription subscription;
  String userType = '';

  @override
  void initState() {
    subscription =
        Subscription.fromMap(widget.tuple.item1.toMap(), widget.tuple.item1.id);

    if (widget.tuple.item2 is Club) {
      userType = 'Club';
    } else if (widget.tuple.item2 is Agency) {
      userType = 'Agence';
    } else if (widget.tuple.item2 is Store) {
      userType = 'Magazin';
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SubTile oldWidget) {
    subscription =
        Subscription.fromMap(widget.tuple.item1.toMap(), widget.tuple.item1.id);
    super.didUpdateWidget(oldWidget);
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
              widget.tuple.item2.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            userType,
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
                    color: subscription.isActive ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      subscription.isActive = !subscription.isActive;
                      setState(() {});
                      save();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                    ),
                    child:
                        Text(subscription.isActive ? 'Desactiver' : 'Activer'),
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(Icons.info_outline),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> save() async {
    print(subscription.startsAt);
    print(widget.tuple.item1.startsAt);
    try {
      if (subscription.startsAt != widget.tuple.item1.startsAt ||
          subscription.endsAt != widget.tuple.item1.endsAt ||
          subscription.isActive != widget.tuple.item1.isActive) {
        await widget.subBloc.saveSubscription(subscription);
      }
    } on Exception catch (e) {
      logger.severe(e);
      PlatformExceptionAlertDialog(exception: e).show(context);
    }
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
              buildEnd(),
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
              final DateTime temp = subscription.startsAt?.toDate() != null
                  ? subscription.startsAt!.toDate()
                  : DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: temp,
                firstDate: DateTime(1960),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                subscription.startsAt = Timestamp.fromDate(pickedDate);
                setState(() {});
                save();
              }
            },
            child: Text(
              subscription.startsAt != null
                  ? particpantDateFormmater(subscription.startsAt!)
                  : 'Pas de date',
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

  Widget buildEnd() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'A:',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          GestureDetector(
            onTap: () async {
              if (subscription.startsAt == null) {
                PlatformAlertDialog(
                  title: 'Erreur',
                  content: 'Veuillez commencer par la date de début',
                ).show(context);
                return;
              }

              final DateTime temp = subscription.endsAt?.toDate() != null
                  ? subscription.endsAt!.toDate()
                  : DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: temp,
                firstDate: DateTime(1960),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                if (pickedDate.isBefore(subscription.startsAt!.toDate())) {
                  // ignore: use_build_context_synchronously
                  PlatformAlertDialog(
                    title: 'Erreur',
                    content:
                        'la date de fin ne peut pas être avant à la date de début',
                  ).show(context);
                  return;
                }
                subscription.endsAt = Timestamp.fromDate(pickedDate);
                setState(() {});
                save();
              }
            },
            child: Text(
              subscription.endsAt != null
                  ? particpantDateFormmater(subscription.endsAt!)
                  : 'Pas de date',
              style: TextStyle(fontSize: 16),
            ).frosted(
              padding: EdgeInsets.all(8),
            ),
          ),
        ],
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
                buildBottomPart(),
              ],
            ),
            Positioned(
              top: 50,
              child: GestureDetector(
                onTap: () {},
                child: ImageProfile(
                  url: widget.tuple.item2.profilePicture,
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
