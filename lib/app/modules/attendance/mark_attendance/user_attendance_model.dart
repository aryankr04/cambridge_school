import 'package:intl/intl.dart';

class UserAttendance {
  final DateTime academicPeriodStart;
  final String attendanceString;

  //Valid chars as a variable inside function or class.
  UserAttendance({
    required this.academicPeriodStart,
    required this.attendanceString,
  }) : assert(
            attendanceString.isEmpty ||
                attendanceString.split('').every((char) => _isValidChar(char)),
            'Invalid attendance string: Contains invalid characters.');

  static bool _isValidChar(String char) {
    const String validAttendanceChars = 'PAHLEN';
    return validAttendanceChars.contains(char);
  }

  // Factory method to create a UserAttendance instance with an empty string.
  factory UserAttendance.empty(
      {required DateTime academicPeriodStart,
      required String userId,
      required String name,
      String? profileUrl,
      required int numberOfDays}) {
    final emptyString = ''.padRight(numberOfDays, 'N');
    return UserAttendance(
      academicPeriodStart: academicPeriodStart,
      attendanceString: emptyString,
    );
  }

  // Add map and from map
  Map<String, dynamic> toMap() {
    return {
      'academicPeriodStart': academicPeriodStart.toIso8601String(),
      'attendanceString': attendanceString,
    };
  }

  static UserAttendance? fromMap(Map<String, dynamic> map) {
    try {
      return UserAttendance(
        academicPeriodStart:
            DateTime.parse(map['academicPeriodStart'] as String),
        attendanceString: map['attendanceString'] as String,
      );
    } catch (e) {
      print("Exception on UserAttendance fromMap $e");
      return null;
    }
  }

  // Update attendance for a specific date
  UserAttendance updateAttendance(DateTime date, String status) {
    const String validAttendanceChars = 'PAHLEN';
    if (!validAttendanceChars.contains(status)) {
      throw ArgumentError(
          'Invalid attendance status.  Must be one of: $validAttendanceChars');
    }

    final offset = date.difference(academicPeriodStart).inDays;
    String newAttendanceString = attendanceString;
    DateTime newAcademicPeriodStart = academicPeriodStart;

    if (offset < 0) {
      //Date is before the Academic Period

      final daysBefore = -offset;
      newAcademicPeriodStart = date;
      newAttendanceString = status +
          ''.padRight(daysBefore > 1 ? daysBefore - 1 : 0, 'N') +
          attendanceString; //insert date and pad with "N"
    } else if (offset >= attendanceString.length) {
      // Extend the string with "N" for the missing days
      int daysToAdd = offset - attendanceString.length;
      newAttendanceString =
          attendanceString + ''.padRight(daysToAdd, 'N') + status;
    } else {
      //Valid Date
      newAttendanceString =
          attendanceString.replaceRange(offset, offset + 1, status);
    }

    return UserAttendance(
      academicPeriodStart: newAcademicPeriodStart,
      attendanceString: newAttendanceString,
    );
  }

  // Update attendance for a date range
  UserAttendance updateMultiDateAttendance(
      DateTime startDate, DateTime endDate, String status) {
    if (!UserAttendance._isValidChar(status)) {
      throw ArgumentError('Invalid attendance status: Must be one of PAHLEN');
    }

    UserAttendance updatedAttendance = this; // Start with the current state
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      updatedAttendance =
          updatedAttendance.updateAttendance(currentDate, status);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return updatedAttendance;
  }

  // Get attendance status for a specific date
  String getAttendanceStatus(DateTime date) {
    final offset = date.difference(academicPeriodStart).inDays;

    if (offset < 0 || offset >= attendanceString.length) {
      throw RangeError(
          'Date is outside the academic period. Start date: ${formatDate(academicPeriodStart)} , current date: ${formatDate(date)}');
    }

    return attendanceString[offset];
  }

  // Format date for better readability in logs/debugging
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Method to calculate the total present days, absent days, holidays etc
  Map<String, int> calculateAttendanceSummary() {
    int presentDays = 0;
    int absentDays = 0;
    int holidays = 0;
    int lates = 0;
    int excusedAbsences = 0;
    int notApplicable = 0;

    for (int i = 0; i < attendanceString.length; i++) {
      switch (attendanceString[i]) {
        case 'P':
          presentDays++;
          break;
        case 'A':
          absentDays++;
          break;
        case 'H':
          holidays++;
          break;
        case 'L':
          lates++;
          break;
        case 'E':
          excusedAbsences++;
          break;
        case 'N':
          notApplicable++;
          break;
      }
    }

    return {
      'Present': presentDays,
      'Absent': absentDays,
      'Holiday': holidays,
      'Late': lates,
      'Excused': excusedAbsences,
      'Not Applicable': notApplicable,
    };
  }

  // Compact - This method handles edge cases such as:
  //1) User deletes the day and then that's it
  //2) User compact and adds date before the day.
  //3) User compact and the days are shorter than the real attendance.
  UserAttendance compact(DateTime newStartDate) {
    return UserAttendance(
      academicPeriodStart: newStartDate,
      attendanceString: attendanceString,
    );
  }
}
