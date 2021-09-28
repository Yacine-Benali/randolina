import 'package:blur/blur.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/widgets/event_difficulty_picker.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/common_widgets/image_full_screen.dart';
import 'package:randolina/utils/utils.dart';

class EventsDetailForm extends StatefulWidget {
  const EventsDetailForm({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  @override
  _EventsDetailFormState createState() => _EventsDetailFormState();
}

class _EventsDetailFormState extends State<EventsDetailForm> {
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
          ),
          //textDirection: TextDirection.ltr,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.event.profileImage),
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
    );
  }

  void buildCarousel() {
    items.clear();

    for (final String url in widget.event.images) {
      final w = Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: CachedNetworkImage(
            imageBuilder: (_, imageProvider) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageFullScreen(
                        imageProvider: imageProvider,
                      ),
                    ),
                  );
                },
                child: Image(image: imageProvider, fit: BoxFit.contain),
              );
            },
            imageUrl: url,
          ),
        ),
      );
      items.add(w);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildCarousel();
    return Padding(
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
          if (items.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: 1,
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
                      widget.event.description,
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
                        eventDateFormat(widget.event.startDateTime.toDate()),
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
                        eventDateFormat(widget.event.endDateTime.toDate()),
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
                      initialValue: widget.event.difficulty,
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
                        '${widget.event.walkingDistance} KM',
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
                      widget.event.instructions,
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
                          "${widget.event.price.toInt()} DA",
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
