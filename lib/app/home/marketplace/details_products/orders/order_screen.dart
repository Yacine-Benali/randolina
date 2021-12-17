import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/marketplace/details_products/orders/order_form1.dart';
import 'package:randolina/app/home/marketplace/details_products/orders/order_form2.dart';
import 'package:randolina/app/home/marketplace/details_products/orders/order_form3.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/models/order.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final PageController _pageController;
  late final ProductsBloc productsBloc;

  dynamic selectColor;
  dynamic selectSize;
  int quantity = 1;
  late String commentaire;

  @override
  void initState() {
    _pageController = PageController();
    final User user = context.read<User>();
    final Database database = context.read<Database>();
    productsBloc = ProductsBloc(
      database: database,
      currentUser: user,
    );

    super.initState();
  }

  void swipePage(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> orderNow() async {
    final Order order = Order(
      quantity: quantity,
      color: selectColor as String,
      size: selectSize as String,
      comment: commentaire,
    );

    await productsBloc.orderProduct(widget.product, order);
    Fluttertoast.showToast(
      msg: 'commande passée avec succès merci de vérifier vos messages privés',
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.hasClients) {
          if (_pageController.page == 0) {
            return true;
          } else {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blueGrey),
          title: Text(
            'Commande de produit',
            style: TextStyle(
              color: Color.fromRGBO(34, 50, 99, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            OrderForm1(
              product: widget.product,
              onNextPressed: ({
                required dynamic selectColor,
                required dynamic selectSize,
                required int quantity,
              }) {
                this.selectColor = selectColor;
                this.selectSize = selectSize;
                this.quantity = quantity;
                setState(() {});
                swipePage(1);
              },
            ),
            OrderForm2(
              onNextPressed: ({
                required String commentaire,
              }) {
                this.commentaire = commentaire;

                setState(() {});
                swipePage(2);
              },
            ),
            OrderForm3(orderNow: orderNow),
          ],
        ),
      ),
    );
  }
}
