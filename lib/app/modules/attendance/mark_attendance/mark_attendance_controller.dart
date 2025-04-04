import 'package:cambridge_school/app/modules/attendance/attendance_record/attendance_record_models.dart';
import 'package:cambridge_school/app/modules/attendance/mark_attendance/user_attendance_model.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/attendance_status.dart';
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

import '../../user_management/create_user/models/user_model.dart';
import '../../user_management/manage_user/repositories/user_roster_repository.dart';
import '../attendance_record/attendance_record_repository.dart';

class MarkAttendanceController extends GetxController {
  final String schoolId = 'dummy_school_1';

  final selectedDate = DateTime.now().obs;
  final attendanceType = RxString('Class');
  final isClassAttendance = true.obs;

  final selectedClass = ('Class 1').obs;
  final selectedSection = ('A').obs;

  final isLoading = false.obs;
  final isUpdatingAttendance = false.obs;

  final selectedAllStatus = Rxn<AttendanceStatus>();

  final studentCount = 0.obs;
  final absentCount = 0.obs;

  final shouldFetchRosterOnInit = false.obs;
  final Rxn<UserRoster> userRoster = Rxn<UserRoster>();
  final Rxn<RosterAttendanceSummary> classAttendanceSummary =
      Rxn<RosterAttendanceSummary>();

  final String attendanceTakerName = 'Mr. S.K Pandey';

