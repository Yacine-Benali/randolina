import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/utils/logger.dart';
import 'package:uuid/uuid.dart';

class AddProductForm4 extends StatefulWidget {
  const AddProductForm4({
    Key? key,
    required this.product,
    required this.profilePicture,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.productsBloc,
  }) : super(key: key);

  final Product? product;
  final File? profilePicture;
  final List<File>? images;
  final List<dynamic> sizes;
  final List<dynamic> colors;
  final ProductsBloc productsBloc;
  @override
  _AddProductForm4State createState() => _AddProductForm4State();
}

class _AddProductForm4State extends State<AddProductForm4> {
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
    late Widget w;

    if (widget.profilePicture != null) {
      w = Image.file(
        widget.profilePicture!,
        fit: BoxFit.contain,
      );
    } else if (widget.product != null) {
      w = CachedNetworkImage(
        imageUrl: widget.product!.profileImage,
        fit: BoxFit.contain,
      );
    } else {
      w = Container();
    }

    return w;
  }

  void buildCarousel() {
    items.clear();
    if (widget.images?.isNotEmpty ?? false) {
      for (final File file in widget.images!) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.file(
            file,
            fit: BoxFit.contain,
            height: SizeConfig.blockSizeVertical * 102,
            width: SizeConfig.blockSizeVertical * 102,
          ),
        );
        items.add(w);
      }
    }
    if (widget.product != null) {
      for (final String url in widget.product!.images) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            height: SizeConfig.blockSizeVertical * 102,
            width: SizeConfig.blockSizeVertical * 102,
          ),
        );
        items.add(w);
      }
    }
  }

  Future<void> finish() async {
    finish2().then(
      (value) => Fluttertoast.showToast(
        msg: 'Product publié avec succès',
        toastLength: Toast.LENGTH_SHORT,
      ),
    );

    Navigator.of(context).pop();
  }

  Future<void> finish2() async {
    final Uuid uuid = Uuid();
    String productId = uuid.v4();

    try {
      late String profilePictureUrl;
      final List<String> imagesUrls = [];

      if (widget.product != null) {
        if (widget.product!.id != '') productId = widget.product!.id;

        profilePictureUrl = widget.product!.profileImage;
        imagesUrls.addAll(widget.product!.images);
      }

      if (widget.profilePicture != null) {
        profilePictureUrl = await widget.productsBloc.uploadProductProfileImage(
          widget.profilePicture!,
          productId,
        );
      }
      if (widget.images != null) {
        imagesUrls.addAll(
          await widget.productsBloc.uploadProductImages(
            widget.images!,
          ),
        );
      }
      final Product product = Product(
        id: productId,
        images: imagesUrls,
        profileImage: profilePictureUrl,
        specification: widget.product!.specification,
        price: widget.product!.price,
        offer: widget.product!.offer,
        sizes: widget.sizes,
        colors: widget.colors,
        wilaya: widget.product!.wilaya,
        createdBy: widget.product!.createdBy,
        createdAt: widget.product!.createdAt,
      );
      await widget.productsBloc.saveProduct(product);
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    } catch (e) {
      logger.warning('wtf');
    }
  }

  @override
  Widget build(BuildContext context) {
    buildCarousel();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildProfilePicture(),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Photos du produit...",
                style: TextStyle(
                  color: Color(0xFF000000).withOpacity(0.52),
                  fontSize: 16,
                ),
              ),
            ),
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.5,
                    enableInfiniteScroll: false,
                    aspectRatio: 2,
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
                      buildTitle("Titre :"),
                      Text(
                        widget.product!.offer,
                        style: TextStyle(
                          color: Color(0xFF223263),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    SizedBox(height: 22),
                    ...[
                      if (widget.colors[0] != "2335325234")
                        buildTitle('Couleurs :'),
                      if (widget.colors[0] != "2335325234")
                        SizedBox(
                          height: 55,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.colors.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 35,
                                    height: 35,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(
                                          widget.colors[index].toString())),
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
                    if (widget.sizes[0] != 'empty') SizedBox(height: 22),
                    ...[
                      if (widget.sizes[0] != 'empty') buildTitle('Tailles :'),
                      if (widget.sizes[0] != 'empty')
                        SizedBox(
                          height: 55,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.sizes.length,
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
                                      child:
                                          Text(widget.sizes[index].toString()),
                                    ),
                                  );
                                }),
                          ),
                        ),
                    ],
                    SizedBox(height: 25),
                    ...[
                      buildTitle('Description :'),
                      Text(
                        widget.product!.specification,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF223263),
                          fontWeight: FontWeight.w600,
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
                            "${widget.product!.price.toInt()} DA",
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
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32.0, right: 8, left: 8),
                      child: NextButton(
                        title: 'Terminer',
                        onPressed: finish,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
