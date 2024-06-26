import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/event_difficulty_picker.dart';
import 'package:randolina/app/home/events/widgets/next_button.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
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
  final List<File>? images;
  final EventsBloc eventsBloc;
  @override
  _NewEventsForm3State createState() => _NewEventsForm3State();
}

class _NewEventsForm3State extends State<NewEventsForm3> {
  final List<Widget> items = <Widget>[];

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
    late Widget w;

    if (widget.profilePicture != null) {
      w = Image.file(
        widget.profilePicture!,
        fit: BoxFit.contain,
      );
    } else if (widget.event != null) {
      w = CachedNetworkImage(
        imageUrl: widget.event!.profileImage,
        fit: BoxFit.contain,
      );
    } else {
      w = Container();
    }

    return ClipRect(
      child: Banner(
        location: BannerLocation.topEnd,
        message: "${widget.event!.price.toInt()} DA",
        color: Colors.red.withOpacity(0.6),
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          letterSpacing: 1.0,
        ),
        child: SizedBox(width: SizeConfig.screenWidth, height: 200, child: w),
      ),
    );
  }

  void buildCarousel() {
    items.clear();
    if (widget.images?.isNotEmpty ?? false) {
      for (final File file in widget.images!) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.file(
            file,
            fit: BoxFit.contain,
            height: SizeConfig.blockSizeVertical * 102,
            width: SizeConfig.blockSizeVertical * 102,
          ),
        );
        items.add(w);
      }
    }
    if (widget.event != null) {
      for (final String url in widget.event!.images) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            height: SizeConfig.blockSizeVertical * 102,
            width: SizeConfig.blockSizeVertical * 102,
          ),
        );
        items.add(w);
      }
    }
  }

  Future<void> finish() async {
    finish2().then(
      (value) => Fluttertoast.showToast(
        msg: 'Evenement publié avec succès',
        toastLength: Toast.LENGTH_SHORT,
      ),
    );

    Navigator.of(context).pop();
  }

  Future<void> finish2() async {
    final Uuid uuid = Uuid();
    String eventId = uuid.v4();

    try {
      late String profilePictureUrl;
      late String profilePicturePath;
      final List<String> imagesUrls = [];
      final List<String> imagesPath = [];

      if (widget.event != null) {
        if (widget.event!.id != '') eventId = widget.event!.id;

        profilePictureUrl = widget.event!.profileImage;
        profilePicturePath = widget.event!.profileImagePath;
        imagesUrls.addAll(widget.event!.images);
        imagesPath.addAll(widget.event!.imagesPath);
      }

      if (widget.profilePicture != null) {
        profilePicturePath = widget.eventsBloc.getEventImagePath(eventId);
        profilePictureUrl = await widget.eventsBloc.uploadEventProfileImage(
          widget.profilePicture!,
          profilePicturePath,
        );
      }
      if (widget.images != null) {
        final tuple2 =
            await widget.eventsBloc.uploadEventImages(widget.images!, eventId);

        imagesUrls.addAll(tuple2.item1);
        imagesPath.addAll(tuple2.item2);
      }
      final Event event = Event(
        id: eventId,
        images: imagesUrls,
        imagesPath: imagesPath,
        profileImage: profilePictureUrl,
        profileImagePath: profilePicturePath,
        destination: widget.event!.destination,
        price: widget.event!.price,
        description: widget.event!.description,
        walkingDistance: widget.event!.walkingDistance,
        startDateTime: widget.event!.startDateTime,
        endDateTime: widget.event!.endDateTime,
        difficulty: widget.event!.difficulty,
        instructions: widget.event!.instructions,
        availableSeats: widget.event!.availableSeats,
        createdBy: widget.event!.createdBy,
        createdByType: widget.event!.createdByType,
        subscribers: widget.event!.subscribers,
        subscribersLength: widget.event!.subscribersLength,
        createdAt: widget.event!.createdAt,
        wilaya: widget.event!.wilaya,
        site: widget.event!.site,
      );
      await widget.eventsBloc.saveEvent(event);
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    } catch (e) {
      logger.warning('wtf');
    }
  }

  @override
  Widget build(BuildContext context) {
    buildCarousel();
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
                "photos de l'événement",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.5,
                    enableInfiniteScroll: false,
                    aspectRatio: 2,
                  ),
                  items: items,
                ),
              ),
            ],
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
                        initialValue: widget.event!.difficulty,
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
                          buildTitle('Prix :'),
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
                        title: 'Finir',
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
