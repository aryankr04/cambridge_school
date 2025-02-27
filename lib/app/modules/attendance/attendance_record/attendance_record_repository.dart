// --- Firestore Repository Class ---
import 'package:cloud_firestore/cloud_firestore.dart';

import 'attendance_record_models.dart';

class FirestoreAttendanceRecordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String attendanceRecordsCollection = 'attendance_records';
  static const String dailyAttendanceRecordsSubcollection = 'daily_attendance_records';
  static const String classAttendanceRecordsSubcollection = 'class_attendance_records';
  static const String userAttendanceRecordsSubcollection = 'user_attendance_records';

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

  // --- ClassAttendanceRecord Operations ---

  Future<void> createClassAttendanceRecord(String schoolId, ClassAttendanceRecord record) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final classAttendanceDocRef = schoolDocRef.collection(classAttendanceRecordsSubcollection).doc('${record.className}_${record.sectionName}'); // unique ID

      await classAttendanceDocRef.set({
        'schoolId': record.schoolId,
        'className': record.className,
        'sectionName': record.sectionName,
        'attendanceEvents': record.attendanceEvents.map((e) => e.toMap()).toList(),
      });
    } catch (e) {
      print("Error creating ClassAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<ClassAttendanceRecord?> getClassAttendanceRecord(String schoolId, String className, String sectionName) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final classAttendanceDocRef = schoolDocRef.collection(classAttendanceRecordsSubcollection).doc('${className}_${sectionName}');

      final snapshot = await classAttendanceDocRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return ClassAttendanceRecord(
          schoolId: data['schoolId'] as String,
          className: data['className'] as String,
          sectionName: data['sectionName'] as String,
          attendanceEvents: (data['attendanceEvents'] as List<dynamic>)
              .map((e) => AttendanceEvent.fromMap(e as Map<String, dynamic>))
              .toList(),
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting ClassAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<void> updateClassAttendanceRecord(String schoolId, ClassAttendanceRecord record) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final classAttendanceDocRef = schoolDocRef.collection(classAttendanceRecordsSubcollection).doc('${record.className}_${record.sectionName}');

      await classAttendanceDocRef.update({
        'schoolId': record.schoolId,
        'className': record.className,
        'sectionName': record.sectionName,
        'attendanceEvents': record.attendanceEvents.map((e) => e.toMap()).toList(),
      });
    } catch (e) {
      print("Error updating ClassAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<void> deleteClassAttendanceRecord(String schoolId, String className, String sectionName) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final classAttendanceDocRef = schoolDocRef.collection(classAttendanceRecordsSubcollection).doc('${className}_${sectionName}');

      await classAttendanceDocRef.delete();
    } catch (e) {
      print("Error deleting ClassAttendanceRecord: $e");
      rethrow;
    }
  }

  // --- UserAttendanceRecord Operations ---

  Future<void> createUserAttendanceRecord(String schoolId, UserAttendanceRecord record) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final userAttendanceDocRef = schoolDocRef.collection(userAttendanceRecordsSubcollection).doc(record.userType); // Use userType as document ID for simplicity

      await userAttendanceDocRef.set(record.toMap());
    } catch (e) {
      print("Error creating UserAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<UserAttendanceRecord?> getUserAttendanceRecord(String schoolId, String userType) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final userAttendanceDocRef = schoolDocRef.collection(userAttendanceRecordsSubcollection).doc(userType);

      final snapshot = await userAttendanceDocRef.get();
      if (snapshot.exists) {
        return UserAttendanceRecord.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting UserAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<void> updateUserAttendanceRecord(String schoolId, UserAttendanceRecord record) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final userAttendanceDocRef = schoolDocRef.collection(userAttendanceRecordsSubcollection).doc(record.userType);

      await userAttendanceDocRef.update(record.toMap());
    } catch (e) {
      print("Error updating UserAttendanceRecord: $e");
      rethrow;
    }
  }

  Future<void> deleteUserAttendanceRecord(String schoolId, String userType) async {
    try {
      final schoolDocRef = _firestore.collection(attendanceRecordsCollection).doc(schoolId);
      final userAttendanceDocRef = schoolDocRef.collection(userAttendanceRecordsSubcollection).doc(userType);

      await userAttendanceDocRef.delete();
    } catch (e) {
      print("Error deleting UserAttendanceRecord: $e");
      rethrow;
    }
  }

  // --- Utility Method (Date Formatting) ---
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}