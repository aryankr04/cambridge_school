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
    this.status = "Pending",
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
}