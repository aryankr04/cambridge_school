import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants/enums/attendance_status.dart';
import '../../user_management/create_user/models/user_model.dart';
import '../../user_management/manage_user/repositories/user_roster_repository.dart';
import '../mark_attendance/user_attendance_model.dart';

class AttendanceReportController extends GetxController {
  //----------------------------------------------------------------------------
  // Static Data (Consider fetching these from user profile or settings)
  final RxString className = 'UKG'.obs;
  final RxString section = 'A'.obs;
  final RxString schoolId = 'SCH00001'.obs;
  final RxString userId = '4e693287-13ef-478d-a1f6-67eea7681663'.obs;

  //----------------------------------------------------------------------------
  // Observables (Reactive Variables)
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxList<UserModel> studentList = <UserModel>[].obs;
  final Rx<UserAttendance?> userAttendanceData = Rx<UserAttendance?>(null);
  final RxDouble averageClassAttendance = 0.0.obs;
  final RxList<StudentRanking> studentRankings = <StudentRanking>[].obs;

  // Summary Data (Derived from UserAttendance)
  final Rx<AttendanceData> _attendanceSummary = AttendanceData(
    present: 0,
    absent: 0,
    holiday: 0,
    late: 0,
    excused: 0,
    notApplicable: 0,
    workingDays: 0,
    presentPercentage: 0.0,
    absentPercentage: 0.0,
    holidayPercentage: 0.0,
    latePercentage: 0.0,
    excusedPercentage: 0.0,
    notApplicablePercentage: 0.0,
    workingPercentage: 0.0,
  ).obs;
  final RxList<Streak> _streaks = <Streak>[].obs;

  //----------------------------------------------------------------------------
  // Getters for Private Observables (Encapsulation)
  AttendanceData get attendanceSummary => _attendanceSummary.value;
  List<Streak> get streaks => _streaks;

  //----------------------------------------------------------------------------
  // Repository
  final UserRosterRepository userRosterRepository = UserRosterRepository(schoolId:'dummy_school_1');

  //----------------------------------------------------------------------------
  // Lifecycle Methods
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  //----------------------------------------------------------------------------
  // Data Loading
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await fetchClassRoster();
      calculateClassAttendance();
      rankStudentsByAttendance();
    } catch (e) {
      print('Error loading attendance data: $e');
      // Consider Get.snackbar or dialog to show user-friendly error.
      Get.snackbar('Error', 'Failed to load attendance data: $e');
      // Also log to Crashlytics or similar.
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClassRoster() async {
    // studentList.value = await rosterRepository.getClassRoster(
    //     className.value, section.value, schoolId.value);

    // Load user attendance data for the selected user
    if (studentList.isNotEmpty) {
      try {
        // Find the specific student and assign attendance
        userAttendanceData.value = studentList
            .firstWhere((student) => student.userId == userId.value)
            .userAttendance;
      } catch (e) {
        print('User with ID ${userId.value} not found in student list.');
        // Set to default attendance or null
        userAttendanceData.value = null;
      }
    } else {
      // Handle case if there is no student in the list
      userAttendanceData.value = null;
    }

    updateAttendanceSummary();
    updateStreaks();
  }

  //----------------------------------------------------------------------------
  // Data Processing and Calculations
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
        selectedMonth.value); // Or specify any month

    return summary.workingDays > 0 ? (summary.present / summary.workingDays) * 100 : 0;
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

        final absencesA = summaryA.absent;
        final absencesB = summaryB.absent;

        return (absencesB).compareTo(absencesA);
      });
  }

  //----------------------------------------------------------------------------
  // Data Manipulation & Updates
  void setSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    updateAttendanceSummary();
    updateStreaks();
  }

  void updateAttendanceSummary() {
    final attendanceData = userAttendanceData.value;

    if (attendanceData != null) {
      final summary =
      attendanceData.getMonthlyAttendanceSummary(selectedMonth.value);

      _attendanceSummary.value = summary;
    } else {
      _attendanceSummary.value = AttendanceData(
        present: 0,
        absent: 0,
        holiday: 0,
        late: 0,
        excused: 0,
        notApplicable: 0,
        workingDays: 0,
        presentPercentage: 0.0,
        absentPercentage: 0.0,
        holidayPercentage: 0.0,
        latePercentage: 0.0,
        excusedPercentage: 0.0,
        notApplicablePercentage: 0.0,
        workingPercentage: 0.0,
      );
    }
  }

  void updateStreaks() {
    final attendanceData = userAttendanceData.value;
    if (attendanceData != null) {
      _streaks.assignAll(attendanceData.getStreaks(AttendanceStatus.present).map((streakMap) => Streak.fromMap(streakMap)).toList());
    } else {
      _streaks.clear();
    }
  }

  //----------------------------------------------------------------------------
  // Data Formatting (UI Helper Methods)
  String streakToString(Streak streak) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return 'Start: ${dateFormat.format(streak.start)}, End: ${dateFormat.format(streak.end)}, Length: ${streak.length} days';
  }

  //----------------------------------------------------------------------------
  // Getters for Charts and UI Components (Derived Data)
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

//------------------------------------------------------------------------------
// Helper Classes/Models (Optional, but improves code organization)
class StudentRanking {
  final UserModel student;
  final double percentage;

  StudentRanking({required this.student, required this.percentage});
}

class Streak {
  final DateTime start;
  final DateTime end;
  final int length;

  Streak({required this.start, required this.end, required this.length});

  factory Streak.fromMap(Map<String, dynamic> map) {
    return Streak(
      start: map['start'] as DateTime,
      end: map['end'] as DateTime,
      length: map['length'] as int,
    );
  }
}