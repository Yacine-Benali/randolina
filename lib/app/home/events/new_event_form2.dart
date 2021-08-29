import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
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
  }) : super(key: key);
  final EventsBloc eventsBloc;
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
  late Timestamp startDateTime;
  late Timestamp endDateTime;
  late int difficulty;
  late double marchingDistance;
  late String instructions;
  late int availableSeats;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  Future<void> onSave() async {
    if (images.isEmpty) {
      PlatformExceptionAlertDialog(
        exception: PlatformException(
          code: 'Error',
          message: 'pelase select at least one image',
        ),
      ).show(context);
    }

    final urls = await widget.eventsBloc.uploadEventImages(images);
    logger.severe(urls);
    if (_formKey.currentState!.validate()) {
      final Event event = Event(
        images: [''],
        profileImage: '',
        destination: destination,
        price: price,
        description: description,
        walkingDistance: walkingDistance,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        difficulty: difficulty,
        instructions: instructions,
        availableSeats: availableSeats,
      );
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

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
    } on Exception catch (e) {
      error = e.toString();
    }

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
            // todo show photo from previous form
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: SizeConfig.screenWidth,
                height: 200,
                color: Colors.red,
              ),
            ),
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
              textInputAction: TextInputAction.next,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                color: Colors.yellow[200],
                child: Center(child: Text('waiting for client confirmation')),
              ),
            ),
            EventDifficultyPicker(
              onChanged: (value) {
                difficulty = value;
              },
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
              title: 'Instruction :',
              hint: 'Text...',
              textInputAction: TextInputAction.next,
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
