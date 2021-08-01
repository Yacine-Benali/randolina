import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/user.dart';

// ignore: must_be_immutable
class ImageProfileHeader extends StatelessWidget {
  bool isExpanded;
  ImageProfileHeader({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    return Positioned(
      bottom: isExpanded ? (58 + 30) : (42 + 30),
      left: 16,
      child: Container(
        width: 95,
        height: 95,
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
          imageUrl: user.profilePicture,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
