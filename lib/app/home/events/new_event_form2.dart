import 'dart:io';

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
  }) : super(key: key);

  final File? profilePicture;
  final EventsBloc eventsBloc;
  final void Function({
    required Event event,
    required List<Asset> images,
  }) onNextPressed;
  @override
  _NewEventForm2State createState() => _NewEventForm2State();
}

class _NewEventForm2State extends State<NewEventForm2> {
  late final GlobalKey<FormState> _formKey;
  //
  List<Asset> images = <Asset>[];
  late String destination;
  late double price;
  late String description;
  late double walkingDistance;
  Timestamp? startDateTime;
  Timestamp? endDateTime;
  int difficulty = 1;
  late double marchingDistance;
  late String instructions;
  late int availableSeats;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  Future<void> onSave() async {
    if (_formKey.currentState!.validate()) {
      if (images.isEmpty) {
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

      final Event event = Event(
        images: [''],
        profileImage: '',
        destination: destination,
        price: price,
        description: description,
        walkingDistance: walkingDistance,
        startDateTime: startDateTime!,
        endDateTime: endDateTime!,
        difficulty: difficulty,
        instructions: instructions,
        availableSeats: availableSeats,
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  // todo low same button in form 1
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

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    late bool isClub;
    if (user is Club) {
      isClub = true;
    } else {
      isClub = false;
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (widget.profilePicture != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  height: 200,
                  child: Image.file(
                    widget.profilePicture!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
            buildUploadButton(),
            if (images.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(enableInfiniteScroll: false),
                  items: images.map((Asset asset) {
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
              ),
            ],
            EventField(
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
                price = double.parse(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a price';
                }
                // todo @high to be tested later
                if (isClub && price > 13000) {
                  return 'max price for clubs is 13000';
                }
              },
            ),
            EventField(
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
