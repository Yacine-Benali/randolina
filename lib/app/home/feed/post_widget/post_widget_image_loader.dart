import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:randolina/constants/app_colors.dart';

class PostWidgetImageLoader extends StatefulWidget {
  const PostWidgetImageLoader({
    Key? key,
    required this.imageList,
  }) : super(key: key);
  final List<String> imageList;

  @override
  _PostWidgetImageLoaderState createState() => _PostWidgetImageLoaderState();
}

class _PostWidgetImageLoaderState extends State<PostWidgetImageLoader> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late final List<Widget> imageSliders;

  @override
  void initState() {
    imageSliders = widget.imageList
        .map(
          (item) => CachedNetworkImage(
            imageUrl: item,
            imageBuilder: (context, imageProvider) => Container(
              margin: const EdgeInsets.only(left: 7, right: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: CircularProgressIndicator(
                  color: darkBlue,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imageList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : darkBlue)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
