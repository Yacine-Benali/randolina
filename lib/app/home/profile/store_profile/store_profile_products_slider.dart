import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:randolina/app/home/marketplace/details_products/details_product.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/home/profile/store_profile/products_card_profile.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/miniuser_to_profile.dart';
import 'package:randolina/services/database.dart';

class StoreProfileProductsSlider extends StatefulWidget {
  const StoreProfileProductsSlider({
    Key? key,
    required this.profileBloc,
  }) : super(key: key);
  final ProfileBloc profileBloc;

  @override
  _StoreProfileProductsSliderState createState() =>
      _StoreProfileProductsSliderState();
}

class _StoreProfileProductsSliderState
    extends State<StoreProfileProductsSlider> {
  late final Stream<List<Product>> stream;
  late final ProductsBloc productsBloc;
  bool isStore = false;
  @override
  void initState() {
    final User currentUser = context.read<User>();
    final Database database = context.read<Database>();
    productsBloc = ProductsBloc(
      database: database,
      currentUser: currentUser,
    );
    if (context.read<User>() is Store) {
      isStore = true;
    } else {
      isStore = false;
    }
    super.initState();
  }

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
    return SizedBox(
      height: 200,
      child: StreamBuilder<List<Product>>(
        stream: widget.profileBloc.getStoreAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<Product> products = snapshot.data!;
            if (products.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (contex, index) {
                  return ProductsCardProfile(
                    product: products[index],
                    isStore: isStore,
                    bloc: productsBloc,
                  );
                },
              );
            } else {
              return EmptyContent(
                title: '',
                message: "ce store n'a pas de produits",
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: "Quelque chose s'est mal passé",
              message:
                  "Impossible de charger les éléments pour le moment\n ${snapshot.error.toString()}",
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
