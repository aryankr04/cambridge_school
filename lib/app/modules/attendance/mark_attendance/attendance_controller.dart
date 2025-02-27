import 'package:cambridge_school/app/modules/attendance/mark_attendance/user_attendance_model.dart';
import 'package:cambridge_school/app/modules/manage_school/controllers/dummy_shool_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../user_management/create_user/models/user_model.dart';
import '../../user_management/manage_user/repositories/roster_repository.dart';

class AttendanceController extends GetxController {
  final SchoolDummyData schoolDummyData = SchoolDummyData();
  final selectedDate = DateTime.now().obs;
  final selectedAttendanceFor = RxString('Class');
  final selectedClass = RxString('1');
  final selectedSection = RxString('A');
  final isLoading = false.obs;
  final users = <UserModel>[].obs;
  final FirestoreRosterRepository rosterRepository =
      FirestoreRosterRepository();

  final isPresentAll = false.obs;
  final isAbsentAll = false.obs;

  //Counts
  final presentCount = 0.obs;
  final absentCount = 0.obs;

  // Flag to track if initial data load is needed
  RxBool shouldFetchUsersOnInit = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Call fetchUsers only if needed
  }

  void setShouldFetchUsersOnInit({bool shouldFetch = true}) {
    shouldFetchUsersOnInit.value = shouldFetch;
  }

  @override
  void onClose() {
    // Reset values when the controller is disposed
    selectedDate.close();
    selectedAttendanceFor.close();
    selectedClass.close();
    selectedSection.close();
    isLoading.close();
    users.close();
    isPresentAll.close();
    isAbsentAll.close();
    presentCount.close();
    absentCount.close();
    super.onClose();
  }

  // Computed property for attendance status
  RxBool getIsPresent(UserModel user) {
    final attendance = getAttendanceStatus(user);
    return (attendance == 'P').obs;
  }

  String getAttendanceStatus(UserModel user) {
    try {
      return user.userAttendance!.getAttendanceStatus(selectedDate.value);
    } catch (e) {
      print("Error fetching attendance for this date - $e");
      return 'N'; // Return 'N' (Not Applicable) as default or handle the error
    }
  }

  Future<void> fetchUsers() async {
    isLoading(true);
    try {
      String schoolId = 'SCH00001';
      if (selectedAttendanceFor.value == 'Class') {
        users.value = await rosterRepository.getAllUsersInClassRoster(
            selectedClass.value, selectedSection.value, schoolId);
      } else {
        users.value = await rosterRepository.getAllUsersInUserRoster(
            selectedAttendanceFor.value.toLowerCase(), schoolId);
      }

      // Initialize UserAttendance for new users and compact existing ones
      final today = DateTime(selectedDate.value.year, selectedDate.value.month,
          selectedDate.value.day); // strip out the time (only date)
      for (var user in users) {
        if (user.userAttendance == null) {
          user.userAttendance = UserAttendance.empty(
            academicPeriodStart: today,
            userId: user.userId,
            name: user.fullName ?? '',
            numberOfDays: 30,
          );
        } else {
          user.userAttendance =
              user.userAttendance!.compact(today); // Compact the UserAttendance
        }
      }
      updateCounts();
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error appropriately (show snackbar, etc.)
    } finally {
      isLoading(false);
    }
  }

  //Method to fetch class roster
  Future<void> fetchClassRoster() async {
    isLoading(true);
    try {
      // Fetch students from Class Roster
      users.value = await rosterRepository.getAllUsersInClassRoster(
          selectedClass.value, selectedSection.value, 'cambridge_school');
      final today = DateTime(selectedDate.value.year, selectedDate.value.month,
          selectedDate.value.day); // strip out the time (only date)
      for (var user in users) {
        if (user.userAttendance == null) {
          user.userAttendance = UserAttendance.empty(
            academicPeriodStart: today,
            userId: user.userId,
            name: user.fullName ?? '',
            numberOfDays: 30,
          );
        } else {
          user.userAttendance =
              user.userAttendance!.compact(today); // Compact the UserAttendance
        }
      }
      updateCounts();
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error appropriately
    } finally {
      isLoading(false);
    }
  }

  //Centralized update logic
  void _updateAll(String status) {
    for (var user in users) {
      updateAttendance(user, status, isAll: true);
    }
  }

  void markPresent(UserModel user) {
    updateAttendance(user, 'P');
  }

  void markAbsent(UserModel user) {
    updateAttendance(user, 'A');
  }

  //Refactored method for markAllPresent and markAllAbsent
  void markAllPresent() {
    if (!isPresentAll.value) {
      _updateAll('P');
      isPresentAll.value = true;
      isAbsentAll.value = false;
    }
  }

  void markAllAbsent() {
    if (!isAbsentAll.value) {
      _updateAll('A');
      isAbsentAll.value = true;
      isPresentAll.value = false;
    }
  }

  void updateAttendance(UserModel user, String status, {bool isAll = false}) {
    try {
      final updatedAttendance =
          user.userAttendance!.updateAttendance(selectedDate.value, status);
      final updatedUser = user.copyWith(userAttendance: updatedAttendance);

      final index = users.indexOf(user);
      if (index != -1) {
        users[index] = updatedUser;
      }

      if (!isAll) {
        isPresentAll.value = false;
        isAbsentAll.value = false;
      }
      updateCounts();
      update(); // Trigger UI update
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  void updateCounts() {
    presentCount.value = 0;
    absentCount.value = 0;

    for (var user in users) {
      final status = getAttendanceStatus(user);
      if (status == 'P') {
        presentCount.value++;
      } else if (status == 'A') {
        absentCount.value++;
      }
    }
  }

  String getFormattedSelectedDate() {
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(selectedDate.value);
  }
}
