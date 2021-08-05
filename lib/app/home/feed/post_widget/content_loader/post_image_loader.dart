import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randolina/constants/app_colors.dart';

class PostImageLoader extends StatefulWidget {
  const PostImageLoader({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;

  @override
  _PostImageLoaderState createState() => _PostImageLoaderState();
}

class _PostImageLoaderState extends State<PostImageLoader> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.image,
      imageBuilder: (context, imageProvider) => Container(
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
    );
  }
}
