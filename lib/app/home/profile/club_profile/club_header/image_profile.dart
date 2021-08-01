import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/user.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();

    return Positioned(
      left: 18,
      bottom: 6,
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 5,
                color: Color(0xFFE5E5E5),
              ),
              borderRadius: BorderRadius.circular(70),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(1, 3),
                  color: Color(0xFF334D73).withOpacity(0.20),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: user.profilePicture,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
