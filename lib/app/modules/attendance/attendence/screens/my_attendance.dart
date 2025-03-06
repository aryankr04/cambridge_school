import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../mark_attendance/user_attendance_model.dart';

class MyAttendanceCalendar extends StatelessWidget {
  final UserAttendance? userAttendance;
  final Function(DateTime) onMonthChanged;

  const MyAttendanceCalendar({
    required this.userAttendance,
    required this.onMonthChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _AttendanceCalendarWidget(
      userAttendance: userAttendance,
      onMonthChanged: onMonthChanged,
    );
  }
}

class _AttendanceCalendarWidget extends StatefulWidget {
  final UserAttendance? userAttendance;
  final Function(DateTime) onMonthChanged;

  const _AttendanceCalendarWidget({
    required this.userAttendance,
    required this.onMonthChanged,
  });

  @override
  _AttendanceCalendarWidgetState createState() =>
      _AttendanceCalendarWidgetState();
}

class _AttendanceCalendarWidgetState extends State<_AttendanceCalendarWidget> {
  late DateTime _currentMonth;
  late int _firstDayOfWeekday;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _calculateFirstDayWeekday();
  }

  @override
  void didUpdateWidget(covariant _AttendanceCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userAttendance != oldWidget.userAttendance) {
      _calculateFirstDayWeekday();
    }
  }

  void _calculateFirstDayWeekday() {
    _firstDayOfWeekday = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;
  }

  void _changeMonth(int increment) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + increment,
        1,
      );
      _calculateFirstDayWeekday();
      widget.onMonthChanged(_currentMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final int daysInMonth = lastDayOfMonth.day;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        color: MyDynamicColors.backgroundColorWhiteDarkGrey,
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        border: Border.all(width: .5, color: MyDynamicColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                DateFormat.yMMMM().format(_currentMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: MyColors.headlineTextColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          const SizedBox(height: MySizes.md),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Sun"),
              Text("Mon"),
              Text("Tue"),
              Text("Wed"),
              Text("Thu"),
              Text("Fri"),
              Text("Sat"),
            ],
          ),
          const SizedBox(height: MySizes.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: daysInMonth + _firstDayOfWeekday - 1,
            itemBuilder: (context, index) {
              if (index < _firstDayOfWeekday - 1) {
                return const SizedBox.shrink();
              }

              final int day = index - (_firstDayOfWeekday - 2);
              final DateTime currentDate = DateTime(_currentMonth.year, _currentMonth.month, day);

              String status = widget.userAttendance != null
                  ? widget.userAttendance!.getAttendanceStatus(currentDate)
                  : 'N';

              return Container(
                margin: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStatusColor(status),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$day",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 13,
                    color: status == 'N'
                        ? MyDynamicColors.subtitleTextColor
                        : Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'P':
        return MyDynamicColors.activeGreen;
      case 'A':
        return MyDynamicColors.activeRed;
      case 'H':
        return Colors.orange;
      case 'L':
        return Colors.purple;
      case 'E':
        return Colors.blue;
      case 'N':
      default:
        return Colors.transparent;
    }
  }
}