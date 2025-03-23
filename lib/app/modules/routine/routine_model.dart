import 'package:flutter/material.dart';

import '../../../core/utils/constants/enums/schedule_event_type.dart';

class DailyRoutine {
  final String day;
  final List<Event> events;

  DailyRoutine({required this.day, required this.events});

  factory DailyRoutine.fromMap(Map<String, dynamic> map) {
    return DailyRoutine(
      day: map['day'] as String? ?? '',
      events: (map['events'] as List<dynamic>?)
              ?.map((e) => Event.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'events': events.map((e) => e.toMap()).toList(),
    };
  }
}

class Event {
  final String? subject;
  final ScheduleEventType eventType;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? teacherName;
  final String? teacherId;
  final String? location;

  Event({
    this.subject,
    required this.eventType,
    required this.startTime,
    required this.endTime,
    this.teacherName,
    this.teacherId,
    this.location,
  });

  static TimeOfDay _parseTimeOfDay(String? timeString) {
    if (timeString == null) return TimeOfDay.now();
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return TimeOfDay.now();
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      print('Error parsing TimeOfDay: $e');
      return TimeOfDay.now();
    }
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      subject: map['subject'] as String?,
      eventType:
          ScheduleEventType.fromString(map['eventType'] as String? ?? '') ??
              ScheduleEventType.classSession,
      startTime: _parseTimeOfDay(map['startTime'] as String?),
      endTime: _parseTimeOfDay(map['endTime'] as String?),
      teacherName: map['teacherName'] as String?,
      teacherId: map['teacherId'] as String?,
      location: map['location'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    String _timeOfDayToString(TimeOfDay timeOfDay) {
      return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    }

    return {
      'subject': subject,
      'eventType': eventType.label,
      'startTime': _timeOfDayToString(startTime),
      'endTime': _timeOfDayToString(endTime),
      'teacherName': teacherName,
      'teacherId': teacherId,
      'location': location,
    };
  }
}
