import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/widgets/product_card.dart';
import 'package:randolina/app/home/profile/profile_bloc.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class SeeAllProductsStore extends StatefulWidget {
  const SeeAllProductsStore({
    Key? key,
    required this.profileBloc,
    required this.store,
  }) : super(key: key);
  final ProfileBloc profileBloc;
  final User store;

  @override
  _SeeAllProductsStoreState createState() => _SeeAllProductsStoreState();
}

class _SeeAllProductsStoreState extends State<SeeAllProductsStore> {
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
        child: StreamBuilder<List<Product>>(
          stream: widget.profileBloc.getStoreAllProducts(widget.store.id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final List<Product> products = snapshot.data!;
              if (products.isNotEmpty) {
                return GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 10,
                    childAspectRatio: itemWidth / itemHeight,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(
                      key: Key(products[index].id),
                      product: products[index],
                      productsBloc: productsBloc,
                      isStore: isStore,
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
      ),
    );
  }
}
