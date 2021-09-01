import 'package:flutter/material.dart';
import 'package:randolina/app/models/participant.dart';
import 'package:randolina/common_widgets/image_profile.dart';

class ParticipantCard extends StatefulWidget {
  const ParticipantCard({
    Key? key,
    required this.participant,
    required this.index,
  }) : super(key: key);
  final Participant participant;
  final int index;

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

  @override
  Widget build(BuildContext context) {
    // todo will this look good on any device size ?
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(width: 60 / 2),
                  Expanded(
                    child: Container(
                      height: 60,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: Text(
                                    widget.participant.client.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 70.0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      widget.participant.client.phoneNumber,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.info_outline, size: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ImageProfile(
                url: widget.participant.client.profilePicture,
                height: 60,
                width: 60,
              ),
            ],
          ),
        ),
        Checkbox(
          value: isSelected,
          onChanged: (t) {
            if (t != null) {
              setState(() {
                isSelected = t;
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
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
