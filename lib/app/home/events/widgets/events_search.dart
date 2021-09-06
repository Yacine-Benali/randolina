import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:randolina/common_widgets/size_config.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum EventCreatedBy { both, clubOnly, agencyOnly }
Map<EventCreatedBy, String> eventSearchText = {
  EventCreatedBy.both: 'both',
  EventCreatedBy.clubOnly: 'show club only',
  EventCreatedBy.agencyOnly: 'show agency only',
};

class EventsSearch extends StatefulWidget {
  const EventsSearch({
    Key? key,
    required this.onTextChanged,
    required this.onEventCreatedByChanged,
  }) : super(key: key);
  final ValueChanged<String> onTextChanged;
  final ValueChanged<EventCreatedBy> onEventCreatedByChanged;

  @override
  EventsSearchState createState() => EventsSearchState();
}

class EventsSearchState extends State<EventsSearch> {
  SfRangeValues _activeRangeSliderValue = const SfRangeValues(500.0, 10000.0);

  String searchText = '';
  EventCreatedBy dropdownValue = EventCreatedBy.both;

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
                          title: Text('Filtre options'),
                          content: StatefulBuilder(
                              builder: (context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: SizeConfig.screenWidth - 50),
                                DropdownButton<EventCreatedBy>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  onChanged: (EventCreatedBy? newValue) {
                                    setState(() => dropdownValue = newValue!);
                                  },
                                  items: EventCreatedBy.values
                                      .map<DropdownMenuItem<EventCreatedBy>>(
                                          (EventCreatedBy value) {
                                    return DropdownMenuItem<EventCreatedBy>(
                                      value: value,
                                      child: Text(eventSearchText[value]!),
                                    );
                                  }).toList(),
                                ),
                                SfRangeSliderTheme(
                                  data: SfRangeSliderThemeData(
                                    thumbColor: Colors.blue,
                                    activeTickColor: Colors.blue,
                                    activeTrackColor: Colors.blue,
                                  ),
                                  child: SfRangeSlider(
                                    max: 100000.0,
                                    onChanged: (dynamic values) {
                                      setState(() {
                                        _activeRangeSliderValue =
                                            values as SfRangeValues;
                                      });
                                    },
                                    values: _activeRangeSliderValue,
                                    enableTooltip: true,
                                    numberFormat: NumberFormat('#'),
                                  ),
                                ),
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
