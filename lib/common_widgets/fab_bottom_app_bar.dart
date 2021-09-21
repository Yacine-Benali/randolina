import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({
    required this.iconData,
    required this.notification,
  });
  IconData iconData;
  int notification;
}

class FABBottomAppBar extends StatefulWidget {
  const FABBottomAppBar({
    required this.items,
    required this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
    required this.selectedIndex,
    this.buildCenterSpace = true,
  });
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final int selectedIndex;
  final bool buildCenterSpace;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  void _updateIndex(int index) {
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    if (widget.buildCenterSpace) {
      items.insert(items.length >> 1, _buildMiddleTabItem());
    }

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: SizedBox(height: widget.iconSize),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final Color color =
        (widget.selectedIndex == index) ? widget.selectedColor : widget.color;

    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Icon(
                    item.iconData,
                    color: color,
                    size: item.iconData == Icons.calendar_today
                        ? 28
                        : widget.iconSize,
                  ),
                  if (item.notification != 0) ...[
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          item.notification.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
