import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/profile_edit_pop_up.dart';
import 'package:randolina/common_widgets/size_config.dart';

class ClubTopHeader extends StatelessWidget {
  const ClubTopHeader({
    Key? key,
    required this.onEditPressed,
    required this.showProfileAsOther,
    required this.clubOrAgency,
    required this.onMoreInfoPressed,
  }) : super(key: key);
  final VoidCallback onEditPressed;
  final bool showProfileAsOther;
  final User clubOrAgency;
  final VoidCallback onMoreInfoPressed;
  @override
  Widget build(BuildContext context) {
    late String subtitle;
    if (clubOrAgency is Club) {
      subtitle = 'Club de Randonnée';
    } else if (clubOrAgency is Agency) {
      subtitle = 'Agence de Voyage';
    }
    //logger.info(SizeConfig.screenWidth - 180);
    late final double textRowWidth;
    if (showProfileAsOther) {
      textRowWidth = SizeConfig.screenWidth - 8 - 16 - 55 - 16;
    } else {
      textRowWidth = SizeConfig.blockSizeHorizontal * 77;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showProfileAsOther) ...[
                  SizedBox(
                    width: textRowWidth,
                    child: AutoSizeText(
                      clubOrAgency.name,
                      minFontSize: 22,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
                if (!showProfileAsOther) ...[
                  Row(
                    children: [
                      SizedBox(
                        width: textRowWidth,
                        child: Text(
                          clubOrAgency.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      ProfileEditPopUp(
                        onEditPressed: onEditPressed,
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF40A3DB),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!showProfileAsOther) ...[
            // SizedBox(
            //   child: Icon(
            //     Icons.turned_in_not,
            //     size: 30,
            //   ),
            // ),
          ],
        ],
      ),
    );
  }
}
