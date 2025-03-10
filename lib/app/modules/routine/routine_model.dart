
// -----------------------------------------------------------------------------
// Data Models - Kept in the same file for clarity and simplicity.
// Consider moving them to separate files for larger projects.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

class WeeklyRoutine {
  final String id;
  final List<DailyRoutine> dailyRoutines;

  WeeklyRoutine({
    required this.id,
    required this.dailyRoutines,
  });

  factory WeeklyRoutine.fromMap(Map<String, dynamic> map, String id) {
    return WeeklyRoutine(
      id: id,
      dailyRoutines: (map['dailyRoutines'] as List<dynamic>?)
          ?.map((e) => DailyRoutine.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyRoutines': dailyRoutines.map((e) => e.toMap()).toList(),
    };
  }

  WeeklyRoutine copyWith({
    String? id,
    List<DailyRoutine>? dailyRoutines,
  }) {
    return WeeklyRoutine(
      id: id ?? this.id,
      dailyRoutines: dailyRoutines ?? this.dailyRoutines,
    );
  }
}

class DailyRoutine {
  final String day;
  final List<Event> events;

  DailyRoutine({
    required this.day,
    required this.events,
  });

  factory DailyRoutine.fromMap(Map<String, dynamic> map) {
    return DailyRoutine(
      day: map['day'] ?? '',
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

  DailyRoutine copyWith({
    String? day,
    List<Event>? events,
  }) {
    return DailyRoutine(
      day: day ?? this.day,
      events: events ?? this.events,
    );
  }
}

class Event {
  final String? subject;
  final String? eventType;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? teacher;
  final String? location;

  Event({
    this.subject,
    this.eventType,
    required this.startTime,
    required this.endTime,
    this.teacher,
    this.location,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    TimeOfDay parseTimeOfDay(String? timeString) {
      if (timeString == null) {
        return TimeOfDay.now();
      }
      List<String> parts = timeString.split(':');
      if (parts.length != 2) {
        return TimeOfDay.now();
      }
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }

    return Event(
      subject: map['subject'],
      eventType: map['eventType'],
      startTime: parseTimeOfDay(map['startTime'] as String?),
      endTime: parseTimeOfDay(map['endTime'] as String?),
      teacher: map['teacher'],
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap() {
    String timeOfDayToString(TimeOfDay timeOfDay) {
      return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    }

    return {
      'subject': subject,
      'eventType': eventType,
      'startTime': timeOfDayToString(startTime),
      'endTime': timeOfDayToString(endTime),
      'teacher': teacher,
      'location': location,
    };
  }

  Event copyWith({
    String? subject,
    String? eventType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? teacher,
    String? location,
  }) {
    return Event(
      subject: subject ?? this.subject,
      eventType: eventType ?? this.eventType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teacher: teacher ?? this.teacher,
      location: location ?? this.location,
    );
  }
}