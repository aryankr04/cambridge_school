import 'package:cambridge_school/app/modules/class_management/class_management_repositories.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../school_management/school_model.dart';
import '../../school_management/school_repository.dart';
import 'attendance_record_models.dart';
import 'attendance_record_repository.dart';

class AttendanceRecordController extends GetxController {
  //----------------------------------------------------------------------------
  // Static Data (Consider making this configurable, or injected)
  static const String schoolId = 'SCH00001';

  //----------------------------------------------------------------------------
  // Observables (Reactive Variables)
  final selectedDate = Rx<DateTime>(DateTime.now());
  final sections = RxList<SectionData>();
  final attendanceSummaries = RxList<ClassAttendanceSummary>();
  final employeeAttendanceSummary = Rx<EmployeeAttendanceSummary?>(null); // Allow null
  final isLoading = RxBool(false);
  final errorMessage = RxnString();

  //----------------------------------------------------------------------------
  // Repositories
  final FirestoreSchoolRepository schoolRepository;
  final ClassManagementRepository classManagementRepository;
  final FirestoreAttendanceRecordRepository attendanceRepository;

  //----------------------------------------------------------------------------
  // Constructor
  AttendanceRecordController({
    FirestoreSchoolRepository? schoolRepo,
    FirestoreAttendanceRecordRepository? attendanceRepo,
    ClassManagementRepository? classRepo
  })  : schoolRepository = schoolRepo ?? FirestoreSchoolRepository(),
        classManagementRepository = classRepo ?? ClassManagementRepository(),
        attendanceRepository =
            attendanceRepo ?? FirestoreAttendanceRecordRepository();

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
      final List<ClassData> classData =
      await classManagementRepository.fetchClassData(schoolId);

      List<SectionData> allSections = [];
      for (var classItem in classData) {
        for (var sectionName in classItem.sectionName) {
          allSections.add(SectionData(
            classId: classItem.classId,
            className: classItem.className,
            sectionName: sectionName,
          ));
        }
      }
      sections.assignAll(allSections);  // Use assignAll for RxList
        } catch (error) {
      errorMessage.value = 'Failed to load school sections: $error';
      print('Error fetching school sections: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchDailyAttendanceRecord() async {
    final DailyAttendanceRecord? dailyRecord =
    await attendanceRepository.getDailyAttendanceRecord(
      schoolId,
      selectedDate.value,
    );

    attendanceSummaries
        .assignAll(dailyRecord?.classAttendanceSummaries ?? []);
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
  String getFormattedSelectedDate() {
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(selectedDate.value);
  }

  // Helper getter for the screen (avoids needing to check for null in the UI)
  bool get isEmployeeAttendanceTaken => employeeAttendanceSummary.value != null;
}