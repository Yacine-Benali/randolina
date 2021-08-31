import 'package:flutter/material.dart';

class EventDifficultyPicker extends StatefulWidget {
  const EventDifficultyPicker({
    Key? key,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);
  final ValueChanged<int> onChanged;
  final bool enabled;
  @override
  _EventDifficultyPickerState createState() => _EventDifficultyPickerState();
}

class _EventDifficultyPickerState extends State<EventDifficultyPicker> {
  int groupeValue = 1;

  void onChanged(int newValue) {
    setState(() {
      groupeValue = newValue;
      widget.onChanged(groupeValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Niveau de difficulté :',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(34, 50, 99, 1),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <LabeledRadio>[
              LabeledRadio(
                enabled: widget.enabled,
                label: '1',
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: 1,
                groupValue: groupeValue,
                onChanged: onChanged,
              ),
              LabeledRadio(
                enabled: widget.enabled,
                label: '2',
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: 2,
                groupValue: groupeValue,
                onChanged: onChanged,
              ),
              LabeledRadio(
                enabled: widget.enabled,
                label: '3',
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: 3,
                groupValue: groupeValue,
                onChanged: onChanged,
              ),
              LabeledRadio(
                enabled: widget.enabled,
                label: '4',
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: 4,
                groupValue: groupeValue,
                onChanged: onChanged,
              ),
              LabeledRadio(
                enabled: widget.enabled,
                label: '5',
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: 5,
                groupValue: groupeValue,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final int groupValue;
  final int value;
  final ValueChanged<int> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              if (value != groupValue) {
                onChanged(value);
              }
            }
          : null,
      child: Padding(
        padding: padding,
        child: Column(
          children: <Widget>[
            Text(label),
            Radio<int>(
              groupValue: groupValue,
              value: value,
              onChanged: enabled
                  ? (int? newValue) {
                      onChanged(newValue!);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
