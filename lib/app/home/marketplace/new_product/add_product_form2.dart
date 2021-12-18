import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/app/home/marketplace/widgets/product_field.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/platform_exception_alert_dialog.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddProductForm2 extends StatefulWidget {
  const AddProductForm2({
    Key? key,
    required this.productsBloc,
    required this.onNextPressed,
    required this.profilePicture,
    this.product,
  }) : super(key: key);

  final File? profilePicture;
  final ProductsBloc productsBloc;
  final Product? product;
  final void Function({
    required Product product,
    required List<File> images,
  }) onNextPressed;

  @override
  _AddProductForm2State createState() => _AddProductForm2State();
}

class _AddProductForm2State extends State<AddProductForm2> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> images = <File>[];
  final List<Widget> items = <Widget>[];

  String? offer;
  int? price;
  String? specification;
  @override
  void initState() {
    if (widget.product != null) {
      offer = widget.product!.offer;
      price = widget.product!.price;
      specification = widget.product!.specification;
    }

    super.initState();
  }

  Widget buildProfilePicture() {
    if (widget.profilePicture != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: 200,
          child: Image.file(
            widget.profilePicture!,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (widget.product != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: 200,
          child: CachedNetworkImage(
            imageUrl: widget.product!.profileImage,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // TODO @low same button in form 1
  Widget buildUploadButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () async {
          loadAssets();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          minimumSize: MaterialStateProperty.all(Size(200, 70)),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ajouter une image',
              style: TextStyle(
                color: Color.fromRGBO(51, 77, 115, 0.88),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Icon(
                Icons.add,
                color: Color.fromRGBO(51, 77, 115, 0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSave() async {
    if (_formKey.currentState!.validate()) {
      if (images.isEmpty && (widget.product?.images.isEmpty ?? true)) {
        PlatformExceptionAlertDialog(
          exception: PlatformException(
            code: 'Erreur',
            message: 'veuillez sélectionner au moins une image',
          ),
        ).show(context);
        return;
      }

      final Product product = Product(
        id: widget.product?.id ?? '',
        images: widget.product?.images ?? [],
        profileImage: widget.product?.profileImage ?? '',
        price: price!,
        specification: specification!,
        offer: offer!,
        colors: widget.product?.colors ?? [],
        sizes: widget.product?.sizes ?? [],
        wilaya: context.read<User>().wilaya,
        createdBy: context.read<User>().toMiniUser(),
        createdAt: Timestamp.now(),
      );
      widget.onNextPressed(
        product: product,
        images: images,
      );
    }
  }

  Future<void> loadAssets() async {
    List<AssetEntity>? resultList = <AssetEntity>[];

    final List<String> imagesPathsList = [];
    try {
      resultList = await AssetPicker.pickAssets(
        context,
        textDelegate: EnglishTextDelegate(),
        maxAssets: 5,
        selectedAssets: resultList,
        themeColor: Colors.blue,
      );
      if (resultList == null) return;

      for (final AssetEntity asset in resultList) {
        final File? file = await asset.file;
        if (file != null) imagesPathsList.add(file.path);
      }
      if (imagesPathsList.isNotEmpty) {
        final List<File> finalFiles = [];
        for (final String imagePath in imagesPathsList) {
          // final File? croppedImage = await ImageCropper.cropImage(
          //   androidUiSettings: AndroidUiSettings(
          //     backgroundColor: Colors.black,
          //     toolbarColor: Colors.white,
          //     toolbarWidgetColor: Colors.black,
          //     toolbarTitle: 'Recadrer la photo',
          //     activeControlsWidgetColor: Colors.blue,
          //   ),
          //   sourcePath: imagePath,
          //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          // );
          // if (croppedImage != null) {
          //   finalFiles.add(croppedImage);
          //   logger.info('edited images ${croppedImage.path}');
          // }
          finalFiles.add(File(imagePath));
        }
        if (finalFiles.length == imagesPathsList.length) {
          setState(() {
            images = finalFiles;
          });
        }
      }
    } on Exception catch (e) {
      PlatformExceptionAlertDialog(exception: e).show(context);
    }
  }

  void buildCarousel() {
    items.clear();
    if (images.isNotEmpty) {
      for (final File file in images) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              Image.file(
                file,
                fit: BoxFit.contain,
                height: SizeConfig.blockSizeVertical * 102,
                width: SizeConfig.blockSizeVertical * 102,
              ),
              IconButton(
                onPressed: () {
                  images.remove(file);
                  setState(() {});
                },
                icon: Icon(Icons.cancel, color: Colors.grey),
              ),
            ],
          ),
        );
        items.add(w);
      }
    }
    if (widget.product != null) {
      for (final String url in widget.product!.images) {
        final w = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  height: SizeConfig.blockSizeVertical * 102,
                  width: SizeConfig.blockSizeVertical * 102,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.product!.images.remove(url);
                  setState(() {});
                },
                icon: Icon(Icons.cancel, color: Colors.grey),
              ),
            ],
          ),
        );
        items.add(w);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    buildCarousel();
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildProfilePicture(),
            buildUploadButton(),
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
            ProductField(
              initialValue: price != null ? '$price' : null,
              title: 'Prix :',
              hint: '',
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
              suffix: SizedBox(
                width: 50,
                height: 20,
                child: Row(
                  children: [
                    VerticalDivider(color: Colors.black),
                    Text(
                      'DA',
                      style: TextStyle(
                        color: Color.fromRGBO(34, 50, 99, 0.69),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                price = int.parse(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'veuillez entrer un prix';
                }
                if (int.tryParse(value) == null) {
                  return 'format incorrect';
                }
              },
            ),
            ProductField(
              initialValue: offer,
              title: 'Titre :',
              hint: '',
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
              lines: 5,
              onChanged: (value) {
                offer = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'veuillez entrer un titre';
                }
              },
            ),
            ProductField(
              initialValue: specification,
              title: 'Description :',
              hint: '',
              textInputAction: TextInputAction.newline,
              textInputType: TextInputType.multiline,
              lines: 5,
              onChanged: (value) {
                specification = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'veuillez entrer une description';
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 20),
              child: NextButton(
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
