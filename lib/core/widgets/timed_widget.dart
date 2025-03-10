import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimedWidget extends StatefulWidget {
  final Widget widgetToShow;
  final int milliseconds;

  const TimedWidget({
    super.key,
    required this.widgetToShow,
    required this.milliseconds,
  });

  @override
  _TimedWidgetState createState() => _TimedWidgetState();
}

class _TimedWidgetState extends State<TimedWidget> {
  final RxBool _showWidget = true.obs;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(milliseconds: widget.milliseconds), () {
      _showWidget.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _showWidget.value ? widget.widgetToShow : const SizedBox.shrink());
  }
}
