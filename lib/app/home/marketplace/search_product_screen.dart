import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:randolina/app/home/marketplace/filtered_products.dart';
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/algeria_cities.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/logger.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({
    Key? key,
    required this.products,
    required this.bloc,
  }) : super(key: key);
  final List<Product> products;
  final ProductsBloc bloc;

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen>
    with SingleTickerProviderStateMixin {
  SfRangeValues _activeRangeSliderValue = SfRangeValues(0, 100000);
  late TabController _tabController;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late final int searchWilayaInitValue;
  late String wilayaDropDown;
  late int wilayaNumber;
  late List<String> options;
  bool isBackPressedOrTouchedOutSide = false;
  bool isDropDownOpened = false;
  bool isPanDown = false;
  bool navigateToPreviousScreenOnIOSBackPress = true;
  String selectedItem = '';
  String toIntToString(dynamic value) => (value as num).toInt().toString();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {});
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController1.text = toIntToString(_activeRangeSliderValue.start);
    textEditingController2.text = toIntToString(_activeRangeSliderValue.end);

    options = algeriaCities
        .map((e) {
          return "${e['wilaya_code']} - ${e["wilaya_name_ascii"]}";
        })
        .toSet()
        .toList();

    logger.severe(options.length);
    options.insert(0, 'Wilaya');
    wilayaNumber = 0;
    wilayaDropDown = options.elementAt(wilayaNumber);
    super.initState();
  }

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

  Widget buildSliderInput1(StateSetter setState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFEBF0FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 100,
          child: TextField(
            controller: textEditingController1,
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.number,
            onChanged: (t) {
              final num number = num.tryParse(t) ?? 0;
              if (number > 0 && number < 300000) {
                _activeRangeSliderValue = SfRangeValues(
                  number,
                  _activeRangeSliderValue.end as num,
                );
                setState(() {});
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildSliderInput2(StateSetter setState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFEBF0FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 100,
          child: TextField(
            controller: textEditingController2,
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.number,
            onChanged: (t) {
              final num number = num.tryParse(t) ?? 0;
              if (number > 0 && number < 300000) {
                _activeRangeSliderValue = SfRangeValues(
                  _activeRangeSliderValue.start as num,
                  number,
                );
                setState(() {});
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> buildSlider(StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSliderInput1(setState),
          SizedBox(width: 20),
          buildSliderInput2(setState),
        ],
      ),
      SizedBox(height: 7),
      SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
          thumbColor: Colors.blue,
          activeTickColor: Colors.blue,
          activeTrackColor: Colors.blue,
        ),
        child: SfRangeSlider(
          stepSize: 100,
          min: 0,
          max: 300000,
          onChanged: (dynamic values) {
            _activeRangeSliderValue = values as SfRangeValues;
            textEditingController1.text =
                toIntToString(_activeRangeSliderValue.start);
            textEditingController2.text =
                toIntToString(_activeRangeSliderValue.end);

            setState(() {});
          },
          values: _activeRangeSliderValue,
          enableTooltip: true,
          numberFormat: NumberFormat('#'),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('MIN',
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          Text('MAX',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Widget normalChildButton = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        border: Border.all(color: Colors.grey),
      ),
      height: 40,
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              wilayaDropDown,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 20,
            height: 20,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Filtre de recherche',
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
      body: Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 18, right: 14, bottom: 26),
        child: Stack(
          children: [
            ...[
              buildTitle('Budget :'),
              SizedBox(
                height: SizeConfig.screenHeight / 2.2,
                width: SizeConfig.screenWidth - 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                    ...buildSlider(setState),
                    SizedBox(height: 7),
                    SizedBox(
                      width: SizeConfig.screenWidth - 50,
                      child: Row(
                        children: [
                          buildTitle('Emplacement du magasin :'),
                          Expanded(
                            child: Container(
                              color: backgroundColor,
                              child: AwesomeDropDown(
                                isPanDown: isPanDown,
                                dropDownList: options.toList(),
                                isBackPressedOrTouchedOutSide:
                                    isBackPressedOrTouchedOutSide,
                                selectedItem: wilayaDropDown,
                                numOfListItemToShow: 6,
                                onDropDownItemClick: (String? selectedItem) {
                                  if (selectedItem == null) {
                                  } else if (selectedItem == 'Wilaya') {
                                    wilayaDropDown = selectedItem;
                                    setState(() => wilayaNumber = 0);
                                  } else {
                                    final int? wilayaN = int.tryParse(
                                        selectedItem[0] + selectedItem[1]);
                                    wilayaDropDown = selectedItem;
                                    setState(() => wilayaNumber = wilayaN!);
                                  }
                                },
                                dropStateChanged: (bool isOpened) {
                                  isDropDownOpened = isOpened;
                                  if (!isOpened) {
                                    isBackPressedOrTouchedOutSide = false;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Align(
              alignment: Alignment.bottomCenter,
              child: NextButton(
                title: 'Appliquer',
                onPressed: () async {
                  if (wilayaNumber != 0) {
                    final List<Product> filteredProducts =
                        widget.bloc.productsFilter(
                      widget.products,
                      _activeRangeSliderValue,
                      wilayaNumber,
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FilteredProducts(products: filteredProducts),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
