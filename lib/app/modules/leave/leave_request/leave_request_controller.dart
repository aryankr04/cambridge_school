import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:get/get.dart';
import '../leave_model.dart';
import '../leave_repository.dart';

class LeaveRequestController extends GetxController {
  //----------------------------------------------------------------------------
  // Static Dummy Data (Replace with actual values)
  static const String className = "Class 5";
  static const String sectionName = "C";
  static const String schoolId = "SCH00001";
  static const String approverId = "STU00001";
  static const String approverName = "Aryan Kumar";

  //----------------------------------------------------------------------------
  // Observables
  final selectedMonth = DateTime.now().obs;
  final isAllMonths = false.obs;
  final isLoading = false.obs;

  //----------------------------------------------------------------------------
  //Leave count vars
  final totalLeaves = 0.obs;
  final totalLeaveRejected = 0.obs;
  final totalLeaveApproved = 0.obs;
  final totalLeavePending = 0.obs;
  final leaveApprovalRate = 0.0.obs;
  final leaveRejectionRate = 0.0.obs;

  //----------------------------------------------------------------------------
  // Leave Data
  final userLeaves = <LeaveModel>[].obs;
  final filteredLeaves =
      <LeaveModel>[].obs; // New: For displaying filtered results

  //----------------------------------------------------------------------------
  // Filtering and Sorting Options
  final selectedStatusFilter = Rx<String?>(null); // Null means no filter
  final selectedSortOption =
  Rx<SortOption>(SortOption.appliedDateDescending); // Default sort

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
        leaveRosters = await _leaveRosterRepository
            .getLeaveRostersByClassSection(schoolId, className, sectionName);
      } else {
        // Fetch LeaveRoster for the selected month
        final rosterId = _leaveRosterRepository.generateLeaveRosterId(
            className: className,
            sectionName: sectionName,
            month: selectedMonth.value);

        final leaveRoster =
        await _leaveRosterRepository.getLeaveRosterById(schoolId, rosterId);
        leaveRosters = leaveRoster != null
            ? [leaveRoster]
            : []; // Wrap in a list if not null
      }

      // Combine leaves from all rosters
      userLeaves.clear();
      for (var roster in leaveRosters) {
        userLeaves.addAll(roster.leaves);
      }

      // Apply filtering and sorting
      applyFiltersAndSorting();

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
    totalLeaves.value = userLeaves.length;
    totalLeaveRejected.value =
        userLeaves.where((leave) => leave.status == "rejected").length;
    totalLeaveApproved.value =
        userLeaves.where((leave) => leave.status == "approved").length;
    totalLeavePending.value =
        userLeaves.where((leave) => leave.status == "pending").length;

    if (totalLeaves.value > 0) {
      leaveApprovalRate.value =
          (totalLeaveApproved.value / totalLeaves.value) * 100;
      leaveRejectionRate.value =
          (totalLeaveRejected.value / totalLeaves.value) * 100;
    } else {
      leaveApprovalRate.value = 0.0;
      leaveRejectionRate.value = 0.0;
    }
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

  //----------------------------------------------------------------------------
  // Filtering and Sorting Logic

  void setSelectedStatusFilter(String? status) {
    selectedStatusFilter.value = status;
    applyFiltersAndSorting();
  }

  void setSelectedSortOption(SortOption option) {
    selectedSortOption.value = option;
    applyFiltersAndSorting();
  }

  void applyFiltersAndSorting() {
    // 1. Apply Filters - start with a copy of the original list
    List<LeaveModel> filtered = List.from(userLeaves);

    // Apply status filter
    if (selectedStatusFilter.value != null) {
      filtered = filtered.where((leave) => leave.status == selectedStatusFilter.value?.toLowerCase()).toList();
    }

    // 2. Apply Sorting - sort the already filtered list
    switch (selectedSortOption.value) {
      case SortOption.appliedDateAscending:
        filtered.sort((a, b) => a.appliedAt.compareTo(b.appliedAt));
        break;
      case SortOption.appliedDateDescending:
        filtered.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
        break;
      case SortOption.leaveTypeAscending:
        filtered.sort((a, b) => a.leaveType.compareTo(b.leaveType));
        break;
      case SortOption.leaveTypeDescending:
        filtered.sort((a, b) => b.leaveType.compareTo(a.leaveType));
        break;
      case SortOption.applicantIdAscending:
        filtered.sort((a, b) => a.applicantId.compareTo(b.applicantId));
        break;
      case SortOption.applicantIdDescending:
        filtered.sort((a, b) => b.applicantId.compareTo(a.applicantId));
        break;
      case SortOption.periodAscending:
        filtered.sort((a, b) => a.getLeavePeriod().compareTo(b.getLeavePeriod()));
        break;
      case SortOption.periodDescending:
        filtered.sort((a, b) => b.getLeavePeriod().compareTo(a.getLeavePeriod()));
        break;
    }

    // 3. Update the filteredLeaves observable
    filteredLeaves.value = filtered;
  }
  //----------------------------------------------------------------------------
  // Leave Approval/Rejection Logic

  /// Approves the leave request.
  Future<void> approveLeave(LeaveModel leave) async {
    try {
      // Generate the LeaveRoster ID
      MyFullScreenLoading.show();
      final rosterId = _leaveRosterRepository.generateLeaveRosterId(
        className: className, // Replace with actual class name
        sectionName: sectionName, // Replace with actual section name
        month: leave.appliedAt, // Month from the leave application date
      );

      // Call the repository method to approve the leave
      await _leaveRosterRepository.approveLeave(
        schoolId: schoolId, // Replace with actual school ID
        rosterId: rosterId,
        leave: leave,
        approverId: approverId,
        approverName: approverName,
        className: className,
        sectionName: sectionName, month: leave.appliedAt,
      );

      // After successful approval, refresh the leave data
      fetchLeaveData();

      // Show success message
      // Get.snackbar(
      //   'Success',
      //   'Leave request approved successfully!',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } catch (e) {
      // Handle errors during the approval process
      print('Error approving leave: $e');
      Get.snackbar(
        'Error',
        'Failed to approve leave: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    MyFullScreenLoading.hide();
  }

  /// Rejects the leave request.
  Future<void> rejectLeave(LeaveModel leave) async {
    try {
      // Generate the LeaveRoster ID
      final rosterId = _leaveRosterRepository.generateLeaveRosterId(
        className: className, // Replace with actual class name
        sectionName: sectionName, // Replace with actual section name
        month: leave.appliedAt, // Month from the leave application date
      );

      // Call the repository method to reject the leave
      await _leaveRosterRepository.rejectLeave(
        schoolId: schoolId, // Replace with actual school ID
        rosterId: rosterId,
        leave: leave,
        approverId: approverId,
        approverName: approverName,
        className: className,sectionName: sectionName,month: leave.appliedAt,
      );

      // After successful rejection, refresh the leave data
      fetchLeaveData();

      // Show success message
      Get.snackbar(
        'Success',
        'Leave request rejected successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Handle errors during the rejection process
      print('Error rejecting leave: $e');
      Get.snackbar(
        'Error',
        'Failed to reject leave: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

// Define an enum for the sort options
enum SortOption {
  appliedDateAscending,
  appliedDateDescending,
  leaveTypeAscending,
  leaveTypeDescending,
  applicantIdAscending,
  applicantIdDescending,
  periodAscending,
  periodDescending
}