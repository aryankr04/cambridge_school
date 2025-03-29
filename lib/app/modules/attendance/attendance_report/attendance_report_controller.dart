import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants/enums/attendance_status.dart';
import '../../user_management/manage_user/repositories/user_roster_repository.dart';
import '../mark_attendance/user_attendance_model.dart';

class AttendanceReportController extends GetxController {
  //---------------------------- Constants ----------------------------//
  final String defaultSchoolId = 'dummy_school_1';

  //---------------------------- Observables ----------------------------//
  // --- Static Data ---
  final RxString className = 'Pre-Nursery'.obs;
  final RxString section = 'A'.obs;
  final RxString userId = 'STU00001'.obs;

  // --- UI State ---
  final RxBool isLoading = false.obs;

  // --- Filter Dialog ---
  final RxBool isMonthly = true.obs;
  final RxString selectedFilterType = 'Monthly'.obs; //Monthly Yearly Custom
  final RxString selectedYear = ''.obs;
  final RxString selectedMonth = ''.obs;

  final Rx<DateTime> selectedStartDate =
      DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  final Rx<DateTime> selectedEndDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).obs;

  RxList<String> yearList = <String>[].obs;
  RxList<String> monthList = <String>[].obs;

  final selectedStatus = AttendanceStatus.present.obs;

  // --- Attendance Calendar---
  final Rx<DateTime> selectedMonthForAttendanceCalendar = DateTime.now().obs;
  final Rx<DateTime> endDateOfAttendance = DateTime.now().obs;

  // --- Data ---
  final Rx<UserRoster?> userRoster = Rx<UserRoster?>(null);
  final Rx<UserAttendance?> userAttendanceData = Rx<UserAttendance?>(null);
  final Rx<RosterAverageAttendanceSummary?> averageAttendanceSummary =
      Rx<RosterAverageAttendanceSummary?>(null);
  final Rxn<UserAttendanceSummary> userAttendanceSummary =
      Rxn<UserAttendanceSummary>();

  final Rx<RosterAverageAttendanceSummary?> rosterAverageAttendanceSummary =
      Rx<RosterAverageAttendanceSummary?>(null);

  //---------------------------- Repository ----------------------------//
  final UserRosterRepository userRosterRepository = UserRosterRepository(
    schoolId: 'dummy_school_1',
  );

  //---------------------------- Lifecycle Methods ----------------------------//
  @override
  void onInit() {
    super.onInit();
    loadData(); // Load data immediately when the controller is initialized.
  }

  //---------------------------- Data Loading ----------------------------//
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await fetchClassRoster();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClassRoster() async {
    try {
      userRoster.value = await userRosterRepository.getClassRoster(
        className: className.value,
        sectionName: section.value,
        schoolId: defaultSchoolId,
      );

      if (userRoster.value != null) {
        final user = userRoster.value!.userList.firstWhere(
          (user) => user.userId == userId.value,
        );

        userAttendanceData.value = user.userAttendance;

        if (userAttendanceData.value != null) {
          yearList.clear();
          monthList.clear();
          if (userRoster.value != null) {
            if (userAttendanceData.value != null) {
              yearList.value = userAttendanceData.value!.getListOfYears();
              monthList.value = userAttendanceData.value!.getListOfMonths();
              endDateOfAttendance.value =
                  userAttendanceData.value!.getEndDateOfAttendance();
              selectedStartDate.value =
                  userAttendanceData.value!.academicPeriodStart;
            }
          }
          updateAttendanceSummary();
          updateRosterAverageAttendanceSummary();
        }
      }
    } catch (e) {
      print('❌ Error fetching class roster: $e');
    }
  }

  //---------------------------- Data Processing ----------------------------//

  void updateAttendanceSummary() {
    if (userAttendanceData.value != null) {
      userAttendanceSummary.value = userAttendanceData.value
          ?.calculateAttendanceSummaryInDateRange(
              startDate: selectedStartDate.value,
              endDate: selectedEndDate.value);
    }
  }

  void updateRosterAverageAttendanceSummary() {
    if (userRoster.value != null) {
      rosterAverageAttendanceSummary.value = userRoster.value
          ?.calculateAverageAttendanceInDateRange(
              selectedStartDate.value, selectedEndDate.value);
    }
  }

  void updateDateRange() {
    if (selectedFilterType.value == 'Monthly') {
      if (selectedMonth.value.isNotEmpty) {
        try {
          final parts = selectedMonth.value.split(' ');
          final monthName = parts[0];
          final year = int.parse(parts[1]);
          final month =
              _getMonthNumber(monthName); // Helper function to get month number

          // Set start date to the first day of the selected month
          selectedStartDate.value = DateTime(year, month, 1);

          // Set end date to the last day of the selected month
          selectedEndDate.value =
              DateTime(year, month + 1, 0); // corrected line
        } catch (e) {
          print('Error parsing month: $e');
          // Handle the error appropriately (e.g., show an error message)
        }
      }
    } else if (selectedFilterType.value == 'Yearly') {
      if (selectedYear.value.isNotEmpty) {
        try {
          final year = int.parse(selectedYear.value);

          // Set start date to the first day of the year
          selectedStartDate.value = DateTime(year, 1, 1);

          // Set end date to the last day of the year
          selectedEndDate.value = DateTime(year, 12, 31);
        } catch (e) {
          print('Error parsing year: $e');
          // Handle the error appropriately (e.g., show an error message)
        }
      }
    }
    updateAttendanceSummary();
  }

  // Helper function to convert month name to month number (1-12)
  int _getMonthNumber(String monthName) {
    switch (monthName) {
      case 'January':
        return 1;
      case 'February':
        return 2;
      case 'March':
        return 3;
      case 'April':
        return 4;
      case 'May':
        return 5;
      case 'June':
        return 6;
      case 'July':
        return 7;
      case 'August':
        return 8;
      case 'September':
        return 9;
      case 'October':
        return 10;
      case 'November':
        return 11;
      case 'December':
        return 12;
      default:
        return 1; // Default to January if month name is invalid
    }
  }

  //---------------------------- Data Manipulation ----------------------------//
  void setSelectedMonth(DateTime newMonth) {
    selectedMonthForAttendanceCalendar.value = newMonth;
    selectedMonth.value = '';
    selectedYear.value = '';
    selectedStartDate.value = DateTime(
        selectedMonthForAttendanceCalendar.value.year,
        selectedMonthForAttendanceCalendar.value.month,
        1);
    selectedEndDate.value = DateTime(
        selectedMonthForAttendanceCalendar.value.year,
        selectedMonthForAttendanceCalendar.value.month + 1,
        0);
  }
}
