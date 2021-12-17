import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/app/models/product.dart';

class OrderForm1 extends StatefulWidget {
  const OrderForm1({
    Key? key,
    required this.product,
    required this.onNextPressed,
  }) : super(key: key);

  final Product product;
  final void Function({
    required dynamic selectColor,
    required dynamic selectSize,
    required int quantity,
  }) onNextPressed;
  @override
  _OrderForm1State createState() => _OrderForm1State();
}

class _OrderForm1State extends State<OrderForm1> {
  final List<Widget> items = <Widget>[];
  final double thickness = 1;
  final Color color = Color.fromRGBO(51, 77, 115, 0.56);
  dynamic selectColor;
  dynamic selectSize;
  int quantity = 1;

  @override
  void initState() {
    selectColor = widget.product.colors[0] == Colors.white.withOpacity(0.001)
        ? Colors.white.withOpacity(0.001)
        : widget.product.colors[0];
    selectSize =
        widget.product.sizes[0] == 'empty' ? '1' : widget.product.sizes[0];

    super.initState();
  }

  Widget buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Color(0xFF223263),
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.5,
                    enableInfiniteScroll: false,
                    aspectRatio: 2,
                  ),
                  items: items,
                ),
              ),
            ],
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
                    ...[
                      Center(
                          child: buildTitle(
                              'La quantité que vous voulez acheter')),
                      Center(
                        child: Container(
                          width: 150,
                          height: 42,
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFEBF0FF),
                            ),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //   width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEBF0FF),
                                    border: Border.all(
                                      color: Color(0xFFEBF0FF),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      quantity.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 0.005,
                                        color: Color(0xff223263),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (widget.product.colors[0] != "1946157055")
                      SizedBox(height: 20),
                    if (widget.product.colors[0] != "1946157055")
                      Divider(
                        thickness: thickness,
                        color: color,
                        indent: 0,
                        endIndent: 0,
                      ),
                    if (widget.product.colors[0] != "1946157055")
                      SizedBox(height: 23),
                    ...[
                      if (widget.product.colors[0] != "1946157055")
                        Center(child: buildTitle('Sélectionner une couleur')),
                      if (widget.product.colors[0] != "1946157055")
                        SizedBox(
                          height: 55,
                          child: Align(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.colors.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectColor =
                                          widget.product.colors[index];
                                      print(
                                          'rani dit had la valeur $selectColor');
                                    });
                                  },
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(widget
                                          .product.colors[index]
                                          .toString())),
                                      shape: BoxShape.circle,
                                      // borderRadius: BorderRadius.circular(66),
                                      border: Border.all(
                                        color: Color(0xFFEBF0FF),
                                      ),
                                    ),
                                    child: selectColor ==
                                            widget.product.colors[index]
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                    if (widget.product.sizes[0] != 'empty')
                      SizedBox(height: 20),
                    if (widget.product.sizes[0] != 'empty')
                      Divider(
                        thickness: thickness,
                        color: color,
                        indent: 0,
                        endIndent: 0,
                      ),
                    SizedBox(height: 23),
                    ...[
                      if (widget.product.sizes[0] != 'empty')
                        Center(child: buildTitle('Sélectionner la Taille')),
                      if (widget.product.sizes[0] != 'empty')
                        SizedBox(
                          height: 55,
                          child: Align(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.product.sizes.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectSize =
                                            widget.product.sizes[index];
                                      });
                                    },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        //  borderRadius: BorderRadius.circular(66),
                                        shape: BoxShape.circle,
                                        border: selectSize ==
                                                widget.product.sizes[index]
                                            ? Border.all(
                                                color: Color(0xFF40BFFF),
                                              )
                                            : Border.all(
                                                color: Color(0xFFEBF0FF),
                                              ),
                                      ),
                                      child: Center(
                                        child: Text(widget.product.sizes[index]
                                            .toString()),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                    ],
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32.0, right: 8, left: 8),
                      child: NextButton(
                        title: 'Commandez le produit maintenant',
                        onPressed: () {
                          print('rani day had la valeur $selectColor');
                          print('rani day had la valeur $selectSize');
                          widget.onNextPressed(
                            selectColor: selectColor,
                            selectSize: selectSize,
                            quantity: quantity,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
