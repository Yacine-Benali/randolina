import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/event_date_picker.dart';
import 'package:randolina/app/home/events/widgets/event_difficulty_picker.dart';
import 'package:randolina/app/home/events/widgets/event_field.dart';
import 'package:randolina/app/home/events/widgets/next_button.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/utils/logger.dart';

class NewEventForm2 extends StatefulWidget {
  const NewEventForm2({
    Key? key,
    required this.eventsBloc,
    required this.onNextPressed,
    required this.profilePicture,
    this.event,
  }) : super(key: key);

  final File? profilePicture;
  final EventsBloc eventsBloc;
  final Event? event;
  final void Function({
    required Event event,
    required List<Asset> images,
  }) onNextPressed;
  @override
  _NewEventForm2State createState() => _NewEventForm2State();
}

class _NewEventForm2State extends State<NewEventForm2> {
  late final GlobalKey<FormState> _formKey;
  late bool isClub;
  final List<Widget> items = <Widget>[];

  //
  List<Asset> images = <Asset>[];
  String? destination;
  int? price;
  String? description;
  double? walkingDistance;
  Timestamp? startDateTime;
  Timestamp? endDateTime;
  int? difficulty = 1;
  String? instructions;
  int? availableSeats;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    final User user = context.read<User>();

    if (user is Club) {
      isClub = true;
    } else {
      isClub = false;
    }
    if (widget.event != null) {
      destination = widget.event!.destination;
      price = widget.event!.price;
      description = widget.event!.description;
      walkingDistance = widget.event!.walkingDistance;
      startDateTime = widget.event!.startDateTime;
      endDateTime = widget.event!.endDateTime;
      difficulty = widget.event!.difficulty;
      walkingDistance = widget.event!.walkingDistance;
      instructions = widget.event!.instructions;
      availableSeats = widget.event!.availableSeats;
    }

