import 'package:flutter/material.dart';
import 'package:randolina/app/home/events/widgets/participant_card.dart';
import 'package:randolina/app/home/profile/profile_screen.dart';
import 'package:randolina/app/models/participant.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/utils.dart';

class ParticipantDetailScreen extends StatefulWidget {
  const ParticipantDetailScreen({
    Key? key,
    required this.participant,
    required this.index,
  }) : super(key: key);

  final Participant participant;
  final int index;

  @override
  _ParticipantDetailScreenState createState() =>
      _ParticipantDetailScreenState();
}

class _ParticipantDetailScreenState extends State<ParticipantDetailScreen> {
  Widget buildText(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF334D73).withOpacity(0.20),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Particiapnt Info',
            style: TextStyle(
              color: Color.fromRGBO(51, 77, 115, 0.7),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: backgroundColor,
        child: Column(
          children: [
            buildAppBar(),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ParticipantCard(
                showInfo: false,
                participant: widget.participant,
                index: widget.index,
                onSelected: (t) {},
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 45, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildText("nom : ", widget.participant.client.name),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: buildText(
                          'date de naissance: ',
                          particpantDateFormmater(
                              widget.participant.client.dateOfBirth),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: buildText('Wilaya: ', 'Oran'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 32),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (contxt) => ProfileScreen(
                                  user: widget.participant.client,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'visit profile',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
