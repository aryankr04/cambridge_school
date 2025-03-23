import 'package:cloud_firestore/cloud_firestore.dart';

import 'app/modules/class_management/class_model.dart';
import 'app/modules/routine/routine_model.dart';
import 'core/services/firebase/firestore_service.dart';
import 'core/widgets/snack_bar.dart';

class ClassRepository {
  final FirestoreService _firestoreService;
  final String classCollection = 'classes'; // Define classCollection here

  ClassRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // ***************************** CRUD Operations *****************************

  /// Creates a new class in Firestore.
  Future<ClassModel> createClass(ClassModel classModel) async {
    try {
      final docRef = await _firestoreService.addDocument(
          classCollection, classModel.toMap(), // Use classCollection
          documentId: classModel.id);
      return classModel;
    } catch (e) {
      print('Error creating class: $e');
      rethrow;
    }
  }

  /// Retrieves a class from Firestore by its ID.
  Future<ClassModel?> getClassById(String classId) async {
    try {
      final docSnapshot = await _firestoreService.getDocumentById(
          classCollection, classId); // Use classCollection
      return ClassModel.fromMap(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      print('Error getting class by ID: $e');
      return null; // Or rethrow if appropriate
    }
  }

  Future<ClassModel?> fetchClassByClassNameAndSchoolId(
      String schoolId, String className) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: schoolId)
          .where('className', isEqualTo: className)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ClassModel.fromMap(
            snapshot.docs.first.data(), snapshot.docs.first.id);
      } else {
        return null;
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class by class name: $e');
      return null;
    }
  }

  /// Updates an existing class in Firestore.
  Future<void> updateClass(ClassModel classModel) async {
    try {
      await _firestoreService.updateDocument(
          classCollection, classModel.id, classModel.toMap()); // Use classCollection
    } catch (e) {
      print('Error updating class: $e');
      rethrow;
    }
  }

  /// Deletes a class from Firestore.
  Future<void> deleteClass(String classId) async {
    try {
      await _firestoreService.deleteDocument(
          classCollection, classId); // Use classCollection
    } catch (e) {
      print('Error deleting class: $e');
      rethrow;
    }
  }

  // ***************************** Query Operations *****************************

  /// Retrieves all classes from Firestore.
  Future<List<ClassModel>> getAllClasses() async {
    try {
      final querySnapshot = await _firestoreService.getAllDocuments(
          classCollection); // Use classCollection
      return querySnapshot
          .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting all classes: $e');
      return [];
    }
  }

  /// Queries classes based on a specific field and value.
  Future<List<ClassModel>> queryClasses(String fieldName, dynamic value) async {
    try {
      final querySnapshot = await _firestoreService.queryDocuments(
          classCollection, fieldName, value);
      return querySnapshot
          .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error querying classes: $e');
      return []; // Or rethrow if appropriate
    }
  }

  // ***************************** Stream Operations ****************************

  /// Returns a stream of a single class document.
  Stream<ClassModel?> getClassStream(String classId) {
    return _firestoreService
        .getDocumentStream(classCollection, classId)
        .map((snapshot) {
      if (snapshot.exists) {
        return ClassModel.fromMap(snapshot.data()!, snapshot.id);
      } else {
        return null;
      }
    });
  }

  /// Returns a stream of all classes.
  Stream<List<ClassModel>> getAllClassesStream() {
    return _firestoreService
        .getCollectionStream(classCollection) // Use classCollection
        .map((docs) => docs
        .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // ***************************** Additional Methods ***************************

  /// Add a Section to a class.  Note: This retrieves, modifies, then updates the whole class document.
  Future<void> addSectionToClass(String classId, SectionModel section) async {
    try {
      final classModel = await getClassById(classId);
      if (classModel != null) {
        classModel.addSection(section);
        await updateClass(classModel);
      } else {
        throw Exception('Class not found with ID: $classId');
      }
    } catch (e) {
      print('Error adding section to class: $e');
      rethrow;
    }
  }

  /// Update a Section in a class. Note: This retrieves, modifies, then updates the whole class document.
  Future<void> updateSectionInClass(
      String classId, String sectionName, SectionModel updatedSection) async {
    try {
      final classModel = await getClassById(classId);
      if (classModel != null) {
        classModel.updateSection(sectionName, updatedSection);
        await updateClass(classModel);
      } else {
        throw Exception('Class not found with ID: $classId');
      }
    } catch (e) {
      print('Error updating section in class: $e');
      rethrow;
    }
  }

  /// Delete a Section from a class. Note: This retrieves, modifies, then updates the whole class document.
  Future<void> deleteSectionFromClass(String classId, String sectionName) async {
    try {
      final classModel = await getClassById(classId);
      if (classModel != null) {
        classModel.deleteSection(sectionName);
        await updateClass(classModel);
      } else {
        throw Exception('Class not found with ID: $classId');
      }
    } catch (e) {
      print('Error deleting section from class: $e');
      rethrow;
    }
  }

  Future<void> addEventToRoutine(
      String classId, String sectionName, String day, Event event) async {
    try {
      final classModel = await getClassById(classId);
      if (classModel != null) {
        classModel.addEventToRoutine(sectionName, day, event);
        await updateClass(classModel);
      } else {
        throw Exception('Class not found with ID: $classId');
      }
    } catch (e) {
      print('Error adding event to routine: $e');
      rethrow;
    }
  }

  Future<void> updateEventInRoutine(String classId, String sectionName,
      String day, int index, Event updatedEvent) async {
    try {
      final classModel = await getClassById(classId);
      if (classModel != null) {
        classModel.updateEventInRoutine(sectionName, day, index, updatedEvent);
        await updateClass(classModel);
      } else {
        throw Exception('Class not found with ID: $classId');
      }
    } catch (e) {
      print('Error updating event in routine: $e');
      rethrow;
    }
  }

  Future<void> deleteEventInRoutine(
      String classId, String sectionName, String day, int index) async {
    try {
      final classModel = await getClassById(classId);
      if (classModel != null) {
        classModel.deleteEventInRoutine(sectionName, day, index);
        await updateClass(classModel);
      } else {
        throw Exception('Class not found with ID: $classId');
      }
    } catch (e) {
      print('Error deleting event in routine: $e');
      rethrow;
    }
  }

  Future<String> generateClassId(String prefix) async {
    return await _firestoreService.generateNewIdWithPrefix(
        prefix, classCollection); // Use classCollection
  }
}