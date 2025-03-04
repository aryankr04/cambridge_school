import 'package:cloud_firestore/cloud_firestore.dart';

import 'attendance_record_models.dart';

class FirestoreAttendanceRecordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String attendanceRecordsCollection = 'attendance_records';
  static const String dailyAttendanceRecordsSubcollection = 'daily_attendance_records';

  // --- DailyAttendanceRecord Operations ---

  Future<void> createDailyAttendanceRecord(DailyAttendanceRecord record) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(record.schoolId);
      final dailyAttendanceDocRef = schoolDocRef.collection(dailyAttendanceRecordsSubcollection).doc(formatDate(record.date)); // Use date as doc ID

      await dailyAttendanceDocRef.set(record.toMap());
    } catch (e) {
      print("Error creating DailyAttendanceRecord: $e"); // Proper error handling
      rethrow;
    }
  }

  Future<DailyAttendanceRecord?> getDailyAttendanceRecord(String schoolId, DateTime date) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final dailyAttendanceDocRef = schoolDocRef.collection(dailyAttendanceRecordsSubcollection).doc(formatDate(date)); // Use date as doc ID

      final snapshot = await dailyAttendanceDocRef.get();
      if (snapshot.exists) {
        return DailyAttendanceRecord.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting DailyAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<void> updateDailyAttendanceRecord(DailyAttendanceRecord record) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(record.schoolId);
      final dailyAttendanceDocRef = schoolDocRef.collection(dailyAttendanceRecordsSubcollection).doc(formatDate(record.date));

      await dailyAttendanceDocRef.update(record.toMap());
    } catch (e) {
      print("Error updating DailyAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<void> deleteDailyAttendanceRecord(String schoolId, DateTime date) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final dailyAttendanceDocRef = schoolDocRef.collection(dailyAttendanceRecordsSubcollection).doc(formatDate(date));

      await dailyAttendanceDocRef.delete();
    } catch (e) {
      print("Error deleting DailyAttendanceRecord: $e");
      rethrow;
    }
  }



  // --- Utility Method (Date Formatting) ---
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}