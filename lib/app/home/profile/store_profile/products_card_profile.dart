import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:randolina/app/home/marketplace/details_products/details_product.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/miniuser_to_profile.dart';
import 'package:provider/provider.dart';

class ProductsCardProfile extends StatefulWidget {
  final Product product;
  final bool isStore;
  final ProductsBloc bloc;
  const ProductsCardProfile({
    Key? key,
    required this.product,
    required this.isStore,
    required this.bloc,
  }) : super(key: key);
  @override
  _ProductsCardProfileState createState() => _ProductsCardProfileState();
}

class _ProductsCardProfileState extends State<ProductsCardProfile> {
  Widget buildBottomPart(double price) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17,
        right: 2,
      ),
      child: Container(
        width: 102,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(51, 77, 115, 0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rest) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF05090B),
                Color(0xFF567181).withOpacity(0.6),
              ],
            ).createShader(rest),
            child: AutoSizeText(
              "$price DA",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'LondrinaSolid-Regular',
                fontWeight: FontWeight.w800,
                //  color: Color(0xFF05090B),
                letterSpacing: -0.33,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
                productsBloc: widget.bloc,
                isStore: widget.isStore,
              );
            },
          ),
        );
      },
      child: Container(
        width: 230,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              widget.product.profileImage,
            ),
            fit: BoxFit.cover,
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000000),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
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
                    //      flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        if (context.read<User>().id !=
                            widget.product.createdBy.id) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MiniuserToProfile(
                                miniUser: widget.product.createdBy,
                              ),
                            ),
                          );
                        }
                      },
                      child: AutoSizeText(
                        widget.product.createdBy.username,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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