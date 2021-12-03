import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:randolina/app/home/marketplace/market_place_bloc.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProductsSearch extends StatefulWidget {
  const ProductsSearch({
    Key? key,
    required this.onTextChanged,
  }) : super(key: key);
  final ValueChanged<String> onTextChanged;

  @override
  ProductsSearchState createState() => ProductsSearchState();
}

class ProductsSearchState extends State<ProductsSearch>
    with SingleTickerProviderStateMixin {
  ProductsBloc? productsBloc;
  SfRangeValues _activeRangeSliderValue = SfRangeValues(0, 100000);
  late TabController _tabController;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  String searchText = '';
  //EventCreatedBy dropdownValue = EventCreatedBy.clubOnly;
  String toIntToString(dynamic value) => (value as num).toInt().toString();
  late List<String> options;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {});
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController1.text = toIntToString(_activeRangeSliderValue.start);
    textEditingController2.text = toIntToString(_activeRangeSliderValue.end);
    super.initState();
  }

  Widget buildDoneButton(BuildContext context2) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.8],
          colors: [
            Color.fromRGBO(51, 77, 115, 0.64),
            Color.fromRGBO(64, 191, 255, 1)
          ],
        ),
        color: Colors.deepPurple.shade300,
      ),
      child: ElevatedButton(
        onPressed: () {
          // final chosenEvents = context.read<ValueNotifier<List<Event>>>().value;
          // logger.info(_activeRangeSliderValue);
          // final List<Event> matchedEvents = widget.eventsBloc.filtreEvents(
          //   chosenEvents,
          //   searchText,
          //   dropdownValue,
          //   _activeRangeSliderValue,
          // );

          // Navigator.of(context2).pop();
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (c) => SearchResultScreen(
          //       eventsBloc: widget.eventsBloc,
          //       events: matchedEvents,
          //       isMyevent: widget.isMyevent,
          //     ),
          //   ),
          // );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all(Size(120, 30)),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
        ),
        child: Text('Terminé'),
      ),
    );
  }

  Widget buildSliderInput1(StateSetter setState) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[300]!),
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
        border: Border.all(color: Colors.blue[300]!),
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Le prix: ',
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSliderInput1(setState),
          SizedBox(width: 10),
          buildSliderInput2(setState),
        ],
      ),
      SizedBox(height: 16),
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.grey),
    );
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF334D73).withOpacity(0.20),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 24),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        enabledBorder: border,
                        errorBorder: border,
                        hintText: 'What are you looking for...',
                        focusedBorder: border,
                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon:
                            Icon(Icons.search, color: Colors.transparent),
                        contentPadding: EdgeInsets.zero,
                        fillColor: backgroundColor,
                        filled: true,
                      ),
                      onChanged: (t) {
                        searchText = t.trim();
                        widget.onTextChanged(searchText);
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          content: StatefulBuilder(
                              builder: (context, StateSetter setState) {
                            return SizedBox(
                              height: SizeConfig.screenHeight / 2.2,
                              width: SizeConfig.screenWidth - 50,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //     buildTabBar(setState),
                                  SizedBox(height: 16),
                                  ...buildSlider(setState),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: buildDoneButton(context),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    size: 30,
                    color: Colors.blue[300],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
