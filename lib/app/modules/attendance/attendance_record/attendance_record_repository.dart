import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/firebase/firestore_service.dart';
import 'attendance_record_models.dart';

class DailyAttendanceRecordRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'daily_attendance_records';
  final String schoolId;

  DailyAttendanceRecordRepository({required this.schoolId});

  //----------------------------------------------------------------------------
  // CRUD Operations using FirestoreService

  String _getFullCollectionPath() {
    return 'schools/$schoolId/$_collectionPath';
  }


  /// Adds a new DailyAttendanceRecord to Firestore.
  Future<DocumentReference<Map<String, dynamic>>> addDailyAttendanceRecord(
      DailyAttendanceRecord record) async {
    try {
      return await _firestoreService.addDocument(
          _getFullCollectionPath(), record.toMap());
    } catch (e) {
      if (kDebugMode) {
        print("Error adding DailyAttendanceRecord: $e");
      }
      rethrow;
    }
  }

  /// Retrieves a DailyAttendanceRecord by its date. Returns null if no record is found.
  Future<DailyAttendanceRecord?> getDailyAttendanceRecordByDate(
      DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection(_getFullCollectionPath())
          .where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .limit(1) // Limit the result to 1 record
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Convert the first document in the query result to a DailyAttendanceRecord object
        return DailyAttendanceRecord.fromMap(querySnapshot.docs.first.data());
      } else {
        // No document found for the given date
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting DailyAttendanceRecord by date: $e");
      }
      return null;
    }
  }



  /// Updates an existing DailyAttendanceRecord in Firestore.
  Future<void> updateDailyAttendanceRecord(
  DailyAttendanceRecord record) async {
    try {
      await _firestoreService.updateDocument(
          _getFullCollectionPath(), record.id, record.toMap());
    } catch (e) {
      if (kDebugMode) {
        print("Error updating DailyAttendanceRecord: $e");
      }
      rethrow;
    }
  }

  /// Deletes a DailyAttendanceRecord from Firestore.
  Future<void> deleteDailyAttendanceRecord(String documentId) async {
    try {
      await _firestoreService.deleteDocument(_getFullCollectionPath(), documentId);
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting DailyAttendanceRecord: $e");
      }
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Query Operations

  /// Retrieves all DailyAttendanceRecords from Firestore.
  Future<List<DailyAttendanceRecord>> getAllDailyAttendanceRecords() async {
    try {
      final querySnapshot =
      await _firestoreService.getAllDocuments(_getFullCollectionPath());
      return querySnapshot
          .map((doc) => DailyAttendanceRecord.fromMap(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting all DailyAttendanceRecords: $e");
      }
      return [];
    }
  }

  /// Queries DailyAttendanceRecords by date.  Note: Firestore range queries on different fields aren't supported.
  ///  This only queries by the date.  For more complex queries, you'll likely need to use a cloud function.
  Future<List<DailyAttendanceRecord>> getDailyAttendanceRecordsByDate(
      DateTime date) async {
    try {
      final querySnapshot = await _firestoreService.queryDocuments(
          _getFullCollectionPath(), 'date', Timestamp.fromDate(date));
      return querySnapshot
          .map((doc) => DailyAttendanceRecord.fromMap(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting DailyAttendanceRecords by date: $e");
      }
      return [];
    }
  }

  //----------------------------------------------------------------------------
  // Stream Operations (Real-time)

  /// Returns a real-time stream of a single DailyAttendanceRecord.
  Stream<DailyAttendanceRecord?> getDailyAttendanceRecordStream(
      String documentId) {
    return _firestoreService
        .getDocumentStream(_getFullCollectionPath(), documentId)
        .map((snapshot) {
      if (snapshot.exists) {
        return DailyAttendanceRecord.fromMap(
            snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }
}