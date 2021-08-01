import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:readmore/readmore.dart';

class Description extends StatelessWidget {
  const Description({
    Key? key,
    required this.onExpanded,
    required this.isExpanded,
  }) : super(key: key);
  final ValueChanged<bool> onExpanded;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final User user = context.read<User>();
    return Container(
      height: isExpanded ? 115 : 87,
      width: SizeConfig.screenWidth,
      margin: const EdgeInsets.only(left: 60),
      padding: const EdgeInsets.only(
        top: 15,
        left: 60,
        right: 10,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(37),
          bottomRight: Radius.circular(37),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.20),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: ReadMoreText(
          user.bio ?? '',
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' More',
          trimExpandedText: 'less',
          callback: (value) {
            onExpanded(!value);
          },
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.87),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
