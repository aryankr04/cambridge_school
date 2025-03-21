import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase/firestore_service.dart';


class FirestoreSchoolRepository {
  final FirestoreService _firestoreService = FirestoreService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'schools'; // Collection name in Firestore

  /// Creates a new school document in Firestore.
  Future<void> createSchool(SchoolModel school) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(school.schoolId) // Use schoolId as document ID for uniqueness
          .set(school.toMap());
      print('School created successfully with ID: ${school.schoolId}');
    } catch (e) {
      print('Error creating school: $e');
      rethrow; // Re-throw the error for handling in the calling function
    }
  }

  /// Retrieves a school document from Firestore by its ID.
  Future<SchoolModel?> getSchoolById(String schoolId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collectionName)
          .doc(schoolId)
          .get();

      if (docSnapshot.exists) {
        return SchoolModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('School with ID: $schoolId not found.');
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print('Error fetching school by ID: $e');
      rethrow; // Re-throw the error
    }
  }

  /// Updates an existing school document in Firestore.
  Future<void> updateSchool(SchoolModel school) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(school.schoolId)
          .update(school.toMap());
      print('School updated successfully with ID: ${school.schoolId}');
    } catch (e) {
      print('Error updating school: $e');
      rethrow; // Re-throw the error
    }
  }

  /// Deletes a school document from Firestore by its ID.
  Future<void> deleteSchool(String schoolId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(schoolId)
          .delete();
      print('School deleted successfully with ID: $schoolId');
    } catch (e) {
      print('Error deleting school: $e');
      rethrow; // Re-throw the error
    }
  }

  /// Retrieves all school documents from Firestore.
  Future<List<SchoolModel>> getAllSchools() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .get();

      return querySnapshot.docs.map((doc) => SchoolModel.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching all schools: $e');
      rethrow; // Re-throw the error
    }
  }

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

  ///  Streams all school documents from Firestore.  This allows for real-time updates.
  Stream<List<SchoolModel>> streamAllSchools() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SchoolModel.fromMap(doc.data()))
        .toList());
  }

  /// Stream single school by ID.
  Stream<SchoolModel?> streamSchoolById(String schoolId) {
    return _firestore
        .collection(_collectionName)
        .doc(schoolId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return SchoolModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  /// Queries schools based on a specific field and value. Useful for searching.
  Future<List<SchoolModel>> querySchools(String field, dynamic value) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where(field, isEqualTo: value)
          .get();

      return querySnapshot.docs.map((doc) => SchoolModel.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error querying schools: $e');
      rethrow; // Re-throw the error
    }
  }

// Add more specific query methods as needed (e.g., schools by city, schools by type, etc.)

  /// Adds a new class data to an existing school document in Firestore.
  Future<void> addClassData(String schoolId, ClassData classData) async {
    try {
      final schoolDocRef = _firestore.collection(_collectionName).doc(schoolId);

      // Get the current school document.
      final schoolDoc = await schoolDocRef.get();

      if (!schoolDoc.exists) {
        throw Exception('School with ID: $schoolId does not exist.');
      }

      // Get the current list of classes (if any).
      List<dynamic> currentClasses = [];
      if (schoolDoc.data() != null && schoolDoc.data()!.containsKey('classes')) {
        currentClasses = List.from(schoolDoc.data()!['classes']);
      }

      // Add the new class data to the list.
      currentClasses.add(classData.toMap());

      // Update the 'classes' field in the Firestore document with the updated list.
      await schoolDocRef.update({'classes': currentClasses});

      print('Class data added successfully to school with ID: $schoolId');
    } catch (e) {
      print('Error adding class data: $e');
      rethrow; // Re-throw the error
    }
  }

}