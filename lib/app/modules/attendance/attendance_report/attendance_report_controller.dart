import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../user_management/create_user/models/user_model.dart';
import '../../user_management/manage_user/repositories/roster_repository.dart';
import '../mark_attendance/user_attendance_model.dart';

class AttendanceReportController extends GetxController {
  final FirestoreRosterRepository rosterRepository =
  FirestoreRosterRepository();
  final RxString className = 'UKG'.obs;
  final RxString section = 'A'.obs;
  final RxString schoolId = 'SCH00001'.obs;
  final RxString userId = '4e693287-13ef-478d-a1f6-67eea7681663'.obs;

  final RxList<UserModel> studentList = <UserModel>[].obs;
  final RxDouble averageClassAttendance = 0.0.obs;
  final RxList<StudentRanking> studentRankings = <StudentRanking>[].obs;
  final RxBool isLoading = false.obs;

  final Rx<UserAttendance?> userAttendanceData =
      UserAttendance(academicPeriodStart: DateTime.now(), attendanceString: '')
          .obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxMap<String, int> _attendanceSummary = <String, int>{}.obs;

  Map<String, int> get attendanceSummary => _attendanceSummary;
  final RxList<Map<String, dynamic>> _streaks = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get streaks => _streaks;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await fetchClassRoster();
      calculateClassAttendance();
      rankStudentsByAttendance();
    } catch (e) {
      print('Error loading attendance data: $e');
      // Consider Get.snackbar or dialog to show user-friendly error.
      // Also log to Crashlytics or similar.
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClassRoster() async {
    studentList.value = await rosterRepository.getAllUsersInClassRoster(
        className.value, section.value, schoolId.value);

    if (studentList.isNotEmpty) {
      try {
        userAttendanceData.value = studentList
            .firstWhere((student) => student.userId == userId.value)
            .userAttendance;
      } catch (e) {
        print('User with ID ${userId.value} not found in student list.');
        userAttendanceData.value = null;
      }
    } else {
      userAttendanceData.value = null;
    }

    updateAttendanceSummary();
    updateStreaks();
  }

  void calculateClassAttendance() {
    if (studentList.isEmpty) {
      averageClassAttendance.value = 0.0;
      return;
    }

    double totalAttendancePercentage = 0.0;
    for (final student in studentList) {
      totalAttendancePercentage += getStudentAttendancePercentage(student);
    }

    averageClassAttendance.value =
        totalAttendancePercentage / studentList.length;
  }

  double getStudentAttendancePercentage(UserModel student) {
    final attendance = student.userAttendance;
    if (attendance == null || attendance.attendanceString.isEmpty) {
      return 0.0; // Or handle cases where there's no attendance data
    }

    final summary = attendance.getMonthlyAttendanceSummary(
        selectedMonth.value); //Or specify any month
    final presentDays = summary['Present'] ?? 0;
    final totalWorkingDays = summary['Working'] ?? 0;

    return totalWorkingDays > 0 ? (presentDays / totalWorkingDays) * 100 : 0;
  }

  void rankStudentsByAttendance() {
    List<StudentRanking> rankings = [];

    for (final student in studentList) {
      final percentage = getStudentAttendancePercentage(student);
      rankings.add(StudentRanking(student: student, percentage: percentage));
    }

    rankings.sort((a, b) => b.percentage.compareTo(a.percentage));
    studentRankings.value = rankings;
  }

  List<UserModel> getStudentsWithPerfectAttendance() {
    return studentList
        .where((student) => getStudentAttendancePercentage(student) == 100.0)
        .toList();
  }

  List<UserModel> getStudentsWithMostAbsences() {
    return studentList.toList()
      ..sort((a, b) {
        final attendanceA = a.userAttendance;
        final attendanceB = b.userAttendance;

        if (attendanceA == null && attendanceB == null) return 0;
        if (attendanceA == null) return 1;
        if (attendanceB == null) return -1;

        final summaryA =
        attendanceA.getMonthlyAttendanceSummary(DateTime.now());
        final summaryB =
        attendanceB.getMonthlyAttendanceSummary(DateTime.now());

        final absencesA = (summaryA['Absent'] ?? 0) as int;
        final absencesB = (summaryB['Absent'] ?? 0) as int;

        return (absencesB).compareTo(absencesA);
      });
  }

  void setSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    updateAttendanceSummary();
    updateStreaks();
  }

  void updateAttendanceSummary() {
    final attendanceData = userAttendanceData.value;

    if (attendanceData != null) {
      final summary = attendanceData.getMonthlyAttendanceSummary(selectedMonth.value);

      _attendanceSummary.assignAll({
        'Present': summary['Present'] as int? ?? 0,
        'Absent': summary['Absent'] as int? ?? 0,
        'Holiday': summary['Holiday'] as int? ?? 0,
        'Late': summary['Late'] as int? ?? 0,
        'Excused': summary['Excused'] as int? ?? 0,
        'Not Applicable': summary['Not Applicable'] as int? ?? 0,
        'Working': summary['Working'] as int? ?? 0,
      });
    } else {
      _attendanceSummary.clear();
    }
  }

  void updateStreaks() {
    final attendanceData = userAttendanceData.value;
    if (attendanceData != null) {
      _streaks.assignAll(attendanceData.getStreaks('P'));
    } else {
      _streaks.clear();
    }
  }

  String streakToString(Map<String, dynamic> streak) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return 'Start: ${dateFormat.format(streak['start'] as DateTime)}, End: ${dateFormat.format(streak['end'] as DateTime)}, Length: ${streak['length']} days';
  }

  Map<String, double> get pieChartData {
    final attendanceData = userAttendanceData.value;
    return attendanceData?.getPieChartData() ?? {};
  }

  Map<String, int> get weeklyAttendanceData {
    final attendanceData = userAttendanceData.value;
    return attendanceData?.getWeeklyAttendanceData() ?? {};
  }

  double get consistency {
    final attendanceData = userAttendanceData.value;
    return attendanceData?.getAttendanceConsistency() ?? 0;
  }

  Map<String, int> get monthlyAttendanceData {
    final attendanceData = userAttendanceData.value;
    return attendanceData?.getMonthlyAttendanceData() ?? {};
  }
}

class StudentRanking {
  final UserModel student;
  final double percentage;

  StudentRanking({required this.student, required this.percentage});
}