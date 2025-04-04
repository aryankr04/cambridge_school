// Filename: management/admin/class_management/class_management_repository.dart
import 'package:cambridge_school/app/modules/school_management/school_repository.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/services/firebase/firestore_service.dart';
import '../../../../../core/widgets/snack_bar.dart';
import '../school_management/school_model.dart';
import 'class_model.dart';

class ClassRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final SchoolRepository schoolRepository = SchoolRepository();

  final String _collectionPath = 'classes';

  String _getFullCollectionPath() {
    return 'schools/$schoolId/$_collectionPath';
  }

  final String schoolId;

  ClassRepository({required this.schoolId});

  /// Creates a new ClassModel in Firestore using the existing ID.
  Future<String?> addClass(ClassModel classModel) async {
    try {
      await _firestoreService.addDocument(
          _getFullCollectionPath(), classModel.toMap(),
          documentId: classModel.id);
      schoolRepository.addClassToSchool(
          schoolId,
          ClassData(
              classId: classModel.id,
              className: classModel.className,
              sectionName: classModel.sections
                  .map((section) => section.sectionName)
                  .toList()));
      return classModel.id;
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error creating class: $e');
      return null;
    }
  }

  /// Fetches a class (SchoolClassModel) by className and schoolId.
  Future<ClassModel?> getClassByClassName(String className) async {
    try {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> results =
          await _firestoreService.queryDocuments(
              _getFullCollectionPath(), 'className', className);
      final result =
          results.where((element) => element['className'] == className);
      if (result.isNotEmpty) {
        return ClassModel.fromMap(result.first.data(), result.first.id);
      } else {
        return null;
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class by class name: $e');
      return null;
    }
  }

  /// Updates an existing ClassModel in Firestore.
  Future<void> updateClass(ClassModel classModel) async {
    try {
      await _firestoreService.updateDocument(
          _getFullCollectionPath(), classModel.id, classModel.toMap());
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error updating class: $e');
      rethrow;
    }
  }

  /// Deletes a ClassModel from Firestore.
  Future<void> deleteClass(String classId) async {
    try {
      await _firestoreService.deleteDocument(_getFullCollectionPath(), classId);
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error deleting class: $e');
      rethrow;
    }
  }

  /// Retrieves all ClassModels for a specific school.
  Future<List<ClassModel>> getClasses() async {
    try {
      final documents = await _firestoreService.queryDocuments(
          _getFullCollectionPath(), 'schoolId', schoolId);

      return documents
          .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error fetching classes by school ID: $e');
      return [];
    }
  }

  /// Streams all ClassModels for a specific school (for real-time updates).
  Stream<List<ClassModel>> streamClassesBySchoolId() {
    try {
      return _firestoreService
          .getCollectionStream(_getFullCollectionPath())
          .map((docs) => docs
              .where((doc) =>
                  doc['schoolId'] == schoolId) // Filtering on the client-side
              .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error streaming classes: $e');
      return Stream.value([]); // Return an empty stream in case of an error
    }
  }
}
