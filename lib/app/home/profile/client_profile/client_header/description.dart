import 'package:flutter/material.dart';
import 'package:randolina/app/models/client.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/utils/logger.dart';
import 'package:readmore/readmore.dart';

class Description extends StatelessWidget {
  const Description({
    Key? key,
    required this.onExpanded,
    required this.isExpanded,
    required this.client,
  }) : super(key: key);
  final ValueChanged<bool> onExpanded;
  final bool isExpanded;
  final Client client;

  @override
  Widget build(BuildContext context) {
    // logger.warning('rebuild description widget');
    // logger.severe('update');
    // context.read<User>();
    final String v = client.bio ?? '';
    logger.severe(v);

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
          v,
          key: UniqueKey(),
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
