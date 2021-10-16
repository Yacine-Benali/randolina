import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:menu_button/menu_button.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home/events/events_bloc.dart';
import 'package:randolina/app/home/events/nested_screens/search_result_screen.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/algeria_cities.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/utils/logger.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum EventCreatedBy { both, clubOnly, agencyOnly }
Map<EventCreatedBy, String> eventSearchText = {
  EventCreatedBy.both: 'All',
  EventCreatedBy.clubOnly: 'Club',
  EventCreatedBy.agencyOnly: 'Agence',
};

class EventsSearch extends StatefulWidget {
  const EventsSearch({
    Key? key,
    required this.onTextChanged,
    required this.onWilayaChanged,
    required this.eventsBloc,
    required this.isMyevent,
  }) : super(key: key);
  final ValueChanged<String> onTextChanged;
  final ValueChanged<int> onWilayaChanged;
  final EventsBloc eventsBloc;
  final bool isMyevent;

  @override
  EventsSearchState createState() => EventsSearchState();
}

class EventsSearchState extends State<EventsSearch>
    with SingleTickerProviderStateMixin {
  SfRangeValues _activeRangeSliderValue = SfRangeValues(0, 100000);
  late TabController _tabController;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;

  String searchText = '';
  EventCreatedBy dropdownValue = EventCreatedBy.clubOnly;
  String? wilayaDropDown;
  late int wilayaNumber;
  String toIntToString(dynamic value) => (value as num).toInt().toString();
  late Set<String> options;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {});
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController1.text = toIntToString(_activeRangeSliderValue.start);
    textEditingController2.text = toIntToString(_activeRangeSliderValue.end);
    //! fix this, this is a temp fixs

    options = algeriaCities
        .map((e) {
          return "${e['wilaya_code']} - ${e["wilaya_name_ascii"]}";
        })
        .toList()
        .toSet();

    // final User currentUser = context.read<User>();
    // final rs = algeriaCities
    //     .firstWhere((e) => e['wilaya_code'] as int == currentUser.wilaya);

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
          final chosenEvents = context.read<ValueNotifier<List<Event>>>().value;
          logger.info(_activeRangeSliderValue);
          final List<Event> matchedEvents = widget.eventsBloc.filtreEvents(
            chosenEvents,
            searchText,
            dropdownValue,
            _activeRangeSliderValue,
          );

          Navigator.of(context2).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) => SearchResultScreen(
                eventsBloc: widget.eventsBloc,
                events: matchedEvents,
                isMyevent: widget.isMyevent,
              ),
            ),
          );
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

  Widget buildTabBarItem(EventCreatedBy eventCreatedBy, StateSetter setState) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            dropdownValue = eventCreatedBy;
            setState(() {});
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 5.0,
                )
              ],
              gradient: dropdownValue == eventCreatedBy
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0, 1],
                      colors: [gradientStart, gradientEnd],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0, 1],
                      colors: [Colors.white, Colors.white],
                    ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                eventSearchText[eventCreatedBy]!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: dropdownValue == eventCreatedBy
                      ? Colors.white
                      : Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabBar(StateSetter setState) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Row(
        children: [
          buildTabBarItem(EventCreatedBy.both, setState),
          buildTabBarItem(EventCreatedBy.clubOnly, setState),
          buildTabBarItem(EventCreatedBy.agencyOnly, setState)
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.grey),
    );
    final Widget normalChildButton = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
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
              wilayaDropDown ?? 'Depart',
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
                        hintText: 'Destination...',
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
                SizedBox(
                  width: 100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: MenuButton<String>(
                      items: options.toList(),
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      crossTheEdge: true,
                      edgeMargin: 12,
                      selectedItem: wilayaDropDown,
                      itemBuilder: (String value) {
                        return Container(
                          color: backgroundColor,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      },
                      decoration: BoxDecoration(),
                      toggledChild: normalChildButton,
                      divider: Container(
                        height: 0,
                        color: Colors.white,
                      ),
                      onItemSelected: (String? newValue) {
                        if (newValue == null) {
                        } else {
                          final int? wilayaN =
                              int.tryParse(newValue[0] + newValue[1]);
                          wilayaDropDown = newValue;
                          setState(() => wilayaNumber = wilayaN!);
                          widget.onWilayaChanged(wilayaNumber);
                        }
                      },
                      child: normalChildButton,
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
                                  buildTabBar(setState),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
