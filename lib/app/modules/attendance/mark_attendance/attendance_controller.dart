import 'package:cambridge_school/app/modules/attendance/attendance_record/attendance_record_models.dart';
import 'package:cambridge_school/app/modules/attendance/mark_attendance/user_attendance_model.dart';
import 'package:cambridge_school/app/modules/manage_school/controllers/dummy_shool_data.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../user_management/create_user/models/user_model.dart';
import '../../user_management/manage_user/repositories/roster_repository.dart';
import '../attendance_record/attendance_record_repository.dart';

class AttendanceController extends GetxController {
  final SchoolDummyData schoolDummyData = SchoolDummyData();
  final selectedDate = DateTime.now().obs;
  final String schoolId = 'SCH00001';
  final String markedBy = 'Mr. S.K Pandey';
  final selectedAttendanceFor = RxString('Class');
  final selectedClass = ('1').obs;
  final selectedSection = ('A').obs;
  final isLoading = false.obs;
  final users = <UserModel>[].obs;
  final Rxn<ClassRoster> classRoster = Rxn<ClassRoster>();
  final FirestoreRosterRepository rosterRepository =
      FirestoreRosterRepository();
  final isPresentAll = false.obs;
  final isAbsentAll = false.obs;
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
    users.close();
    isPresentAll.close();
    isAbsentAll.close();
    presentCount.close();
    absentCount.close();
    super.onClose();
  }

  void setShouldFetchUsersOnInit({bool shouldFetch = true}) {
    shouldFetchUsersOnInit.value = shouldFetch;
  }

  RxBool getIsPresent(UserModel user) {
    final attendance = getAttendanceStatus(user);
    return (attendance == 'P').obs;
  }

  String getAttendanceStatus(UserModel user) {
    try {
      print(user.userAttendance!.getAttendanceStatus(selectedDate.value));

      return user.userAttendance!.getAttendanceStatus(selectedDate.value);
    } catch (e) {
      print("Error fetching attendance for this date - $e");
      return 'N';
    }
  }

  Future<void> fetchUsers() async {
    isLoading(true);
    try {
      ClassRoster? fetchedClassRoster = await rosterRepository.getClassRoster(
          selectedClass.value, selectedSection.value, schoolId);

      if (fetchedClassRoster != null) {
        classRoster.value = fetchedClassRoster;
        users.value = fetchedClassRoster.studentList;
      } else {
        print(
            'Class roster not found for className: ${selectedClass.value}, sectionName: ${selectedSection.value}, schoolId: $schoolId');
        users.value = [];
      }

      final today = DateTime(selectedDate.value.year, selectedDate.value.month,
          selectedDate.value.day);
      for (var user in users) {
        user.userAttendance ??= UserAttendance.empty(
          academicPeriodStart: today,
          numberOfDays: 30,
        );
        user.userAttendance = user.userAttendance!.compact(today);
      }
      updateCounts();
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading(false);
    }
  }

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
      update();
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

  Future<void> updateAttendanceOnFirestore() async {
    isLoading(true);
    FirestoreAttendanceRecordRepository firestoreAttendanceRecordRepository =
    FirestoreAttendanceRecordRepository();
    try {
      //Update the roster at firestore
      if (selectedAttendanceFor.value == 'Class' && classRoster.value != null) {
        final userRosterDocRef = firestore
            .collection('rosters')
            .doc('class_roster')
            .collection('classes')
            .doc(classRoster.value?.id);

        final updatedData = {
          'studentList': users.map((user) => user.toMap()).toList(),
        };

        await userRosterDocRef.update(updatedData);
      } else {
        final rosterType = selectedAttendanceFor.value.toLowerCase();

        final userRosterDocRef = firestore
            .collection('rosters')
            .doc(rosterType)
            .collection('schools')
            .doc(schoolId);

        final updatedData = {
          'userList': users.map((user) => user.toMap()).toList(),
        };

        await userRosterDocRef.update(updatedData);
      }

      //After update roster  update daily attendace record at firestore

      final date = selectedDate.value;
      AttendanceTaker markedBy = AttendanceTaker(
          uid: schoolId, name: this.markedBy, time: DateTime.now()); //TODO CHANGE THIS

      ClassAttendanceSummary classSummary = ClassAttendanceSummary(
          className: selectedClass.value,
          sectionName: selectedSection.value,
          markedBy: markedBy,
          presents: presentCount.value,
          absents: absentCount.value);

      DailyAttendanceRecord? existingRecord =
      await firestoreAttendanceRecordRepository.getDailyAttendanceRecord(
          schoolId, date);

      if (existingRecord != null) {
        // Update existing record
        existingRecord.classAttendanceSummaries = [classSummary];
        await firestoreAttendanceRecordRepository
            .updateDailyAttendanceRecord(existingRecord);
        print('Daily Attendance Record updated successfully in Firestore');
      } else {
        // Create a new record
        DailyAttendanceRecord newRecord = DailyAttendanceRecord(
          schoolId: schoolId,
          date: date,
          classAttendanceSummaries: [classSummary],
        );

        await firestoreAttendanceRecordRepository.createDailyAttendanceRecord(
            newRecord);
        print('Daily Attendance Record created successfully in Firestore');
      }
    } catch (e) {
      print('Error updating attendance in Firestore: $e');
    } finally {
      isLoading(false);
    }
  }}
