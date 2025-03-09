
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/async.dart';

import '../leave_model.dart';
import '../leave_repository.dart';

class ApplyLeaveController extends GetxController {
  //----------------------------------------------------------------------------
  // Observables (Reactive Variables)
  final reasonController = TextEditingController();
  final selectedLeaveType = Rx<String?>(null);
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final leave = Rx<LeaveModel?>(null);

  //----------------------------------------------------------------------------
  // Constants
  final className = RxString('Class 5');
  final sectionName = RxString('C');
  final schoolId = RxString('SCH00001');
  final applicantName = RxString('Aryan');
  final applicantId = RxString('STU00001');

  //----------------------------------------------------------------------------
  // Repository
  late final LeaveRosterRepository leaveRosterRepository;

  //----------------------------------------------------------------------------
  // Lifecycle Methods
  @override
  void onInit() {
    super.onInit();
    leaveRosterRepository = LeaveRosterRepository();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  // Method to set the leave
  void setLeave(LeaveModel? leaveModel) {
    leave.value = leaveModel;
    if (leaveModel != null) {
      selectedLeaveType.value = leaveModel.leaveType;
      startDate.value = leaveModel.startDate;
      endDate.value = leaveModel.endDate;
      reasonController.text = leaveModel.reason;
    } else {
      // Reset fields if leaveModel is null
      selectedLeaveType.value = '';
      startDate.value = null;
      endDate.value = null;
      reasonController.clear();
    }
  }
  //----------------------------------------------------------------------------
  // Helper Methods (Private)

  /// Validates the input fields before submitting the leave application.
  bool _validateInputs() {
    if (selectedLeaveType.value == null || selectedLeaveType.value!.isEmpty) {
      Get.snackbar('Error', 'Please select a leave type.');
      return false;
    }
    if (startDate.value == null) {
      Get.snackbar('Error', 'Please select a start date.');
      return false;
    }
    if (endDate.value == null) {
      Get.snackbar('Error', 'Please select an end date.');
      return false;
    }
    if (startDate.value!.isAfter(endDate.value!)) {
      Get.snackbar('Error', 'Start date cannot be after end date.');
      return false;
    }
    if (className.value.isEmpty) {
      Get.snackbar('Error', 'Class Name is required.');
      return false;
    }
    return true;
  }

  /// Generates a unique ID for the leave application using `nanoid`.
  Future<String> _generateLeaveId() async {
    return await nanoid(12); // Use async nanoid
  }

  /// Resets the form fields after a successful submission or cancellation.
  void _resetForm() {
    selectedLeaveType.value = null;
    startDate.value = null;
    endDate.value = null;
    reasonController.clear();
  }

  //----------------------------------------------------------------------------
  // Main Functionality

  /// Adds a new leave application to Firestore.
  Future<void> addLeaveToFirestore({String? leaveIdToUpdate}) async {
    MyFullScreenLoading.show();
    if (!_validateInputs()) {
      return;
    }

    try {
      final leaveId = leaveIdToUpdate ?? await _generateLeaveId();

      final newLeave = LeaveModel(
        id: leaveId,
        applicantId: applicantId.value,
        applicantName: applicantName.value,
        leaveType: selectedLeaveType.value!,
        startDate: startDate.value!,
        endDate: endDate.value!,
        reason: reasonController.text.trim(),
        appliedAt: DateTime.now(),
      );

      DateTime now = DateTime.now();
      DateTime currentMonth = DateTime(now.year, now.month);
      String rosterId = leaveRosterRepository.generateLeaveRosterId(
          className: className.value, sectionName: sectionName.value, month: currentMonth);

      await leaveRosterRepository.addLeaveToRoster(
        schoolId: schoolId.value,
        rosterId: rosterId,
        leave: newLeave,
        className: className.value,
        sectionName: sectionName.value,
        month: currentMonth

      );

      //Get.snackbar('Success', 'Leave application submitted successfully!');
      _resetForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit leave application: $e');
      print('Error submitting leave application: $e');
    }
    MyFullScreenLoading.hide();
  }
}