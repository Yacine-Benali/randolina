import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:ndialog/ndialog.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/event_difficulty_picker.dart';
import 'package:randolina/app/home/events/widgets/next_button.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/utils/logger.dart';
import 'package:randolina/utils/utils.dart';
import 'package:uuid/uuid.dart';

class NewEventsForm3 extends StatefulWidget {
  const NewEventsForm3({
    Key? key,
    required this.event,
    required this.profilePicture,
    required this.images,
    required this.eventsBloc,
  }) : super(key: key);

  final Event? event;
  final File? profilePicture;
  final List<Asset>? images;
  final EventsBloc eventsBloc;
  @override
  _NewEventsForm3State createState() => _NewEventsForm3State();
}

class _NewEventsForm3State extends State<NewEventsForm3> {
  Widget buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(34, 50, 99, 1),
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget buildProfilePicture() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
      child: ClipRect(
        child: Banner(
          location: BannerLocation.topEnd,
          message: "${widget.event!.price} da",
          color: Colors.red.withOpacity(0.6),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          //textDirection: TextDirection.ltr,
          child: Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue[200],
            ),
            child: Image.file(widget.profilePicture!, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Future<void> finish() async {
    try {
      final ProgressDialog progressDialog = ProgressDialog(
        context,
        message: Text("Loading"),
        title: Text("uploading images"),
      );

      progressDialog.show();

      final Uuid uuid = Uuid();
      final String eventId = uuid.v4();
      final String profilePictureUrl =
          await widget.eventsBloc.uploadEventProfileImage(
        widget.profilePicture!,
        eventId,
      );
      final List<String> imagesUrls =
          await widget.eventsBloc.uploadEventImages(widget.images!);

      final Event event = Event(
        images: imagesUrls,
        profileImage: profilePictureUrl,
        destination: widget.event!.destination,
        price: widget.event!.price,
        description: widget.event!.description,
        walkingDistance: widget.event!.walkingDistance,
        startDateTime: widget.event!.startDateTime,
        endDateTime: widget.event!.endDateTime,
        difficulty: widget.event!.difficulty,
        instructions: widget.event!.instructions,
        availableSeats: widget.event!.availableSeats,
      );
      await widget.eventsBloc.saveEvent(eventId, event);
      progressDialog.dismiss();
      Navigator.of(context).pop();
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildProfilePicture(),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'event pictures',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(enableInfiniteScroll: false),
              items: widget.images!.map((Asset asset) {
                if (asset.originalWidth == null ||
                    asset.originalHeight == null) {
                  logger.severe('null height or width ');
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AssetThumb(
                    asset: asset,
                    width: asset.originalWidth ?? 300,
                    height: asset.originalHeight ?? 300,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 15),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              elevation: 5.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      buildTitle('Description :'),
                      Text(
                        widget.event!.description,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    SizedBox(height: 50),
                    buildTitle("information principales :"),
                    ...[
                      SizedBox(height: 25),
                      buildTitle('Date de depart :'),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 8),
                        child: Text(
                          eventDateFormat(widget.event!.startDateTime.toDate()),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    ...[
                      SizedBox(height: 25),
                      buildTitle("Date de d'arriver :"),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 8),
                        child: Text(
                          eventDateFormat(widget.event!.endDateTime.toDate()),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    ...[
                      SizedBox(height: 40),
                      EventDifficultyPicker(
                        onChanged: (t) {},
                        enabled: false,
                      ),
                    ],
                    ...[
                      SizedBox(height: 10),
                      buildTitle("distance de marche :"),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 8),
                        child: Text(
                          '${widget.event!.walkingDistance} KM',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    ...[
                      SizedBox(height: 25),
                      buildTitle('Instructions :'),
                      Text(
                        widget.event!.instructions,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    ...[
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTitle('Price :'),
                          Text(
                            "${widget.event!.price.toInt()} DA",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32.0, right: 8, left: 8),
                      child: NextButton(
                        title: 'Finish',
                        onPressed: finish,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
