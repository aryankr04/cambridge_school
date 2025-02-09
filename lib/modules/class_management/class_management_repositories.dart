// Filename: management/admin/class_management/class_management_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'class_model.dart'; // Import your data models
import 'package:get/get.dart';

class ClassManagementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchClassNames(String schoolId) async {
    try {
      final docSnapshot =
      await _firestore.collection('schools').doc(schoolId).get();

      if (docSnapshot.exists && docSnapshot.data()!.containsKey('classes')) {
        return List<String>.from(docSnapshot['classes'] as List);
      } else {
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class names: $e');
      return []; // Return an empty list in case of error
    }
  }

  Future<void> addClassName(String schoolId, String className) async {
    try {
      await _firestore.collection('schools').doc(schoolId).update({
        'classes': FieldValue.arrayUnion([className]),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add class name: $e');
      rethrow;
    }
  }

  Future<void> deleteClassName(String schoolId, String className) async {
    try {
      await _firestore.collection('schools').doc(schoolId).update({
        'classes': FieldValue.arrayRemove([className]),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete class name: $e');
      rethrow;
    }
  }

  Future<List<SchoolClassModel>> fetchClasses(String schoolId) async {
    try {
      final snapshot = await _firestore
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .get();

      return snapshot.docs
          .map((doc) => SchoolClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch classes: $e');
      return [];
    }
  }

  Future<void> addOrUpdateClass(SchoolClassModel schoolClass) async {
    try {
      await _firestore
          .collection('classes')
          .doc(schoolClass.id)
          .set(schoolClass.toMap(), SetOptions(merge: true));
    } catch (e) {
      Get.snackbar('Error', 'Failed to add/update class: $e');
      rethrow;
    }
  }

  Future<void> deleteSection(String classId, List<SchoolSectionModel> updatedSections) async {
    try {
      await _firestore.collection('classes').doc(classId).update({
        'sections': updatedSections.map((section) => section.toMap()).toList(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete section: $e');
      rethrow;
    }
  }

  Future<void> deleteClassesUnderClassName(String schoolId, String className) async {
    try {
      final classesQuery = await _firestore
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .where('className', isEqualTo: className)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var docSnapshot in classesQuery.docs) {
        batch.delete(docSnapshot.reference);
      }

      await batch.commit();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete classes under class name: $e');
      rethrow;
    }
  }
}