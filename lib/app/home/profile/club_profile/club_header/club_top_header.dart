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
    late double textRowWidth;
    if (showProfileAsOther) {
      textRowWidth = SizeConfig.screenWidth - 8 - 55 - 16;
    } else {
      textRowWidth = 300;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (showProfileAsOther) ...[
            // IconButton(
            //   padding: EdgeInsets.zero,
            //   icon: Icon(
            //     Icons.arrow_back,
            //     color: Colors.black87,
            //     size: 30,
            //   ),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
          ],
          Padding(
            padding:
                EdgeInsets.only(left: showProfileAsOther == true ? 0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: textRowWidth,
                  child: Row(
                    children: [
                      if (showProfileAsOther) ...[
                        Expanded(
                          child: Row(
                            children: [
                              AutoSizeText(
                                clubOrAgency.name,
                                minFontSize: 22,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!showProfileAsOther) ...[
                        Expanded(
                          child: Row(
                            children: [
                              AutoSizeText(
                                clubOrAgency.name,
                                minFontSize: 22,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              ProfileEditPopUp(
                                onEditPressed: onEditPressed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
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
            ),
          ),
          if (!showProfileAsOther) ...[
            SizedBox(
              child: Icon(
                Icons.turned_in_not,
                size: 30,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
