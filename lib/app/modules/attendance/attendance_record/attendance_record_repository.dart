import 'package:intl/intl.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import 'attendance_record_models.dart';

class FirestoreAttendanceRecordRepository {
  //----------------------------------------------------------------------------
  // Instance Variables
  final FirestoreService _firestoreService = FirestoreService();

  //----------------------------------------------------------------------------
  // Constants
  static const String attendanceRecordsCollection = 'attendance_records';
  static const String dailyAttendanceRecordsSubcollection = 'daily_attendance_records';

  //----------------------------------------------------------------------------
  // DailyAttendanceRecord Operations

  // Creates a new daily attendance record in Firestore.
  Future<void> createDailyAttendanceRecord(DailyAttendanceRecord record) async {
    try {
      final String dailyAttendanceDocPath = _getDailyAttendanceDocPath(record.schoolId, record.date);
      await _firestoreService.addDocument(dailyAttendanceDocPath, record.toMap());
    } catch (e) {
      print("Error creating DailyAttendanceRecord: $e");
      rethrow;
    }
  }

  /// Retrieves a daily attendance record from Firestore.
  Future<DailyAttendanceRecord?> getDailyAttendanceRecord(String schoolId, DateTime date) async {
    try {
      final String dailyAttendanceDocPath = _getDailyAttendanceDocPath(schoolId, date);
      final String documentId = formatDate(date);

      print('📂 Fetching document from path: $dailyAttendanceDocPath with ID: $documentId');

      final snapshot = await _firestoreService.getDocumentById(dailyAttendanceDocPath, documentId);

      if (!snapshot.exists || snapshot.data() == null) {
        print('❌ Document not found: $documentId in $dailyAttendanceDocPath');
        return null;
      }

      final data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        print('⚠️ Snapshot data is null for document ID: $documentId');
        return null;
      }

      print('✅ Document found: $documentId, parsing data...');
      return DailyAttendanceRecord.fromMap(data);
    } catch (e) {
      print("🚨 Error getting DailyAttendanceRecord: $e");
      return null;
    }
  }




  /// Updates an existing daily attendance record in Firestore.
  Future<void> updateDailyAttendanceRecord(DailyAttendanceRecord record) async {
    try {
      final String dailyAttendanceDocPath = _getDailyAttendanceDocPath(record.schoolId, record.date);
      await _firestoreService.updateDocument(dailyAttendanceDocPath, formatDate(record.date), record.toMap());
    } catch (e) {
      print("Error updating DailyAttendanceRecord: $e");
      rethrow;
    }
  }

  /// Deletes a daily attendance record from Firestore.
  Future<void> deleteDailyAttendanceRecord(String schoolId, DateTime date) async {
    try {
      final String dailyAttendanceDocPath = _getDailyAttendanceDocPath(schoolId, date);
      await _firestoreService.deleteDocument(dailyAttendanceDocPath, formatDate(date));
    } catch (e) {
      print("Error deleting DailyAttendanceRecord: $e");
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Utility Methods (Private)

  /// Gets the document path for a daily attendance record in Firestore.
  String _getDailyAttendanceDocPath(String schoolId, DateTime date) {
    return '$attendanceRecordsCollection/$schoolId/$dailyAttendanceRecordsSubcollection';
  }

  /// Formats a [DateTime] object into a string representation in 'yyyy-MM-dd' format.
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  //----------------------------------------------------------------------------
  // Utility Methods (Static)

  /// Gets the document ID for a daily attendance record based on the date.
  static String getDailyAttendanceDocId(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}