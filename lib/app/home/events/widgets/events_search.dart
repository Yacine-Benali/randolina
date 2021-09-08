import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
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
    required this.onEventCreatedByChanged,
    required this.onRangeValueChanged,
  }) : super(key: key);
  final ValueChanged<String> onTextChanged;
  final ValueChanged<EventCreatedBy> onEventCreatedByChanged;
  final ValueChanged<SfRangeValues> onRangeValueChanged;

  @override
  EventsSearchState createState() => EventsSearchState();
}

class EventsSearchState extends State<EventsSearch>
    with SingleTickerProviderStateMixin {
  SfRangeValues _activeRangeSliderValue = const SfRangeValues(500, 100000);
  late TabController _tabController;

  String searchText = '';
  EventCreatedBy dropdownValue = EventCreatedBy.clubOnly;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      //widget.onTabChanged(_tabController.index);
    });
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
          widget.onEventCreatedByChanged(dropdownValue);
          widget.onRangeValueChanged(_activeRangeSliderValue);
          Navigator.of(context2).pop();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all(Size(120, 30)),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
        ),
        child: Text('Done'),
      ),
    );
  }

  Widget buildTextBox(num x) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: x.toInt().toString(),
            style: TextStyle(color: Colors.black87),
            children: const <TextSpan>[
              TextSpan(
                  text: '  DA',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
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
          buildTextBox(_activeRangeSliderValue.start as num),
          SizedBox(width: 10),
          buildTextBox(_activeRangeSliderValue.end as num),
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
            setState(() {
              _activeRangeSliderValue = values as SfRangeValues;
            });
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

  Widget buildTextBox2(EventCreatedBy eventCreatedBy, StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          dropdownValue = eventCreatedBy;
          setState(() {});
        },
        child: Container(
          width: 100,
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
            child: Text(
              eventSearchText[eventCreatedBy]!,
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
    );
  }

  Widget buildTabBar(StateSetter setState) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Row(
        children: [
          buildTextBox2(EventCreatedBy.both, setState),
          buildTextBox2(EventCreatedBy.clubOnly, setState),
          buildTextBox2(EventCreatedBy.agencyOnly, setState)
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
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 10,
              top: 24,
            ),
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
                        hintText: 'Search...',
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
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: SizeConfig.screenWidth - 50),
                                buildTabBar(setState),
                                SizedBox(height: 16),
                                ...buildSlider(setState),
                                buildDoneButton(context),
                              ],
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
