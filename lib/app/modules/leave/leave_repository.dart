import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase/firestore_service.dart';
import 'leave_model.dart'; // Assuming LeaveModel and LeaveRoster are in this file


class LeaveRosterRepository {
  //----------------------------------------------------------------------------
  // Instance Variables
  final FirestoreService _firestoreService = FirestoreService();

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
    final monthName = monthNames[month.month - 1]; // Subtract 1 as month is 1-indexed
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
      final rosterId = generateLeaveRosterId(
        className: leaveRoster.className,
        sectionName: leaveRoster.sectionName,
        month: leaveRoster.month,
      );

      await _firestoreService.addDocument(
        _getLeaveRosterCollectionPath(schoolId),
        leaveRoster.toMap(),
      );
    } catch (e) {
      print('Error creating LeaveRoster: $e');
      rethrow;
    }
  }

  /// Updates an existing LeaveRoster document.
  Future<void> updateLeaveRoster(String schoolId, LeaveRoster leaveRoster) async {
    try {
      final rosterId = generateLeaveRosterId(
        className: leaveRoster.className,
        sectionName: leaveRoster.sectionName,
        month: leaveRoster.month,
      );

      await _firestoreService.updateDocument(
        _getLeaveRosterCollectionPath(schoolId),
        rosterId,
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
// FirestoreService instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  /// Adds a LeaveModel to a specific LeaveRoster.
  Future<void> addLeaveToRoster({
    required String schoolId,
    required String rosterId,
    required LeaveModel leave,
    required String className,
    required String sectionName,
    required DateTime month,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection(_getLeaveRosterCollectionPath(schoolId)).doc(rosterId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        final newRoster = LeaveRoster(
          id: rosterId,
          className: className,
          sectionName: sectionName,
          month: month,
          leaves: [leave],
        );
        await _firestoreService.addDocument(_getLeaveRosterCollectionPath(schoolId), newRoster.toMap(),documentId: rosterId);
      } else {
        await docRef.update({
          'leaves': FieldValue.arrayUnion([leave.toMap()])
        });
      }
    } catch (e) {
      print('Error adding leave to roster: $e');
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
      final docRef = FirebaseFirestore.instance.collection(_getLeaveRosterCollectionPath(schoolId)).doc(rosterId);

      await docRef.update({
        'leaves': FieldValue.arrayRemove([leave.toMap()])
      });
    } catch (e) {
      print('Error removing leave from roster: $e');
      rethrow;
    }
  }
}