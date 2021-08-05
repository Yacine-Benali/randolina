import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/feed/post_widget/content/post_image_loader.dart';
import 'package:randolina/app/home/feed/post_widget/content/post_video_loader.dart';
import 'package:randolina/constants/app_colors.dart';

class PostContentLoader extends StatefulWidget {
  const PostContentLoader({
    Key? key,
    required this.content,
    required this.type,
  }) : super(key: key);
  final List<String> content;
  final int type;

  @override
  _PostContentLoaderState createState() => _PostContentLoaderState();
}

class _PostContentLoaderState extends State<PostContentLoader> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late final List<Widget> children;

  @override
  void initState() {
    switch (widget.type) {
      case 0:
        children = widget.content
            .map((imageUrl) => PostImageLoader(image: imageUrl))
            .toList();
        break;
      case 1:
        children =
            widget.content.map((url) => PostVideoLoader(url: url)).toList();
        break;
      default:
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            items: children,
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
          children: widget.content.asMap().entries.map((entry) {
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
      ],
    );
  }
}
