import 'package:flutter/material.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';

class OrderForm2 extends StatefulWidget {
  const OrderForm2({
    Key? key,
    required this.onNextPressed,
  }) : super(key: key);
  final void Function({
    required String commentaire,
  }) onNextPressed;
  @override
  _OrderForm2State createState() => _OrderForm2State();
}

class _OrderForm2State extends State<OrderForm2> {
  String commentaire = 'Commentaire vide';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              elevation: 5.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                        hintText: 'Leave a comment with your order...',
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        if (value!.trim().isNotEmpty) {
                          commentaire = value.trim();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, right: 8, left: 8),
              child: NextButton(
                title: 'Finish',
                onPressed: () {
                  widget.onNextPressed(
                    commentaire: commentaire,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
