import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_screen.dart';
import 'package:randolina/app/home/marketplace/widgets/product_card.dart';
import 'package:randolina/app/home/marketplace/widgets/products_search.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/store.dart';
import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({Key? key}) : super(key: key);

  @override
  _MarketPlaceScreenState createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextStyle textstyle;
  late int tabIndex;
  late final bool isStores;
  final RefreshController _refreshController = RefreshController();
  late ValueNotifier<List<Product>> currentlyChosenProductsNotifier;
  late final Stream<List<Product>> allProductsStream;
  Stream<List<Product>>? myProductsStream;
  late final ProductsBloc productsBloc;
  late final AuthUser authUser;
  String searchText = '';
  late List<Product> products;
  late Stream<Subscription?> subscriptionStream;

  @override
  void initState() {
    products = [];
    currentlyChosenProductsNotifier = ValueNotifier([]);

    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => setState(() {}));
    textstyle = TextStyle(
      color: darkBlue,
      fontWeight: FontWeight.w800,
    );
    final User currentUser = context.read<User>();
    final Database database = context.read<Database>();
    productsBloc = ProductsBloc(
      database: database,
      currentUser: currentUser,
    );
    subscriptionStream =
        productsBloc.getClubSubscription(context.read<User>().id);
    if (context.read<User>() is Store) {
      isStores = true;
      myProductsStream = productsBloc.getMyProducts();
      allProductsStream = productsBloc.getAllProducts();
    } else {
      isStores = false;
      allProductsStream = productsBloc.getAllProducts();
    }
    super.initState();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Widget buildProducts({required bool isStore}) {
    final size = MediaQuery.of(context).size;
    print('gdliherpghreohgo ${size.height}');
    /*24 is for notification bar on Android*/
    double itemHeight;
    if (size.height <= 600) {
      itemHeight = (size.height - kToolbarHeight - 24) / 2.3;
    } else if (size.height <= 800) {
      itemHeight = (size.height - kToolbarHeight - 24) / 2.68;
    } else {
      itemHeight = (size.height - kToolbarHeight - 24) / 3;
    }
    final double itemWidth = size.width / 2;
    return SingleChildScrollView(
      // height: SizeConfig.screenHeight,
      padding: EdgeInsets.all(8),
      child: StreamBuilder<List<Product>>(
        stream: isStore ? myProductsStream : allProductsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            products = snapshot.data!;
            if (products.isNotEmpty) {
              final List<Product> matchedProducts =
                  productsBloc.productsTextSearch(
                products,
                searchText,
              );
              Future.delayed(Duration(milliseconds: 500)).then((value) =>
                  currentlyChosenProductsNotifier.value = matchedProducts);
              return GridView.builder(
                itemCount: matchedProducts.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 10,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProductCard(
                    key: Key(products[index].id),
                    product: matchedProducts[index],
                    productsBloc: productsBloc,
                    isStore:
                        products[index].createdBy.id == context.read<User>().id,
                  );
                },
              );
            } else {
              return EmptyContent(
                title: '',
                message: "Vous n'avez aucun Product",
              );
            }
          } else if (snapshot.hasError) {
            logger.severe(snapshot.error);
            return EmptyContent(
              title: "Quelque chose s'est mal passé",
              message:
                  "Impossible de charger les éléments pour le moment\n ${snapshot.error.toString()}",
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            ChangeNotifierProvider.value(
              value: currentlyChosenProductsNotifier,
              child: ProductsSearch(
                bloc: productsBloc,
                onTextChanged: (t) {
                  setState(() => searchText = t);
                },
              ),
            ),
            if (isStores)
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: SizedBox(
                  height: 30,
                  child: Material(
                    color: Colors.grey[300],
                    elevation: 5,
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: textstyle,
                      labelPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                      ),
                      labelColor: Color.fromRGBO(51, 77, 115, 0.78),
                      unselectedLabelColor: Color.fromRGBO(51, 77, 115, 0.78),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.storefront),
                        ),
                        Tab(
                          icon: Icon(Icons.store),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (!isStores)
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.7],
                      colors: [
                        Color.fromRGBO(141, 182, 248, 0.51),
                        Color(0xFF446686).withOpacity(0.98),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 4),
                        color: Color.fromRGBO(51, 77, 115, 0.25),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset('assets/Rectangle 104.png'),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          child: AutoSizeText(
                            'Marketplace',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 35,
                              letterSpacing: -0.33,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 10),
                          child: AutoSizeText(
                            'Hiking & travels',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 21,
                              letterSpacing: -0.33,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isStores) ...[SizedBox(height: 15)],
            if (isStores && _tabController.index == 1) ...[
              StreamBuilder<Subscription?>(
                  stream: subscriptionStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final Subscription subscription = snapshot.data!;

                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 8.0, right: 8, left: 8),
                        child: ElevatedButton(
                          onPressed: () async {
                            final bool isActive =
                                productsBloc.isSubscriptionActive(subscription);

                            if (isActive) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddProductScreen(),
                                ),
                              );
                            } else {
                              PlatformAlertDialog(
                                content:
                                    "votre compte n'est pas actif veuillez contacter l'administrateur",
                                title: 'Erreur',
                              ).show(context);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ajouter',
                                style: TextStyle(
                                    color: Color.fromRGBO(51, 77, 115, 0.78)),
                              ),
                              Icon(Icons.add,
                                  color: Color.fromRGBO(51, 77, 115, 0.78))
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      logger.severe(snapshot);
                      return EmptyContent(
                        title: "Quelque chose s'est mal passé",
                        message:
                            "Impossible de charger les éléments pour le moment\n ${snapshot.error.toString()}",
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
            if (_tabController.index == 1) ...[buildProducts(isStore: true)],
            if (_tabController.index == 0) ...[
              SizedBox(height: 20),
              buildProducts(isStore: false)
            ],
          ],
        ),
      ),
    );
  }
}
