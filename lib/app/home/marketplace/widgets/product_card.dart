import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/marketplace/details_products/details_product.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/models/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.productsBloc,
    required this.isStore,
  }) : super(key: key);

  final Product product;
  final ProductsBloc productsBloc;
  final bool isStore;
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Widget buildBottomPart(double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, right: 2, left: 2),
      child: Banner(
        location: BannerLocation.bottomStart,
        message: "${price.toInt()} DA",
        color: Colors.white.withOpacity(0.5),
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DetailsProduct(
                  product: widget.product,
                  productsBloc: widget.productsBloc,
                  isStore: widget.isStore);
            },
          ),
        );
      },
      child: Container(
        width: 153,
        height: 192,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              widget.product.profileImage,
            ),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFFC4C4C4),
            ],
            stops: [0.0, 0.2],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(51, 77, 115, 0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.product.createdBy.profilePicture),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      widget.product.createdBy.username,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: buildBottomPart(
                widget.product.price.toDouble(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
