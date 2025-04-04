import 'package:cambridge_school/app/modules/class_management/class_repository.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:get/get.dart';

import '../../school_management/school_model.dart';
import '../../school_management/school_repository.dart';
import '../../user_management/manage_user/models/roster_model.dart';
import 'attendance_record_models.dart';
import 'attendance_record_repository.dart';

class AttendanceRecordController extends GetxController {
  //----------------------------------------------------------------------------
  // Static Data (Consider making this configurable, or injected)
  static const String schoolId = 'dummy_school_1';

  //----------------------------------------------------------------------------
  // Observables (Reactive Variables)
  final selectedDate = Rx<DateTime>(DateTime.now());
  final sections = RxList<SectionData>();
  final attendanceSummaries = RxList<ClassAttendanceSummary>();
  final employeeAttendanceSummary = Rx<EmployeeAttendanceSummary?>(null);
  final classAttendanceSummary = Rx<RosterAttendanceSummary?>(null);
  final isLoading = RxBool(false);
  final errorMessage = RxnString();

  //----------------------------------------------------------------------------
  // Repositories
  final SchoolRepository schoolRepository;
  final ClassRepository classRepository;
  final DailyAttendanceRecordRepository attendanceRecordRepository;

  //----------------------------------------------------------------------------
  // Constructor
  AttendanceRecordController({
    SchoolRepository? schoolRepo,
    DailyAttendanceRecordRepository? attendanceRepo,
    ClassRepository? classRepo,
  })  : schoolRepository = schoolRepo ?? SchoolRepository(),
        classRepository = classRepo ?? ClassRepository(schoolId: schoolId),
        attendanceRecordRepository = attendanceRepo ??
            DailyAttendanceRecordRepository(schoolId: schoolId);

  //----------------------------------------------------------------------------
  // Lifecycle Methods
  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  //----------------------------------------------------------------------------
  // Data Fetching
  Future<void> _loadInitialData() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading(true);
    errorMessage(null);

    try {
      await _fetchSchoolSections();
      await _fetchDailyAttendanceRecord();
    } catch (e) {
      errorMessage.value = 'Failed to fetch data: $e';
      MySnackBar.showErrorSnackBar('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchSchoolSections() async {
    isLoading.value = true;
    try {
      sections.value = await schoolRepository.getSections(schoolId);
      final filteredSections = sections
          .where((section) => section.sectionName.trim().isNotEmpty)
          .toList();
      sections.value = filteredSections;
    } catch (error) {
      errorMessage.value = 'Failed to load school sections: $error';
      MySnackBar.showErrorSnackBar('Error fetching school sections: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchDailyAttendanceRecord() async {
    try {
      final DailyAttendanceRecord? dailyRecord =
      await attendanceRecordRepository.getDailyAttendanceRecordByDate(
          selectedDate.value);

      attendanceSummaries.assignAll(dailyRecord?.classAttendanceSummaries ??
          []); // Use assignAll for RxList
      employeeAttendanceSummary.value = dailyRecord?.employeeAttendanceSummary;
      classAttendanceSummary.value=calculateTotalAttendanceSummary();
    } catch (e) {
      errorMessage.value = 'Failed to load daily attendance record: $e';
      MySnackBar.showErrorSnackBar(
          'Error fetching daily attendance record: $e');
    }
  }

  //----------------------------------------------------------------------------
  // UI Interaction & Data Manipulation
  void updateSelectedDate(DateTime date) {
    selectedDate(date);
    fetchData();
  }

  bool isAttendanceTakenForSection(String className, String sectionName) {
    return attendanceSummaries.any((summary) =>
    summary.className == className && summary.sectionName == sectionName);
  }

  ClassAttendanceSummary getClassAttendanceSummary(
      String className, String sectionName) {
    try {
      return attendanceSummaries.firstWhere(
            (s) => s.className == className && s.sectionName == sectionName,
      );
    } catch (e) {
      //Provide default value
      return ClassAttendanceSummary(
          className: className,
          sectionName: sectionName,
          markedBy: [],
          rosterAttendanceSummary: RosterAttendanceSummary(
              presentCount: 0,
              absentCount: 0,
              holidayCount: 0,
              lateCount: 0,
              excusedCount: 0,
              notApplicableCount: 0,
              workingDaysCount: 0,
              presentPercentage: 0.0,
              absentPercentage: 0.0,
              holidayPercentage: 0.0,
              latePercentage: 0.0,
              excusedPercentage: 0.0,
              notApplicablePercentage: 0.0,
              workingDaysPercentage: 0.0));
    }
  }
// Calculate total attendance summary
  RosterAttendanceSummary calculateTotalAttendanceSummary() {
    int totalPresent = 0;
    int totalAbsent = 0;
    int totalHoliday = 0;
    int totalLate = 0;
    int totalExcused = 0;
    int totalNotApplicable = 0;
    int totalWorkingDays = 0;

    for (final summary in attendanceSummaries) {
      totalPresent += summary.rosterAttendanceSummary.presentCount;
      totalAbsent += summary.rosterAttendanceSummary.absentCount;
      totalHoliday += summary.rosterAttendanceSummary.holidayCount;
      totalLate += summary.rosterAttendanceSummary.lateCount;
      totalExcused += summary.rosterAttendanceSummary.excusedCount;
      totalNotApplicable += summary.rosterAttendanceSummary.notApplicableCount;
      totalWorkingDays += summary.rosterAttendanceSummary.workingDaysCount;
    }

    double presentPercentage = totalWorkingDays > 0 ? (totalPresent / totalWorkingDays) * 100 : 0.0;
    double absentPercentage = totalWorkingDays > 0 ? (totalAbsent / totalWorkingDays) * 100 : 0.0;
    double holidayPercentage = totalWorkingDays > 0 ? (totalHoliday / totalWorkingDays) * 100 : 0.0;
    double latePercentage = totalWorkingDays > 0 ? (totalLate / totalWorkingDays) * 100 : 0.0;
    double excusedPercentage = totalWorkingDays > 0 ? (totalExcused / totalWorkingDays) * 100 : 0.0;
    double notApplicablePercentage = totalWorkingDays > 0 ? (totalNotApplicable / totalWorkingDays) * 100 : 0.0;
    double workingDaysPercentage = totalWorkingDays > 0 ? 100.0 : 0.0;

    return RosterAttendanceSummary(
      presentCount: totalPresent,
      absentCount: totalAbsent,
      holidayCount: totalHoliday,
      lateCount: totalLate,
      excusedCount: totalExcused,
      notApplicableCount: totalNotApplicable,
      workingDaysCount: totalWorkingDays,
      presentPercentage: presentPercentage,
      absentPercentage: absentPercentage,
      holidayPercentage: holidayPercentage,
      latePercentage: latePercentage,
      excusedPercentage: excusedPercentage,
      notApplicablePercentage: notApplicablePercentage,
      workingDaysPercentage: workingDaysPercentage,
    );
  }


  //----------------------------------------------------------------------------
  // Utility Methods

  // Helper getter for the screen (avoids needing to check for null in the UI)
  bool get isEmployeeAttendanceTaken => employeeAttendanceSummary.value != null;
}