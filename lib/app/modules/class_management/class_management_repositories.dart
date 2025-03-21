// Filename: management/admin/class_management/class_management_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../core/services/firebase/firestore_service.dart';
import '../school_management/school_model.dart';
import 'class_model.dart';

class ClassManagementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();

  final String _collectionName = 'classes';

  /// Fetches a class (SchoolClassModel) by className and schoolId.
  Future<ClassModel?> fetchClassByClassNameAndSchoolId(
      String schoolId, String className) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .where('className', isEqualTo: className)
          .limit(
              1) // Assuming class names are unique per school.  If not, remove the limit.
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ClassModel.fromMap(
            snapshot.docs.first.data(), snapshot.docs.first.id);
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class by class name: $e');
      print('Failed to fetch class by class name: $e');
      return null;
    }
  }

  Future<List<SectionData>> fetchSchoolSections(String schoolId) async {
    try {
      final List<ClassData> classData = await fetchClassData(schoolId);

      return classData
          .expand((classItem) =>
              classItem.sectionName.map((sectionName) => SectionData(
                    classId: classItem.classId,
                    className: classItem.className,
                    sectionName: sectionName,
                  )))
          .toList();
    } catch (error) {
      print('Error fetching school sections: $error');
      return [];
    }
  }

  Future<List<ClassData>> fetchClassData(String schoolId) async {
    try {
      final docSnapshot =
          await _firestoreService.getDocumentById('schools', schoolId);

      if (docSnapshot.exists && docSnapshot.data()!.containsKey('classes')) {
        final classes = docSnapshot.data()!['classes'] as List;
        return classes
            .map((e) => ClassData.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class data: $e');
      print('Failed to fetch class data: $e');

      return [];
    }
  }

  /// Fetches a class (SchoolClassModel) by className and schoolId.
  Future<ClassModel?> getClassByClassName(
      String schoolId, String className) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .where('className', isEqualTo: className)
          .limit(
              1) // Assuming class names are unique per school.  If not, remove the limit.
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ClassModel.fromMap(
            snapshot.docs.first.data(), snapshot.docs.first.id);
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class by class name: $e');
      print('Failed to fetch class by class name: $e');
      return null;
    }
  }

  /// Retrieves all ClassModels for a specific school.
  Future<List<ClassModel>> getClassesBySchoolId(String schoolId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collectionName)
          .where('schoolId', isEqualTo: schoolId)
          .get();

      return snapshot.docs
          .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching classes by school ID: $e');
      return []; // Handle error appropriately
    }
  }

  /// Creates a new ClassModel in Firestore using the existing ID.
  Future<String?> createClass(ClassModel classModel) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
      _firestore.collection(_collectionName).doc(classModel.id); // Use existing ID

      await docRef.set(classModel.toMap()); // Save data to Firestore

      return classModel.id; // Return the existing ID
    } catch (e) {
      print('Error creating class: $e');
      return null; // Handle error appropriately
    }
  }


  /// Updates an existing ClassModel in Firestore.
  Future<void> updateClass(ClassModel classModel) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(classModel.id)
          .update(classModel.toMap());
    } catch (e) {
      print('Error updating class: $e');
      // Handle error appropriately (e.g., throw an exception)
      rethrow; // Re-throw the error for the calling function to handle
    }
  }

  /// Deletes a ClassModel from Firestore.
  Future<void> deleteClass(String classId) async {
    try {
      await _firestore.collection(_collectionName).doc(classId).delete();
    } catch (e) {
      print('Error deleting class: $e');
      // Handle error appropriately
      rethrow; // Re-throw the error for the calling function to handle
    }
  }

  /// Streams all ClassModels for a specific school (for real-time updates).
  Stream<List<ClassModel>> streamClassesBySchoolId(String schoolId) {
    return _firestore
        .collection(_collectionName)
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
