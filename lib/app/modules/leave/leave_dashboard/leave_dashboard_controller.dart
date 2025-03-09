import 'package:cambridge_school/core/widgets/confirmation_dialog.dart';
import 'package:get/get.dart';

import '../apply_leave/apply_leave_controller.dart';
import '../leave_model.dart';
import '../leave_repository.dart';

class LeaveDashboardController extends GetxController {
  //----------------------------------------------------------------------------
  // Static Dummy Data (Replace with actual values)
  static const String className = "Class 5";
  static const String sectionName = "C";
  static const String schoolId = "SCH00001";
  static const String userId = "STU00001";

  //----------------------------------------------------------------------------
  // Observables
  final selectedMonth = DateTime.now().obs;
  final isAllMonths = false.obs;
  final isLoading = false.obs;

  //----------------------------------------------------------------------------
  //Leave count vars
  final totalLeaveApplied = 0.obs;
  final totalLeaveRejected = 0.obs;
  final totalLeaveApproved = 0.obs;
  final totalLeavePending = 0.obs;
  final leaveApprovalRate = 0.0.obs;
  final leaveRejectionRate = 0.0.obs;

  //----------------------------------------------------------------------------
  // Leave Data
  final userLeaves = <LeaveModel>[].obs;

  //----------------------------------------------------------------------------
  // Repository
  final LeaveRosterRepository _leaveRosterRepository = LeaveRosterRepository();

  @override
  void onInit() {
    super.onInit();
    fetchLeaveData();
  }

  //----------------------------------------------------------------------------
  //Data Fetching
  Future<void> fetchLeaveData() async {
    isLoading.value = true;
    try {
      List<LeaveRoster> leaveRosters;

      if (isAllMonths.value) {
        // Fetch all LeaveRosters for the class and section
        leaveRosters = await _leaveRosterRepository.getLeaveRostersByClassSection(
            schoolId, className, sectionName);

      } else {
        // Fetch LeaveRoster for the selected month
        final rosterId = _leaveRosterRepository.generateLeaveRosterId(
            className: className, sectionName: sectionName, month: selectedMonth.value);

        final leaveRoster = await _leaveRosterRepository.getLeaveRosterById(schoolId, rosterId);
        leaveRosters = leaveRoster != null ? [leaveRoster] : []; // Wrap in a list if not null
      }

      // Filter leaves by user ID and update userLeaves observable
      userLeaves.value = leaveRosters
          .expand((roster) => roster.leaves)
          .where((leave) => leave.applicantId == userId)
          .toList();

      // Calculate totals and rates
      calculateLeaveStats();
    } catch (e) {
      print('Error fetching leave data: $e');
      // Handle error (show snackbar, etc.)
    } finally {
      isLoading.value = false;
    }
  }

  //----------------------------------------------------------------------------
  // Helper function to calculate leave stats
  void calculateLeaveStats() {
    totalLeaveApplied.value = userLeaves.length;
    totalLeaveRejected.value = userLeaves.where((leave) => leave.status == "Rejected").length;
    totalLeaveApproved.value = userLeaves.where((leave) => leave.status == "Approved").length;
    totalLeavePending.value = userLeaves.where((leave) => leave.status == "Pending").length;

    if (totalLeaveApplied.value > 0) {
      leaveApprovalRate.value = (totalLeaveApproved.value / totalLeaveApplied.value) * 100;
      leaveRejectionRate.value = (totalLeaveRejected.value / totalLeaveApplied.value) * 100;
    } else {
      leaveApprovalRate.value = 0.0;
      leaveRejectionRate.value = 0.0;
    }
  }
  /// Deletes a leave application from Firestore.
  Future<void> deleteLeave(LeaveModel leave) async {
    MyConfirmationDialog.show(DialogAction.Delete, onConfirm:() async {try {

      DateTime now = DateTime.now();
      DateTime currentMonth = DateTime(now.year, now.month);
      String rosterId = _leaveRosterRepository.generateLeaveRosterId(
          className: className, sectionName: sectionName, month: currentMonth);

      await _leaveRosterRepository.removeLeaveFromRoster(
        schoolId: schoolId,
        rosterId: rosterId,
        leave: leave,
      );

      userLeaves.remove(leave); // Optimistically update the UI
      calculateLeaveStats(); // Recalculate the stats
      Get.snackbar('Success', 'Leave application deleted successfully!');
      fetchLeaveData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete leave application: $e');
      print('Error deleting leave application: $e');
    }} );
  }
  // Edit Functionality

  /// Navigates to the ApplyLeaveScreen with the leave data for editing.
  void editLeave(LeaveModel leave) {
    // Put the ApplyLeaveController
    Get.put(ApplyLeaveController());
    Get.toNamed('/apply-leave', arguments: leave);

    //Note: Make sure you have route defined as "/apply-leave"
    // e.g. GetPage(name: '/apply-leave', page: () => ApplyLeaveScreen()),
  }

  //----------------------------------------------------------------------------
  // Actions
  void setSelectedMonth(DateTime month) {
    selectedMonth.value = month;
    isAllMonths.value = false;
    fetchLeaveData();
  }

  void setAllMonths() {
    isAllMonths.value = true;
    fetchLeaveData();
  }
}