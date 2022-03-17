import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/widgets/product_card.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class FilteredProducts extends StatefulWidget {
  const FilteredProducts({
    Key? key,
    required this.products,
  }) : super(key: key);
  final List<Product> products;

  @override
  _FilteredProductsState createState() => _FilteredProductsState();
}

class _FilteredProductsState extends State<FilteredProducts> {
  late final ProductsBloc productsBloc;
  bool isStore = false;
  late bool isEmpty;

  @override
  void initState() {
    isEmpty = widget.products.isEmpty;

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
        width: 152,
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
    final size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tous les Produits',
          style: TextStyle(
            color: Color(0xFF223263),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF9098B1),
          ),
        ),
      ),
      body: Container(
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.all(7),
        child: isEmpty
            ? EmptyContent(
                title: '',
                message: "aucun produit ne correspond à ce filtre",
              )
            : GridView.builder(
                itemCount: widget.products.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 10,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProductCard(
                    key: Key(widget.products[index].id),
                    product: widget.products[index],
                    productsBloc: productsBloc,
                    isStore: widget.products[index].createdBy.id == context.read<User>().id,
                  );
                },
              ),
      ),
    );
  }
}
