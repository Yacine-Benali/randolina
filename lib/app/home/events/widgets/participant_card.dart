import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/nested_screens/participant_detail_screen.dart';
import 'package:randolina/app/models/participant.dart';
import 'package:randolina/common_widgets/image_profile.dart';
import 'package:randolina/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class ParticipantCard extends StatefulWidget {
  const ParticipantCard({
    Key? key,
    required this.participant,
    required this.index,
    required this.onSelected,
    this.showInfo = true,
  }) : super(key: key);
  final Participant participant;
  final int index;
  final ValueChanged<bool> onSelected;
  final bool showInfo;

  @override
  _ParticipantCardState createState() => _ParticipantCardState();
}

class _ParticipantCardState extends State<ParticipantCard> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.participant.isConfirmed;
    super.initState();
  }

  Future<void> call() async {
    if (await canLaunch('tel:${widget.participant.client.phoneNumber}')) {
      await launch('tel:${widget.participant.client.phoneNumber}');
    } else {
      logger.severe('ERROR cant launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo @low will this look good on any device size ?
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF334D73).withOpacity(0.20),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: ImageProfile(
                url: widget.participant.client.profilePicture,
                height: 60,
                width: 60,
              ),
              title: AutoSizeText(
                widget.participant.client.name,
                maxLines: 1,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: GestureDetector(
                onTap: call,
                child: AutoSizeText(
                  widget.participant.client.phoneNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    //  fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              onTap: widget.showInfo
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ParticipantDetailScreen(
                            participant: widget.participant,
                            index: widget.index,
                          ),
                        ),
                      );
                    }
                  : call,
            ),
          ),
        ),
        if (widget.showInfo) ...[
          Checkbox(
            value: isSelected,
            onChanged: (t) {
              if (t != null) {
                setState(() {
                  isSelected = t;
                  widget.onSelected(t);
                });
              }
            },
          ),
        ],
        if (!widget.showInfo) ...[SizedBox(width: 50)],
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8),
          child: Material(
            elevation: 3,
            child: Container(
              height: 40,
              width: 40,
              color: Colors.white,
              child: Center(
                child: Text(
                  widget.index.toString().padLeft(2, '0'),
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
