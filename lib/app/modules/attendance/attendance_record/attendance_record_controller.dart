import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../manage_school/models/school_model.dart';
import '../../manage_school/repositories/school_repositorie.dart';
import 'attendance_record_models.dart';
import 'attendance_record_repository.dart';

/// [AttendanceRecordController] manages attendance records.
class AttendanceRecordController extends GetxController {
  static const String schoolId = 'SCH00001';
  final selectedDate = Rx<DateTime>(DateTime.now());
  final selectedAttendanceFor = RxString('Class');
  final sections = RxList<SectionData>();
  final attendanceSummaries = RxList<ClassAttendanceSummary>();
  final isLoading = RxBool(false);
  final errorMessage = RxnString();
  final FirestoreSchoolRepository schoolRepository;
  final FirestoreAttendanceRecordRepository attendanceRepository;

  AttendanceRecordController({
    FirestoreSchoolRepository? schoolRepo,
    FirestoreAttendanceRecordRepository? attendanceRepo,
  })  : schoolRepository = schoolRepo ?? FirestoreSchoolRepository(),
        attendanceRepository =
            attendanceRepo ?? FirestoreAttendanceRecordRepository();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  /// Loads initial data.
  Future<void> _loadInitialData() async {
    await fetchData();
  }

  /// Fetches data, including school sections and attendance summaries.
  Future<void> fetchData() async {
    isLoading(true);
    errorMessage(null);

    try {
      await Future.wait([
        _fetchSchoolSections(),
        _fetchAttendanceSummaries(),
      ]);
    } catch (error) {
      errorMessage(error.toString());
      print('Error during fetchData: $error');
    } finally {
      isLoading(false);
    }
  }

  /// Fetches school sections from Firestore.
  Future<void> _fetchSchoolSections() async {
    try {
      final SchoolModel? school =
          await schoolRepository.getSchoolById(schoolId);
      if (school != null) {
        sections.assignAll(school.sections);
      } else {
        errorMessage('School not found');
      }
    } catch (error) {
      errorMessage('Failed to load school sections: $error');
      print('Error fetching school sections: $error');
    }
  }

  /// Fetches attendance summaries for the selected date from Firestore.
  Future<void> _fetchAttendanceSummaries() async {
    try {
      final DailyAttendanceRecord? dailyRecord =
          await attendanceRepository.getDailyAttendanceRecord(
        schoolId,
        selectedDate.value,
      );
      attendanceSummaries
          .assignAll(dailyRecord?.classAttendanceSummaries ?? []);
    } catch (error) {
      errorMessage('Failed to load attendance summaries: $error');
      print('Error fetching attendance summaries: $error');
    }
  }

  bool isAttendanceTakenForSection(String className, String sectionName) {
    return attendanceSummaries.any(
      (summary) =>
          summary.className == className && summary.sectionName == sectionName,
    );
  }

  void updateSelectedDate(DateTime date) {
    selectedDate(date);
    _fetchAttendanceSummaries();
  }

  /// Fetches users based on the selected user type (Class, User).
  Future<void> fetchUsers() async {
    print('Fetching users of type: ${selectedAttendanceFor.value}');
  }

  /// Retrieves the attendance summary for a specific class and section, providing a default summary if none exists.
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
  String getFormattedSelectedDate() {
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(selectedDate.value);
  }
}
