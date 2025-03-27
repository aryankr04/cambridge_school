import 'package:cambridge_school/app/modules/class_management/class_repository.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:get/get.dart';

import '../../school_management/school_model.dart';
import '../../school_management/school_repository.dart';
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
  final employeeAttendanceSummary =
      Rx<EmployeeAttendanceSummary?>(null); // Allow null
  final isLoading = RxBool(false);
  final errorMessage = RxnString();

  //----------------------------------------------------------------------------
  // Repositories
  final SchoolRepository schoolRepository;
  final ClassRepository classRepository;
  final DailyAttendanceRecordRepository attendanceRecordRepository;

  //----------------------------------------------------------------------------
  // Constructor
  AttendanceRecordController(
      {SchoolRepository? schoolRepo,
      DailyAttendanceRecordRepository? attendanceRepo,
      ClassRepository? classRepo})
      : schoolRepository = schoolRepo ?? SchoolRepository(),
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
    final DailyAttendanceRecord? dailyRecord = await attendanceRecordRepository
        .getDailyAttendanceRecordByDate(selectedDate.value);

    attendanceSummaries.assignAll(dailyRecord?.classAttendanceSummaries ?? []);
    employeeAttendanceSummary.value = dailyRecord?.employeeAttendanceSummary;
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
      return ClassAttendanceSummary(
        className: className,
        sectionName: sectionName,
        markedBy: AttendanceTaker(uid: '', name: 'N/A', time: DateTime.now()),
        presents: 0,
        absents: 0,
      );
    }
  }

  //----------------------------------------------------------------------------
  // Utility Methods

  // Helper getter for the screen (avoids needing to check for null in the UI)
  bool get isEmployeeAttendanceTaken => employeeAttendanceSummary.value != null;
}