    super.initState();
  }

  Future<void> onSave() async {
    if (_formKey.currentState!.validate()) {
      if (images.isEmpty && (widget.event?.images.isEmpty ?? true)) {
        PlatformExceptionAlertDialog(
          exception: PlatformException(
            code: 'Error',
            message: 'pelase select at least one image',
          ),
        ).show(context);
        return;
      }
      if (startDateTime == null || endDateTime == null) {
        PlatformExceptionAlertDialog(
          exception: PlatformException(
            code: 'Error',
            message: 'pelase select start and end date',
          ),
        ).show(context);
        return;
      }
      late int createdByType;
      if (context.read<User>() is Club) {
        createdByType = 1;
      } else if (context.read<User>() is Agency) {
        createdByType = 2;
      } else {
        throw PlatformException(code: 'INSUFFICIENT_PERMISSION');
      }

      final Event event = Event(
        id: widget.event?.id ?? '',
        images: widget.event?.images ?? [],
        profileImage: widget.event?.profileImage ?? '',
        destination: destination!,
        price: price!,
        description: description!,
        walkingDistance: walkingDistance!,
        startDateTime: startDateTime!,
        endDateTime: endDateTime!,
        difficulty: difficulty!,
        instructions: instructions!,
        availableSeats: availableSeats!,
        createdBy: context.read<User>().toMiniUser(),
        createdByType: createdByType,
        subscribers: [],
        subscribersLength: 0,
        createdAt: Timestamp.now(),
      );
      widget.onNextPressed(
        event: event,
        images: images,
      );
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#679cdb",
          lightStatusBar: true,
          statusBarColor: "#ffffff",
          actionBarTitle: "",
          allViewTitle: "",
          useDetailsView: false,
          selectCircleStrokeColor: "#ffffff",
        ),
      );
      // ignore: empty_catches
    } on Exception {}
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  // todo @low same button in form 1
  Widget buildUploadButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () async {
          loadAssets();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          minimumSize: MaterialStateProperty.all(Size(200, 70)),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add pictures',
              style: TextStyle(
                color: Color.fromRGBO(51, 77, 115, 0.88),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Icon(
                Icons.add,
                color: Color.fromRGBO(51, 77, 115, 0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePicture() {
    if (widget.profilePicture != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: 200,
          child: Image.file(
            widget.profilePicture!,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (widget.event != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: 200,
          child: CachedNetworkImage(
            imageUrl: widget.event!.profileImage,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void buildCarousel() {
    items.clear();
    if (images.isNotEmpty) {
      for (final Asset asset in images) {
        if (asset.originalWidth == null || asset.originalHeight == null) {
          logger.severe('null height or width ');
        }

        final w = Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AssetThumb(
                asset: asset,
                width: asset.originalWidth ?? 300,
                height: asset.originalHeight ?? 300,
              ),
            ),
            IconButton(
              onPressed: () {
                images.remove(asset);
                setState(() {});
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        );
        items.add(w);
      }
    }
    if (widget.event != null) {
      for (final String url in widget.event!.images) {
        final w = Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CachedNetworkImage(imageUrl: url),
            ),
            IconButton(
              onPressed: () {
                widget.event!.images.remove(url);
                setState(() {});
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        );
        items.add(w);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    buildCarousel();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildProfilePicture(),
            buildUploadButton(),
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(enableInfiniteScroll: false),
                  items: items,
                ),
              ),
            ],
            EventField(
              initialValue: destination,
              title: 'Desination :',
              hint: 'Tikijda...',
              maxLength: 20,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                destination = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter the name of the destination';
                }
              },
            ),
            EventField(
              initialValue: price != null ? '$price' : null,
              title: 'Price :',
              hint: 'Prix...',
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
              suffix: SizedBox(
                width: 50,
                height: 20,
                child: Row(
                  children: [
                    VerticalDivider(color: Colors.black),
                    Text(
                      'DA',
                      style: TextStyle(
                        color: Color.fromRGBO(34, 50, 99, 0.69),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                price = int.parse(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a price';
                }
                if (int.tryParse(value) == null) {
                  return 'incorrect format';
                }
                if (isClub && int.parse(value) > 13000) {
                  return 'max price for clubs is 13000';
                }
              },
            ),
            EventField(
              initialValue: description,
              title: 'Description :',
              hint: 'Text...',
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
              lines: 5,
              onChanged: (value) {
                description = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter the description';
                }
              },
            ),
            EventDatePicker(
              title: 'date et heure de départ',
              selectedDate: startDateTime,
              onSelectedDate: (t) {
                startDateTime = t;
                setState(() {});
              },
              hintText: 'select date and time',
            ),
            EventDatePicker(
              title: "date et heure de d'arriver",
              selectedDate: endDateTime,
              onSelectedDate: (t) {
                endDateTime = t;
                setState(() {});
              },
              hintText: 'select date and time',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: EventDifficultyPicker(
                initialValue: difficulty,
                onChanged: (value) {
                  difficulty = value;
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: SizeConfig.blockSizeHorizontal * 70,
                child: EventField(
                  initialValue:
                      walkingDistance != null ? '$walkingDistance' : null,
                  title: 'Distance de marche :',
                  hint: 'exmpl 80km...',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    walkingDistance = double.parse(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter the distance in km';
                    }
                  },
                ),
              ),
            ),
            EventField(
              initialValue: instructions,
              title: 'Instructions :',
              hint: 'Text...',
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
              lines: 5,
              onChanged: (value) {
                instructions = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter the instructions';
                }
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: SizeConfig.blockSizeHorizontal * 70,
                child: EventField(
                  initialValue:
                      availableSeats != null ? '$availableSeats' : null,
                  title: 'Nombres des places :',
                  hint: 'exmpl 30,45,60...',
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    availableSeats = int.parse(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter number of available seats';
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, right: 8, left: 8),
              child: NextButton(
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
