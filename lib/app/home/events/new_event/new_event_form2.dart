import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/widgets/event_date_picker.dart';
import 'package:randolina/app/home/events/widgets/event_difficulty_picker.dart';
import 'package:randolina/app/home/events/widgets/event_field.dart';
import 'package:randolina/app/home/events/widgets/next_button.dart';
import 'package:randolina/app/home_admin/sites/site.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/utils/logger.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class NewEventForm2 extends StatefulWidget {
  const NewEventForm2({
    Key? key,
    required this.eventsBloc,
    required this.onNextPressed,
    required this.profilePicture,
    required this.sites,
    this.event,
  }) : super(key: key);

  final File? profilePicture;
  final EventsBloc eventsBloc;
  final Event? event;
  final List<Site> sites;
  final void Function({
    required Event event,
    required List<File> images,
  }) onNextPressed;
  @override
  _NewEventForm2State createState() => _NewEventForm2State();
}

class _NewEventForm2State extends State<NewEventForm2> {
  late final GlobalKey<FormState> _formKey;
  late bool isClub;
  final List<Widget> items = <Widget>[];

  //
  List<File> images = <File>[];
  String? destination;
  int? price;
  String? description;
  double? walkingDistance;
  Timestamp? startDateTime;
  Timestamp? endDateTime;
  int? difficulty = 1;
  String? instructions;
  int? availableSeats;
  final TextEditingController _typeAheadController = TextEditingController();
  Site? selectedSite;
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
            code: 'Erreur',
            message: 'veuillez sélectionner au moins une image',
          ),
        ).show(context);
        return;
      }
      if (startDateTime == null || endDateTime == null) {
        PlatformExceptionAlertDialog(
          exception: PlatformException(
            code: 'Erreur',
            message: 'veuillez sélectionner la date de début et de fin',
          ),
        ).show(context);
        return;
      }
      final User user = context.read<User>();
      late int createdByType;
      late int wilaya;
      if (user is Club) {
        createdByType = 1;
        wilaya = user.wilaya;
      } else if (context.read<User>() is Agency) {
        createdByType = 2;
        wilaya = user.wilaya;
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
        subscribers: widget.event?.subscribers ?? [],
        subscribersLength: 0,
        createdAt: Timestamp.now(),
        wilaya: wilaya,
        site: selectedSite,
      );
      widget.onNextPressed(
        event: event,
        images: images,
      );
    }
  }

  Future<void> loadAssets() async {
    List<AssetEntity>? resultList = <AssetEntity>[];

    final List<String> imagesPathsList = [];
    try {
      resultList = await AssetPicker.pickAssets(
        context,
        textDelegate: EnglishTextDelegate(),
        maxAssets: 5,
        selectedAssets: resultList,
        themeColor: Colors.blue,
      );
      if (resultList == null) return;

      for (final AssetEntity asset in resultList) {
        final File? file = await asset.file;
        if (file != null) imagesPathsList.add(file.path);
      }
      if (imagesPathsList.isNotEmpty) {
        final List<File> finalFiles = [];
        for (final String imagePath in imagesPathsList) {
          final File? croppedImage = await ImageCropper.cropImage(
            androidUiSettings: AndroidUiSettings(
              backgroundColor: Colors.black,
              toolbarColor: Colors.white,
              toolbarWidgetColor: Colors.black,
              toolbarTitle: 'Recadrer la photo',
              activeControlsWidgetColor: Colors.blue,
            ),
            sourcePath: imagePath,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          );

          if (croppedImage != null) {
            finalFiles.add(croppedImage);
            logger.info('edited images ${croppedImage.path}');
          }
        }
        if (finalFiles.length == imagesPathsList.length) {
          setState(() {
            images = finalFiles;
          });
        }
      }
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    }
  }

  // TODO @low same button in form 1
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
              'Ajouter des photos',
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
      for (final File file in images) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              Image.file(
                file,
                fit: BoxFit.contain,
                height: SizeConfig.blockSizeVertical * 102,
                width: SizeConfig.blockSizeVertical * 102,
              ),
              IconButton(
                onPressed: () {
                  images.remove(file);
                  setState(() {});
                },
                icon: Icon(Icons.cancel, color: Colors.grey),
              ),
            ],
          ),
        );
        items.add(w);
      }
    }
    if (widget.event != null) {
      for (final String url in widget.event!.images) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  height: SizeConfig.blockSizeVertical * 102,
                  width: SizeConfig.blockSizeVertical * 102,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.event!.images.remove(url);
                  setState(() {});
                },
                icon: Icon(Icons.cancel, color: Colors.grey),
              ),
            ],
          ),
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
                  options: CarouselOptions(
                    viewportFraction: 0.5,
                    enableInfiniteScroll: false,
                    aspectRatio: 2,
                  ),
                  items: items,
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Localisation: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(34, 50, 99, 1),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 20),
                    child: Material(
                      type: MaterialType.button,
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      elevation: 5.0,
                      child: TypeAheadFormField<Site>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAheadController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 20),
                            counterText: '',
                            border: InputBorder.none,
                            hintText: 'CapoRoussou...',
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return widget.eventsBloc
                              .getSitesSuggestion(widget.sites, pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return Material(
                            type: MaterialType.button,
                            color: Colors.white,
                            elevation: 5.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10.0, 20.0, 10, 20),
                              child: Text(suggestion.title),
                            ),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          _typeAheadController.text = suggestion.title;
                          selectedSite = suggestion;
                        },
                        validator: (value) {
                          if (value == null || value == '') {
                          } else if (!widget.sites
                              .map((e) => e.title)
                              .contains(value)) {
                            return "cette localisation n'existe pas";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  return 'veuillez entrer le nom de la destination';
                }
              },
            ),
            EventField(
              initialValue: price != null ? '$price' : null,
              title: 'Prix :',
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
                  return 'veuillez entrer un prix';
                }
                if (int.tryParse(value) == null) {
                  return 'format incorrect';
                }
                if (isClub && int.parse(value) > 13000) {
                  return 'le prix maximum pour les clubs est 13000';
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
                  return 'veuillez entrer la description';
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
              hintText: "sélectionner la date et l'heure",
            ),
            EventDatePicker(
              title: "date et heure de d'arriver",
              selectedDate: endDateTime,
              onSelectedDate: (t) {
                endDateTime = t;
                setState(() {});
              },
              hintText: "sélectionner la date et l'heure",
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
                      return 'veuillez entrer la distance en km';
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
                  return 'veuillez entrer les instructions';
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
                      return 'veuillez entrer le nombre de places disponibles';
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
