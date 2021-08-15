import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageProfile extends StatelessWidget {
  const ImageProfile({
    required this.url,
    this.height = 95,
    this.width = 95,
  });
  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(47),
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.43),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
