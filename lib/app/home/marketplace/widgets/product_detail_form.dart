import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:randolina/app/models/product.dart';

import 'package:randolina/common_widgets/image_full_screen.dart';

class ProductDetailForm extends StatefulWidget {
  const ProductDetailForm({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  _ProductDetailFormState createState() => _ProductDetailFormState();
}

class _ProductDetailFormState extends State<ProductDetailForm> {
  final List<Widget> items = <Widget>[];

  Widget buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(34, 50, 99, 1),
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget buildProfilePicture() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
      child: ClipRect(
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.product.profileImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  void buildCarousel() {
    items.clear();

    for (final String url in widget.product.images) {
      final w = Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: CachedNetworkImage(
            imageBuilder: (_, imageProvider) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageFullScreen(
                        imageProvider: imageProvider,
                      ),
                    ),
                  );
                },
                child: Image(image: imageProvider, fit: BoxFit.contain),
              );
            },
            imageUrl: url,
          ),
        ),
      );
      items.add(w);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildCarousel();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildProfilePicture(),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "photos du product",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          if (items.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: 1,
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
                    buildTitle('Spesification :'),
                    Text(
                      widget.product.specification,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF223263),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  SizedBox(height: 22),
                  ...[
                    if (widget.product.colors.isNotEmpty)
                      buildTitle('Colors :'),
                    if (widget.product.colors.isNotEmpty)
                      SizedBox(
                        height: 55,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.colors.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 35,
                                  height: 35,
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
                                );
                              }),
                        ),
                      ),
                  ],
                  if (widget.product.sizes.isNotEmpty) SizedBox(height: 22),
                  ...[
                    if (widget.product.sizes.isNotEmpty) buildTitle('Sizes :'),
                    if (widget.product.sizes.isNotEmpty)
                      SizedBox(
                        height: 55,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.sizes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 35,
                                  height: 35,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    //  borderRadius: BorderRadius.circular(66),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFFEBF0FF),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                        widget.product.sizes[index].toString()),
                                  ),
                                );
                              }),
                        ),
                      ),
                  ],
                  SizedBox(height: 25),
                  ...[
                    buildTitle("The offer :"),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0, top: 8),
                      child: Text(
                        widget.product.offer,
                        style: TextStyle(
                          color: Color(0xFF223263),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  ...[
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTitle('Prix :'),
                        Text(
                          "${widget.product.price.toInt()} DA",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
