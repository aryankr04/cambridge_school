// Filename: management/admin/class_management/class_management_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../core/services/firebase/firestore_service.dart';
import '../school_management/school_model.dart';
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
      final docSnapshot =
          await _firestoreService.getDocumentById('schools', schoolId);

      if (docSnapshot.exists && docSnapshot.data()!.containsKey('classes')) {
        final classes = (docSnapshot['classes'] as List)
            .map((e) => ClassData.fromMap(e as Map<String, dynamic>))
            .toList();

        return classes.map((classData) => classData.className).toList();
      } else {
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class names: $e');
      print('Failed to fetch class names: $e');

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

  /// Adds a new class name to the list of classes for a given school.
  Future<void> addClassName(String schoolId, String className) async {
    try {
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .update({
        'classes': FieldValue.arrayUnion([className]),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add class name: $e');
      print('Failed to add class name: $e');
      rethrow;
    }
  }

  /// Deletes a class name from the list of classes for a given school.
  Future<void> deleteClassName(String schoolId, String className) async {
    try {
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .update({
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
  Future<List<ClassModel>> fetchClasses(String schoolId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .get();

      return snapshot.docs
          .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch classes: $e');
      return [];
    }
  }

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

  /// Adds or updates a SchoolClassModel.
  Future<void> addOrUpdateClass(ClassModel schoolClass) async {
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

  /// Deletes a section from a SchoolClassModel.
  Future<void> deleteSection(
      String classId, List<SectionModel> updatedSections) async {
    try {
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .update({
        'sections': updatedSections.map((section) => section.toMap()).toList(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete section: $e');
      rethrow;
    }
  }

  /// Deletes all classes under a specific class name for a given school.
  Future<void> deleteClassesUnderClassName(
      String schoolId, String className) async {
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