  final UserRosterRepository userRosterRepository =
      UserRosterRepository(schoolId: 'dummy_school_1');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    if (shouldFetchRosterOnInit.value) {
      loadRosterData();
    }
  }

  @override
  void onClose() {
    selectedDate.close();
    attendanceType.close();
    selectedClass.close();
    selectedSection.close();
    isClassAttendance.close();
    isUpdatingAttendance.close();
    studentCount.close();
    absentCount.close();
    shouldFetchRosterOnInit.close();
    userRoster.close();
    classAttendanceSummary.close();
    super.onClose();
  }

  void setShouldFetchRosterOnInit({bool shouldFetch = true}) {
    shouldFetchRosterOnInit.value = shouldFetch;
  }

  Future<void> loadRosterData() async {
    isLoading.value = true;
    try {
      if (isClassAttendance.value) {
        userRoster.value = await userRosterRepository.getClassRoster(
            className: selectedClass.value,
            sectionName: selectedSection.value,
            schoolId: schoolId);
        refreshAttendanceSummary();
      } else {
        userRoster.value =
            await userRosterRepository.getEmployeeRoster(schoolId);
        refreshAttendanceSummary();
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error loading roster: $e');
    } finally {
      isLoading.value = false;
    }
  }

  AttendanceStatus getAttendanceStatus(UserModel user) {
    if (user.userAttendance == null) {
      return AttendanceStatus.notApplicable;
    }
    return user.userAttendance!.getAttendanceStatusForDate(selectedDate.value);
  }

  void updateAttendanceStatus(UserModel user, AttendanceStatus status) {
    user.userAttendance ??= UserAttendance.createEmptyRecord(
      academicPeriodStartDate: selectedDate.value,
      numberOfDays: 365,
    );
    user.userAttendance = user.userAttendance!
        .updateAttendanceForDate(selectedDate.value, status);
    refreshAttendanceSummary();
  }

  void markAllAttendance() {
    for (UserModel user in userRoster.value!.userList) {
      updateAttendanceStatus(
          user, selectedAllStatus.value ?? AttendanceStatus.present);
    }

    userRoster.refresh();

    refreshAttendanceSummary();
  }

  void isAllMarkAttendance() {
    if (userRoster.value == null) {
      selectedAllStatus.value = null;
      return;
    }

    AttendanceStatus? firstAttendanceStatus;
    bool allSame = true;

    for (UserModel user in userRoster.value!.userList) {
      if (user.userAttendance == null ||
          user.userAttendance!.attendanceString.isEmpty) {
        allSame = false;
        break;
      }

      AttendanceStatus currentStatus = getAttendanceStatus(user);

      if (firstAttendanceStatus == null) {
        firstAttendanceStatus = currentStatus;
      } else if (currentStatus != firstAttendanceStatus) {
        allSame = false;
        break;
      }
    }

    if (allSame && firstAttendanceStatus != null) {
      selectedAllStatus.value = firstAttendanceStatus;
    } else {
      selectedAllStatus.value = null;
    }
  }

  void refreshAttendanceSummary() {
    classAttendanceSummary.value =
        userRoster.value!.calculateAttendanceDataForDate(selectedDate.value);
  }

  Future<void> saveAttendanceData() async {
    MyFullScreenLoading.show(loadingText: 'Updating Attendance');

    DailyAttendanceRecordRepository attendanceRecordRepository =
        DailyAttendanceRecordRepository(schoolId: schoolId);

    try {
      if (attendanceType.value == 'Class' && userRoster.value != null) {
        await userRosterRepository.updateUserRoster(userRoster.value!);
      } else {
        await userRosterRepository.updateUserRoster(userRoster.value!);
      }

      await _updateDailyAttendanceRecord(attendanceRecordRepository);

      MySnackBar.showSuccessSnackBar('Attendance updated successfully!');
    } catch (e) {
      MySnackBar.showErrorSnackBar(
          'Error updating attendance in Firestore: $e');
    } finally {
      MyFullScreenLoading.hide();
    }
  }

  Future<void> _updateDailyAttendanceRecord(
      DailyAttendanceRecordRepository attendanceRecordRepository) async {
    final date = DateTime(selectedDate.value.year, selectedDate.value.month,
        selectedDate.value.day);
    final AttendanceTaker newMarker = AttendanceTaker(
      uid: schoolId,
      name: attendanceTakerName,
      time: DateTime.now(),
    );

    try {
      DailyAttendanceRecord? existingRecord =
          await attendanceRecordRepository.getDailyAttendanceRecordByDate(date);

      final recordId = nanoid(16);

      if (isClassAttendance.value) {
        // Create new class summary
        final newClassSummary = ClassAttendanceSummary(
          className: selectedClass.value,
          sectionName: selectedSection.value,
          markedBy: [newMarker],
          rosterAttendanceSummary: classAttendanceSummary.value!,
        );

        if (existingRecord != null) {
          // Check if record already exists for this class & section
          final existingSummaries =
              existingRecord.classAttendanceSummaries ?? [];

          final index = existingSummaries.indexWhere((summary) =>
              summary.className == selectedClass.value &&
              summary.sectionName == selectedSection.value);

          if (index != -1) {
            final oldSummary = existingSummaries[index];

            // Add to markedBy only if the current uid is not already present
            final alreadyMarked =
                oldSummary.markedBy.any((taker) => taker.uid == newMarker.uid);
            oldSummary.markedBy.add(newMarker);

            // Update the summary
            existingSummaries[index] = ClassAttendanceSummary(
              className: oldSummary.className,
              sectionName: oldSummary.sectionName,
              markedBy: oldSummary.markedBy,
              rosterAttendanceSummary: newClassSummary.rosterAttendanceSummary,
            );
          } else {
            existingSummaries.add(newClassSummary);
          }

          existingRecord.classAttendanceSummaries = existingSummaries;
          await attendanceRecordRepository
              .updateDailyAttendanceRecord(existingRecord);

          MySnackBar.showSuccessSnackBar(
              'Daily Attendance Record updated successfully');
        } else {
          final newRecord = DailyAttendanceRecord(
            id: recordId,
            date: date,
            classAttendanceSummaries: [newClassSummary],
          );

          await attendanceRecordRepository.addDailyAttendanceRecord(newRecord);
          MySnackBar.showSuccessSnackBar(
              'Daily Attendance Record added successfully');
        }
      } else {
        // Employee attendance
        final newEmployeeSummary = EmployeeAttendanceSummary(
          markedBy: [newMarker],
          rosterAttendanceSummary: classAttendanceSummary.value!,
        );

        if (existingRecord != null) {
          final oldSummary = existingRecord.employeeAttendanceSummary;

          if (oldSummary != null) {
            final alreadyMarked =
                oldSummary.markedBy.any((taker) => taker.uid == newMarker.uid);
            if (!alreadyMarked) {}
            oldSummary.markedBy.add(newMarker);

            existingRecord.employeeAttendanceSummary =
                EmployeeAttendanceSummary(
              markedBy: oldSummary.markedBy,
              rosterAttendanceSummary:
                  newEmployeeSummary.rosterAttendanceSummary,
            );
          } else {
            existingRecord.employeeAttendanceSummary = newEmployeeSummary;
          }

          await attendanceRecordRepository
              .updateDailyAttendanceRecord(existingRecord);
          MySnackBar.showSuccessSnackBar(
              'Daily Attendance Record updated successfully');
        } else {
          final newRecord = DailyAttendanceRecord(
            id: recordId,
            date: date,
            employeeAttendanceSummary: newEmployeeSummary,
          );
          await attendanceRecordRepository.addDailyAttendanceRecord(newRecord);
          MySnackBar.showSuccessSnackBar(
              'Daily Attendance Record added successfully');
        }
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar(
          'Error updating Daily Attendance Record: $e');
    }
  }
}
