// Filename: management/admin/class_management/class_management_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../core/services/firebase/firestore_service.dart';
import 'class_model.dart';

class ClassManagementRepository {
  //----------------------------------------------------------------------------
  // Instance Variables

  final FirestoreService _firestoreService = FirestoreService();

  //----------------------------------------------------------------------------
  // Helper Methods (Private)

  // None currently. Could add helpers for constructing collection paths if needed.

  //----------------------------------------------------------------------------
  // School Class Name Operations (Managing the 'classes' array in the 'schools' document)

  /// Fetches the list of class names for a given school.
  Future<List<String>> fetchClassNames(String schoolId) async {
    try {
      final docSnapshot = await _firestoreService.getDocumentById('schools', schoolId);

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

  /// Adds a new class name to the list of classes for a given school.
  Future<void> addClassName(String schoolId, String className) async {
    try {
      await FirebaseFirestore.instance.collection('schools').doc(schoolId).update({
        'classes': FieldValue.arrayUnion([className]),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add class name: $e');
      rethrow;
    }
  }

  /// Deletes a class name from the list of classes for a given school.
  Future<void> deleteClassName(String schoolId, String className) async {
    try {
      await FirebaseFirestore.instance.collection('schools').doc(schoolId).update({
        'classes': FieldValue.arrayRemove([className]),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete class name: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // SchoolClassModel Operations (Managing 'classes' collection)

  /// Fetches all classes (SchoolClassModel) for a given school.
  Future<List<SchoolClassModel>> fetchClasses(String schoolId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
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

  /// Adds or updates a SchoolClassModel.
  Future<void> addOrUpdateClass(SchoolClassModel schoolClass) async {
    try {

      await FirebaseFirestore.instance
          .collection('classes')
          .doc(schoolClass.id)
          .set(schoolClass.toMap(), SetOptions(merge: true));
    } catch (e) {
      Get.snackbar('Error', 'Failed to add/update class: $e');
      rethrow;
    }
  }

  /// Deletes a section from a SchoolClassModel.
  Future<void> deleteSection(String classId, List<SchoolSectionModel> updatedSections) async {
    try {
      await FirebaseFirestore.instance.collection('classes').doc(classId).update({
        'sections': updatedSections.map((section) => section.toMap()).toList(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete section: $e');
      rethrow;
    }
  }

  /// Deletes all classes under a specific class name for a given school.
  Future<void> deleteClassesUnderClassName(String schoolId, String className) async {
    try {
      final classesQuery = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .where('className', isEqualTo: className)
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();
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