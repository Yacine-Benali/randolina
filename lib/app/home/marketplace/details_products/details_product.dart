import 'package:flutter/material.dart';
import 'package:randolina/app/home/marketplace/details_products/orders/order_screen.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_screen.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/app/home/marketplace/widgets/product_detail_form.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/common_widgets/platform_alert_dialog.dart';
import 'package:randolina/constants/app_colors.dart';

class DetailsProduct extends StatefulWidget {
  const DetailsProduct({
    Key? key,
    required this.product,
    required this.productsBloc,
    required this.isStore,
  }) : super(key: key);

  final Product product;
  final ProductsBloc productsBloc;
  final bool isStore;
  @override
  _DetailsProductState createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  late bool isSaved = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteProduct() async {
    final bool? didRequestSignOut = await PlatformAlertDialog(
      title: 'Confirmer',
      content: 'Êtes-vous sûr de vouloir supprime ce produit ?',
      cancelActionText: 'annuler',
      defaultActionText: 'oui',
    ).show(context);
    if (didRequestSignOut == true) {
      widget.productsBloc.deleteProduct(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.isStore ? 'Modifier le produit' : 'Produit Info',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            if (widget.isStore)
              IconButton(
                onPressed: () {
                  deleteProduct().then((value) => Navigator.of(context).pop());
                },
                icon: Icon(Icons.delete),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProductDetailForm(product: widget.product),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NextButton(
                  onPressed: () {
                    if (widget.isStore) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(
                            product: widget.product,
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return OrderScreen(
                              product: widget.product,
                            );
                          },
                        ),
                      );
                    }
                  },
                  title: widget.isStore
                      ? 'Modifier le produit'
                      : 'Acheter ce produit',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
