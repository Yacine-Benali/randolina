import 'package:flutter/material.dart';
import 'package:randolina/app/base_screen.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderForm3 extends StatefulWidget {
  const OrderForm3({
    Key? key,
  }) : super(key: key);

  @override
  _OrderForm3State createState() => _OrderForm3State();
}

class _OrderForm3State extends State<OrderForm3> {
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
                    Text(
                        'Your order has been successfully registered. You will be contacted by the seller shortly.\n\n'),
                    Text(
                        'Or you can contact the seller directly to speed up the purchase process:\n\n\n'),
                    GestureDetector(
                      onTap: () {
                        launch("tel:+213792140427");
                      },
                      child: Center(
                        child: Container(
                          width: 194,
                          height: 62,
                          decoration: BoxDecoration(
                            color: Color(0xFF65E188),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                                color: Color.fromRGBO(61, 191, 255, 0.24),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Call the shop',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, right: 8, left: 8),
              child: NextButton(
                title: 'Confirme',
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return BaseScreen();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
