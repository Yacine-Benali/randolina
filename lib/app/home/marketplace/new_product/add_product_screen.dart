import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_form1.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_form2.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_form3.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_form4.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    Key? key,
    this.product,
  }) : super(key: key);
  final Product? product;
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final ProductsBloc productsBloc;
  late final PageController _pageController;

  Product? product;
  File? profilePicture;
  List<File>? images;
  List<dynamic>? sizes = [];
  List<dynamic>? colors = [];

  @override
  void initState() {
    _pageController = PageController();
    final AuthUser auth = context.read<AuthUser>();
    final Database database = context.read<Database>();
    productsBloc = ProductsBloc(
      database: database,
      authUser: auth,
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
            widget.product == null ? 'add an product' : 'edit product',
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
            AddProductForm1(
              profilePicture: widget.product?.profileImage,
              onPictureChanged: (File? value) async {
                profilePicture = value;
                setState(() {});
                swipePage(1);
              },
            ),
            AddProductForm2(
              profilePicture: profilePicture,
              productsBloc: productsBloc,
              product: widget.product,
              onNextPressed: ({
                required Product product,
                required List<File> images,
              }) {
                this.product = product;
                this.images = images;
                setState(() {});
                swipePage(2);
              },
            ),
            AddProductForm3(
              colors: widget.product?.colors,
              sizes: widget.product?.sizes,
              onNextPressed: ({
                required List<dynamic> colors,
                required List<dynamic> sizes,
              }) {
                this.colors = colors;
                this.sizes = sizes;
                setState(() {});

                swipePage(3);
              },
            ),
            AddProductForm4(
              images: images,
              product: product,
              profilePicture: profilePicture,
              colors: colors!,
              sizes: sizes!,
              productsBloc: productsBloc,
            ),
          ],
        ),
      ),
    );
  }
}
