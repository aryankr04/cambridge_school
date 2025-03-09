import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveModel {
  String id;
  String applicantId;
  String applicantName;
  String leaveType;
  DateTime startDate;
  DateTime endDate;
  String reason;
  String status;
  String approverId;
  String approverName;
  DateTime appliedAt;
  DateTime? approvedAt;

  LeaveModel({
    required this.id,
    required this.applicantId,
    required this.applicantName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = "pending",
    this.approverId = "",
    this.approverName = "",
    required this.appliedAt,
    this.approvedAt,
  });

  factory LeaveModel.fromMap(Map<String, dynamic> map, String id) {
    Timestamp? appliedAtTimestamp = map['appliedAt'] as Timestamp?;

    return LeaveModel(
      id: id,
      applicantId: map['applicantId'] as String? ?? '',
      applicantName: map['applicantName'] as String? ?? '',
      leaveType: map['leaveType'] as String? ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      reason: map['reason'] as String? ?? '',
      status: map['status'] as String? ?? 'Pending',
      approverId: map['approverId'] as String? ?? '',
      approverName: map['approverName'] as String? ?? '',
      appliedAt: (appliedAtTimestamp != null) ? appliedAtTimestamp.toDate() : DateTime.now(),
      approvedAt: map['approvedAt'] != null
          ? (map['approvedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'leaveType': leaveType,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
      'approverId': approverId,
      'approverName': approverName,
      'appliedAt': appliedAt,
      'approvedAt': approvedAt,
    };
  }

  // Helper function to calculate leave period
  int getLeavePeriod() {
    return endDate.difference(startDate).inDays + 1; // +1 to include both start and end dates
  }
}

class LeaveRoster {
  String id;
  List<LeaveModel> leaves;
  DateTime month;
  String className;
  String sectionName;

  LeaveRoster({
    required this.id,
    required this.leaves,
    required this.month,
    required this.className,
    required this.sectionName,
  });

  factory LeaveRoster.fromMap(Map<String, dynamic> map, String id) {
    return LeaveRoster(
      id: id,
      className: map['className'] as String? ?? '',
      sectionName: map['sectionName'] as String? ?? '',
      leaves: (map['leaves'] as List<dynamic>?)
          ?.map((leave) {
        if (leave != null && leave is Map<String, dynamic>) {
          return LeaveModel.fromMap(leave, leave['id']?.toString() ?? id);
        } else {
          print("Invalid leave data: $leave");
          return null;
        }
      })
          .where((element) => element != null)
          .cast<LeaveModel>()
          .toList() ?? [],
      month: (map['month'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'className': className,
      'sectionName': sectionName,
      'leaves': leaves.map((leave) => leave.toMap()).toList(),
      'month': month,
    };
  }

  // Sorting functions

  // Sort by Applied Date (appliedAt)
  void sortByAppliedDate({bool ascending = true}) {
    leaves.sort((a, b) {
      if (ascending) {
        return a.appliedAt.compareTo(b.appliedAt);
      } else {
        return b.appliedAt.compareTo(a.appliedAt);
      }
    });
  }

  // Sort by Status
  void sortByStatus({bool ascending = true}) {
    leaves.sort((a, b) {
      if (ascending) {
        return a.status.compareTo(b.status);
      } else {
        return b.status.compareTo(a.status);
      }
    });
  }

  // Sort by Leave Type
  void sortByLeaveType({bool ascending = true}) {
    leaves.sort((a, b) {
      if (ascending) {
        return a.leaveType.compareTo(b.leaveType);
      } else {
        return b.leaveType.compareTo(a.leaveType);
      }
    });
  }

  // Sort by Applicant ID
  void sortByApplicantId({bool ascending = true}) {
    leaves.sort((a, b) {
      if (ascending) {
        return a.applicantId.compareTo(b.applicantId);
      } else {
        return b.applicantId.compareTo(a.applicantId);
      }
    });
  }

  // Sort by Leave Period (EndDate - StartDate)
  void sortByLeavePeriod({bool ascending = true}) {
    leaves.sort((a, b) {
      final periodA = a.getLeavePeriod();
      final periodB = b.getLeavePeriod();

      if (ascending) {
        return periodA.compareTo(periodB);
      } else {
        return periodB.compareTo(periodA);
      }
    });
  }

  // Filtering functions

  // Filter by Status
  List<LeaveModel> filterByStatus(String status) {
    return leaves.where((leave) => leave.status == status).toList();
  }

  // Filter by Leave Type
  List<LeaveModel> filterByLeaveType(String leaveType) {
    return leaves.where((leave) => leave.leaveType == leaveType).toList();
  }

  // Filter by Applicant ID
  List<LeaveModel> filterByApplicantId(String applicantId) {
    return leaves.where((leave) => leave.applicantId == applicantId).toList();
  }

  // Filter by Date Range (Applied Date)
  List<LeaveModel> filterByAppliedDateRange(DateTime startDate, DateTime endDate) {
    return leaves.where((leave) =>
    leave.appliedAt.isAfter(startDate.subtract(const Duration(days: 1))) &&
        leave.appliedAt.isBefore(endDate.add(const Duration(days: 1)))
    ).toList();
  }

  //Filter by Date Range (Leave Period Date)
  List<LeaveModel> filterByLeavePeriodDateRange(DateTime startDate, DateTime endDate) {
    return leaves.where((leave) =>
    leave.startDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        leave.endDate.isBefore(endDate.add(const Duration(days: 1)))
    ).toList();
  }
}