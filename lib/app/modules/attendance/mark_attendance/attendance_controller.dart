import 'package:cambridge_school/app/modules/attendance/attendance_record/attendance_record_models.dart';
import 'package:cambridge_school/app/modules/attendance/mark_attendance/user_attendance_model.dart';
import 'package:cambridge_school/app/modules/manage_school/controllers/dummy_shool_data.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../user_management/create_user/models/user_model.dart';
import '../../user_management/manage_user/repositories/roster_repository.dart';
import '../attendance_record/attendance_record_repository.dart';

class AttendanceController extends GetxController {
  final SchoolDummyData dummySchoolData = SchoolDummyData();
  final selectedDate = DateTime.now().obs;
  final String schoolId = 'SCH00001';
  final String attendanceTakerName = 'Mr. S.K Pandey'; // Changed variable name
  final selectedAttendanceFor = RxString('Class');
  final selectedClass = ('1').obs;
  final selectedSection = ('A').obs;
  final isLoading = false.obs;
  final isUpdatingAttendance = false.obs;
  final userList = <UserModel>[].obs; // More descriptive name
  final Rxn<ClassRoster> classRoster = Rxn<ClassRoster>();
  final Rxn<UserRoster> employeeRoster = Rxn<UserRoster>();
  final FirestoreRosterRepository rosterRepository =
  FirestoreRosterRepository();
  final isMarkAllPresent = false.obs; // More descriptive name
  final isMarkAllAbsent = false.obs; // More descriptive name
  final presentCount = 0.obs;
  final absentCount = 0.obs;
  final shouldFetchUsersOnInit = false.obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    selectedDate.close();
    selectedAttendanceFor.close();
    selectedClass.close();
    selectedSection.close();
    isLoading.close();
    userList.close();
    isMarkAllPresent.close();
    isMarkAllAbsent.close();
    presentCount.close();
    absentCount.close();
    super.onClose();
  }

  void setShouldFetchUsersOnInit({bool shouldFetch = true}) {
    shouldFetchUsersOnInit.value = shouldFetch;
  }

  RxBool isUserPresent(UserModel user) {
    final attendance = getUserAttendanceStatus(user);
    return (attendance == 'P').obs;
  }

  String getUserAttendanceStatus(UserModel user) {
    try {
      return user.userAttendance!.getAttendanceStatus(selectedDate.value);
    } catch (e) {
      print("Error fetching attendance for this date - $e");
      return 'N';
    }
  }

  Future<void> fetchUsers() async {
    isLoading(true);
    try {
      if (selectedAttendanceFor.value == 'Class') {
        await _fetchClassRoster();
      } else if (selectedAttendanceFor.value == 'Employee') {
        await _fetchEmployeeRoster();
      }

      _initializeUserAttendance();
      updateAttendanceCounts(); // Updated name for clarity
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchClassRoster() async {
    ClassRoster? fetchedClassRoster = await rosterRepository.getClassRoster(
        selectedClass.value, selectedSection.value, schoolId);

    if (fetchedClassRoster != null) {
      classRoster.value = fetchedClassRoster;
      userList.value = fetchedClassRoster.studentList; // Updated to userList
    } else {
      print(
          'Class roster not found for className: ${selectedClass.value}, sectionName: ${selectedSection.value}, schoolId: $schoolId');
      userList.value = []; // Updated to userList
    }
  }

  Future<void> _fetchEmployeeRoster() async {
    UserRoster? fetchedEmployeeRoster = await rosterRepository.getUserRoster(
        'employee', // Corrected 'Employee' to 'employee' to match roster type
        schoolId);

    if (fetchedEmployeeRoster != null) {
      employeeRoster.value = fetchedEmployeeRoster;
      userList.value = fetchedEmployeeRoster.userList; // Updated to userList
    } else {
      print('Employee roster not found for schoolId: $schoolId');
      userList.value = []; // Updated to userList
    }
  }

  void _initializeUserAttendance() {
    final today = DateTime(
        selectedDate.value.year, selectedDate.value.month, selectedDate.value.day);
    for (var user in userList) {
      user.userAttendance ??= UserAttendance.empty(
        academicPeriodStart: today,
        numberOfDays: 30,
      );
      user.userAttendance = user.userAttendance!.compact(today);
    }
  }

  void _updateAttendanceForAll(String status) {
    for (var user in userList) {
      updateUserAttendance(user, status, isAll: true);
    }
  }

  void markUserPresent(UserModel user) {
    updateUserAttendance(user, 'P');
  }

  void markUserAbsent(UserModel user) {
    updateUserAttendance(user, 'A');
  }

  void markAllUsersPresent() {
    if (!isMarkAllPresent.value) {
      _updateAttendanceForAll('P');
      isMarkAllPresent.value = true;
      isMarkAllAbsent.value = false;
    }
  }

  void markAllUsersAbsent() {
    if (!isMarkAllAbsent.value) {
      _updateAttendanceForAll('A');
      isMarkAllAbsent.value = true;
      isMarkAllPresent.value = false;
    }
  }

  void updateUserAttendance(UserModel user, String status, {bool isAll = false}) {
    try {
      final updatedAttendance =
      user.userAttendance!.updateAttendance(selectedDate.value, status);
      final updatedUser = user.copyWith(userAttendance: updatedAttendance);

      final index = userList.indexOf(user);
      if (index != -1) {
        userList[index] = updatedUser;
      }

      if (!isAll) {
        isMarkAllPresent.value = false;
        isMarkAllAbsent.value = false;
      }
      updateAttendanceCounts();
      update();
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  void updateAttendanceCounts() {
    presentCount.value = 0;
    absentCount.value = 0;

    for (var user in userList) {
      final status = getUserAttendanceStatus(user);
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

  Future<void> updateAttendanceOnFirestore() async {
    // MyFullScreenLoading.show(loadingText: 'Updating Attendance');
    FirestoreAttendanceRecordRepository firestoreAttendanceRecordRepository =
    FirestoreAttendanceRecordRepository();
    try {
      final rosterType = selectedAttendanceFor.value.toLowerCase();
      final userListMaps = userList.map((user) => user.toMap()).toList();

      // Update the roster at Firestore
      if (selectedAttendanceFor.value == 'Class' && classRoster.value != null) {
        await _updateClassRosterOnFirestore(userListMaps);
      } else {
        await _updateEmployeeRosterOnFirestore(userListMaps);
      }

      // After updating the roster, update the daily attendance record
      await _updateDailyAttendanceRecord(firestoreAttendanceRecordRepository);

    } catch (e) {
      print('Error updating attendance in Firestore: $e');
    } finally {
      // MyFullScreenLoading.hide();
    }
  }

  Future<void> _updateClassRosterOnFirestore(
      List<Map<String, dynamic>> userListMaps) async {
    final userRosterDocRef = firestore
        .collection('rosters')
        .doc('class_roster')
        .collection('classes')
        .doc(classRoster.value?.id);

    await userRosterDocRef.update({'studentList': userListMaps});
  }

  Future<void> _updateEmployeeRosterOnFirestore(
      List<Map<String, dynamic>> userListMaps) async {
    final userRosterDocRef = firestore
        .collection('rosters')
        .doc(selectedAttendanceFor.value.toLowerCase())
        .collection('schools')
        .doc(schoolId);

    await userRosterDocRef.update({'userList': userListMaps});
  }

  Future<void> _updateDailyAttendanceRecord(
      FirestoreAttendanceRecordRepository firestoreAttendanceRecordRepository) async {
    final date = selectedDate.value;
    final markedBy = AttendanceTaker(
        uid: schoolId, name: attendanceTakerName, time: DateTime.now()); // Updated variable name

    DailyAttendanceRecord? existingRecord =
    await firestoreAttendanceRecordRepository.getDailyAttendanceRecord(
        schoolId, date);

    DailyAttendanceRecord newRecord;

    if (selectedAttendanceFor.value == 'Class') {
      final classSummary = ClassAttendanceSummary(
          className: selectedClass.value,
          sectionName: selectedSection.value,
          markedBy: markedBy,
          presents: presentCount.value,
          absents: absentCount.value);

      if (existingRecord != null) {
        existingRecord.classAttendanceSummaries = [classSummary];
        existingRecord.employeeAttendanceSummary =
        null; //clear employee summary if any
      } else {
        newRecord = DailyAttendanceRecord(
          schoolId: schoolId,
          date: date,
          classAttendanceSummaries: [classSummary],
        );
        existingRecord = newRecord;
      }
    } else {
      final employeeSummary = EmployeeAttendanceSummary(
          markedBy: markedBy,
          presents: presentCount.value,
          absents: absentCount.value);

      if (existingRecord != null) {
        existingRecord.employeeAttendanceSummary = employeeSummary;
        existingRecord.classAttendanceSummaries =
        null; //clear class summary if any
      } else {
        newRecord = DailyAttendanceRecord(
          schoolId: schoolId,
          date: date,
          employeeAttendanceSummary: employeeSummary,
        );
        existingRecord = newRecord;
      }
    }
    if (existingRecord.classAttendanceSummaries == null &&
        existingRecord.employeeAttendanceSummary == null) {
      print("Existing record not found");
      return;
    }

    await firestoreAttendanceRecordRepository
        .updateDailyAttendanceRecord(existingRecord);
    print('Daily Attendance Record updated successfully in Firestore');
  }
}