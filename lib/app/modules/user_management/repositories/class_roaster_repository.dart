import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_repository_model.dart';
import '../models/user_model.dart';

class ClassRosterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'class_rosters';

  // --- CRUD Operations ---

  Future<void> addClassRoster(ClassRoster classRoster) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(classRoster.classId)
          .set(classRoster.toMap());
      print('Class roster added successfully!');
    } catch (e) {
      print('Error adding class roster: $e');
      rethrow;
    }
  }

  Future<ClassRoster?> getClassRoster(String classId) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(classId).get();
      return doc.exists ? ClassRoster.fromMap(doc.data() as Map<String, dynamic>) : null;
    } catch (e) {
      print('Error getting class roster: $e');
      return null;
    }
  }

  Future<void> updateClassRoster(ClassRoster updatedClassRoster) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(updatedClassRoster.classId)
          .update(updatedClassRoster.toMap());
      print('Class roster updated successfully!');
    } catch (e) {
      print('Error updating class roster: $e');
      rethrow;
    }
  }

  Future<void> deleteClassRoster(String classId) async {
    try {
      await _firestore.collection(collectionName).doc(classId).delete();
      print('Class roster deleted successfully!');
    } catch (e) {
      print('Error deleting class roster: $e');
      rethrow;
    }
  }

  // --- Queries ---

  Future<List<ClassRoster>> getClassRostersBySchoolId(String schoolId) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('schoolId', isEqualTo: schoolId)
          .get();

      return querySnapshot.docs
          .map((doc) => ClassRoster.fromMap(doc.data() as Map<String, dynamic>))
          .nonNulls
          .toList();
    } catch (e) {
      print('Error getting class rosters by school ID: $e');
      return [];
    }
  }

  Future<List<UserModel>> getStudentsInClassRoster(String classId) async {
    final classRoster = await getClassRoster(classId);
    return classRoster?.studentList ?? [];
  }

  Future<List<ClassRoster>> getAllClassRosters() async {
    try {
      final querySnapshot = await _firestore.collection(collectionName).get();
      return querySnapshot.docs
          .map((doc) => ClassRoster.fromMap(doc.data() as Map<String, dynamic>))
          .nonNulls
          .toList();
    } catch (e) {
      print('Error getting all class rosters: $e');
      return [];
    }
  }

  Future<List<UserModel>> getStudentsByClassAndSection(
      String className, String sectionName, String schoolId) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('className', isEqualTo: className)
          .where('sectionName', isEqualTo: sectionName)
          .where('schoolId', isEqualTo: schoolId)
          .get();

      return querySnapshot.docs
          .map((doc) => ClassRoster.fromMap(doc.data() as Map<String, dynamic>)?.studentList)
          .nonNulls
          .expand((students) => students)
          .toList();
    } catch (e) {
      print('Error getting students by class and section: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllStudentsFromAllClassRosters() async {
    try {
      final querySnapshot = await _firestore.collection(collectionName).get();

      return querySnapshot.docs
          .map((doc) => ClassRoster.fromMap(doc.data() as Map<String, dynamic>)?.studentList)
          .nonNulls
          .expand((students) => students)
          .toList();
    } catch (e) {
      print('Error getting all students from all class rosters: $e');
      return [];
    }
  }

  // --- Helper Methods ---

  Future<bool> classRosterExists(String classId) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(classId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking class roster existence: $e');
      return false;
    }
  }

  // --- Streams ---

  Stream<List<ClassRoster>> getClassRostersStream(String schoolId) {
    return _firestore
        .collection(collectionName)
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ClassRoster.fromMap(doc.data() as Map<String, dynamic>))
        .nonNulls
        .toList());
  }
}