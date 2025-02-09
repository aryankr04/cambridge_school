import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabContent;
  final double indicatorHeight;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;

  const MyTabBar({
    super.key,
    required this.tabTitles,
    required this.tabContent,
    this.indicatorHeight = 4.0,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.black45,
    this.indicatorColor = Colors.blue,
  });

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: widget.indicatorColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.tabTitles.asMap().entries.map((entry) {
              int idx = entry.key;
              String title = entry.value;
              return GestureDetector(
                onTap: () => _onTabSelected(idx),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedIndex == idx
                            ? widget.indicatorColor
                            : Colors.transparent,
                        width: widget.indicatorHeight,
                      ),
                    ),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: _selectedIndex == idx
                          ? widget.selectedColor
                          : widget.unselectedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Tab Content
        Expanded(
          child: widget.tabContent[_selectedIndex],
        ),
      ],
    );
  }
}
