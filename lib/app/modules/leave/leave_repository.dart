import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase/firestore_service.dart';
import 'leave_model.dart';

class LeaveRosterRepository {
  //----------------------------------------------------------------------------
  // Instance Variables

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Direct Firestore access.

  //----------------------------------------------------------------------------
  // Helper Methods (Private)

  /// Generates the ID for a LeaveRoster document.
  String generateLeaveRosterId({
    required String className,
    required String sectionName,
    required DateTime month,
  }) {
    final year = month.year.toString();
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    final monthName = monthNames[month.month - 1];
    return '${className}_${sectionName}_${monthName}_$year';
  }

  /// Returns the path to the LeaveRoster collection for a given school.
  String _getLeaveRosterCollectionPath(String schoolId) {
    return '/leave_rosters/$schoolId/roster';
  }

  //----------------------------------------------------------------------------
  // CRUD Operations (LeaveRoster)

  /// Fetches a LeaveRoster by its ID.
  Future<LeaveRoster?> getLeaveRosterById(String schoolId, String rosterId) async {
    try {
      final docSnapshot = await _firestoreService.getDocumentById(
        _getLeaveRosterCollectionPath(schoolId),
        rosterId,
      );

      if (docSnapshot.exists) {
        return LeaveRoster.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching LeaveRoster: $e');
      return null;
    }
  }

  /// Creates a new LeaveRoster document.
  Future<void> createLeaveRoster(String schoolId, LeaveRoster leaveRoster) async {
    try {
      await _firestoreService.addDocument(
        _getLeaveRosterCollectionPath(schoolId),
        leaveRoster.toMap(),
        documentId: leaveRoster.id, // Use existing ID to avoid overwrite issue.
      );
    } catch (e) {
      print('Error creating LeaveRoster: $e');
      rethrow;
    }
  }

  /// Updates an existing LeaveRoster document.
  Future<void> updateLeaveRoster(String schoolId, LeaveRoster leaveRoster) async {
    try {
      await _firestoreService.updateDocument(
        _getLeaveRosterCollectionPath(schoolId),
        leaveRoster.id, // Use LeaveRoster.id, not re-generated ID.
        leaveRoster.toMap(),
      );
    } catch (e) {
      print('Error updating LeaveRoster: $e');
      rethrow;
    }
  }

  /// Deletes a LeaveRoster document.
  Future<void> deleteLeaveRoster(String schoolId, String rosterId) async {
    try {
      await _firestoreService.deleteDocument(
        _getLeaveRosterCollectionPath(schoolId),
        rosterId,
      );
    } catch (e) {
      print('Error deleting LeaveRoster: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // List Operations (LeaveRoster)

  /// Returns a list of all LeaveRosters for a given school.
  Future<List<LeaveRoster>> getAllLeaveRosters(String schoolId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_getLeaveRosterCollectionPath(schoolId))
          .get();

      return querySnapshot.docs.map((doc) {
        return LeaveRoster.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching all LeaveRosters: $e');
      return [];
    }
  }

  /// Returns a list of LeaveRosters for a specific class and section.
  Future<List<LeaveRoster>> getLeaveRostersByClassSection(
      String schoolId, String className, String sectionName) async {
    try {
      final querySnapshot = await _firestore
          .collection(_getLeaveRosterCollectionPath(schoolId))
          .where('className', isEqualTo: className)
          .where('sectionName', isEqualTo: sectionName)
          .get();

      return querySnapshot.docs.map((doc) {
        return LeaveRoster.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching LeaveRosters by class and section: $e');
      return [];
    }
  }

  //----------------------------------------------------------------------------
  // CRUD Operations (Leaves within a Roster)

  /// Adds a LeaveModel to a specific LeaveRoster. Also used for UPDATING leaves.
  Future<void> addLeaveToRoster({
    required String schoolId,
    required String rosterId,
    required LeaveModel leave,
    required String className,
    required String sectionName,
    required DateTime month,
  }) async {
    try {
      final docRef = _firestore.collection(_getLeaveRosterCollectionPath(schoolId)).doc(rosterId); // Direct Firestore access
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Roster doesn't exist, create a new one with the leave
        final newRoster = LeaveRoster(
          id: rosterId,
          className: className,
          sectionName: sectionName,
          month: month,
          leaves: [leave],
        );
        await createLeaveRoster(schoolId, newRoster);
      } else {
        // Roster exists, check if the leave already exists
        final data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> leavesData = (data['leaves'] as List<dynamic>?) ?? [];
        List<LeaveModel> existingLeaves = leavesData.map((leaveData) => LeaveModel.fromMap(leaveData as Map<String, dynamic>, leaveData['id']?.toString() ?? '')).toList();

        final existingLeaveIndex = existingLeaves.indexWhere((existingLeave) => existingLeave.id == leave.id);

        if (existingLeaveIndex != -1) {
          // Leave with the same ID exists, update it
          existingLeaves[existingLeaveIndex] = leave;

          // Convert LeaveModel objects back to Maps for Firestore
          List<Map<String, dynamic>> updatedLeavesData = existingLeaves.map((leave) => leave.toMap()).toList();

          await docRef.update({'leaves': updatedLeavesData});
        } else {
          // Leave with the same ID doesn't exist, add it to the array
          await docRef.update({
            'leaves': FieldValue.arrayUnion([leave.toMap()])
          });
        }
      }



    } catch (e) {
      print('Error adding/updating leave in roster: $e');
      rethrow;
    }
  }

  /// Removes a LeaveModel from a LeaveRoster.
  Future<void> removeLeaveFromRoster({
    required String schoolId,
    required String rosterId,
    required LeaveModel leave,
  }) async {
    try {
      final docRef = _firestore.collection(_getLeaveRosterCollectionPath(schoolId)).doc(rosterId);

      await docRef.update({
        'leaves': FieldValue.arrayRemove([leave.toMap()])
      });
    } catch (e) {
      print('Error removing leave from roster: $e');
      rethrow;
    }
  }

  /// Approves a LeaveModel in a specific LeaveRoster.
  Future<void> approveLeave({
    required String schoolId,
    required String rosterId,
    required LeaveModel leave,
    required String approverId,
    required String approverName,
    required String className,
    required String sectionName,
    required DateTime month,
  }) async {
    try {
      final updatedLeave = LeaveModel(
        id: leave.id,
        applicantId: leave.applicantId,
        applicantName: leave.applicantName,
        leaveType: leave.leaveType,
        startDate: leave.startDate,
        endDate: leave.endDate,
        reason: leave.reason,
        status: "approved",
        approverId: approverId,
        approverName: approverName,
        appliedAt: leave.appliedAt,
        approvedAt: DateTime.now(),
      );

      await addLeaveToRoster(
        schoolId: schoolId,
        rosterId: rosterId,
        leave: updatedLeave,
        className: className,
        sectionName: sectionName,
        month: month,
      );

    } catch (e) {
      print('Error approving leave: $e');
      rethrow;
    }
  }

  /// Rejects a LeaveModel in a specific LeaveRoster.
  Future<void> rejectLeave({
    required String schoolId,
    required String rosterId,
    required LeaveModel leave,
    required String approverId,
    required String approverName,
    required String className,
    required String sectionName,
    required DateTime month,
  }) async {
    try {
      final updatedLeave = LeaveModel(
        id: leave.id,
        applicantId: leave.applicantId,
        applicantName: leave.applicantName,
        leaveType: leave.leaveType,
        startDate: leave.startDate,
        endDate: leave.endDate,
        reason: leave.reason,
        status: "rejected",
        approverId: approverId,
        approverName: approverName,
        appliedAt: leave.appliedAt,
        approvedAt: DateTime.now(),
      );

      await addLeaveToRoster(
        schoolId: schoolId,
        rosterId: rosterId,
        leave: updatedLeave,
        className: className,
        sectionName: sectionName,
        month: month,
      );

    } catch (e) {
      print('Error rejecting leave: $e');
      rethrow;
    }
  }
}