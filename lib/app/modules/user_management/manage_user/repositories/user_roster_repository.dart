import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/services/firebase/firestore_service.dart';
import '../models/roster_model.dart';

class UserRosterRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'user_rosters';

  String schoolId;
  UserRosterRepository({required this.schoolId});

  /// Adds a new UserRoster to Firestore.
  Future<String> addUserRoster(UserRoster userRoster) async {
    try {
      // Sort students by roll number, handling both null and type safety
      if (userRoster.rosterType == UserRosterType.studentRoster) {
        userRoster.userList.sort((a, b) {
          int rollA =
              int.tryParse(a.studentDetails?.rollNumber?.toString() ?? '') ?? 0;
          int rollB =
              int.tryParse(b.studentDetails?.rollNumber?.toString() ?? '') ?? 0;
          return rollA.compareTo(rollB);
        });
      }
      final docRef = await _firestoreService.addDocument(
          _collectionPath, userRoster.toMap(),
          documentId: userRoster.id);
      return docRef.id;
    } catch (e) {
      print('Error adding user roster: $e');
      rethrow;
    }
  }

  /// Gets a roster by className, sectionName and schoolId.
  /// Returns the first match, or null if no match is found.
  Future<UserRoster?> getClassRoster({
    required String className,
    required String sectionName,
    required String schoolId,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(_collectionPath)
          .where('className', isEqualTo: className)
          .where('sectionName', isEqualTo: sectionName)
          .where('schoolId', isEqualTo: schoolId)
          .limit(1) // Add limit(1) to only fetch one document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserRoster.fromMap(querySnapshot.docs.first.data());
      } else {
        return null; // No documents found
      }
    } catch (e) {
      print('Error getting roster by class, section, and school: $e');
      return null; // Handle exceptions by returning null
    }
  }

  /// Gets employee rosters by schoolId.
  Future<UserRoster?> getEmployeeRosters(String schoolId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(_collectionPath)
          .where('rosterType', isEqualTo: 'employeeRoster')
          .where('schoolId', isEqualTo: schoolId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserRoster.fromMap(querySnapshot.docs.first.data());
      } else {
        return null; // No documents found
      }
    } catch (e) {
      print('Error getting employee rosters by school: $e');
      return null;
    }
  }

  /// Updates an existing UserRoster in Firestore.
  Future<void> updateUserRoster(UserRoster userRoster) async {
    try {
      if (userRoster.rosterType == UserRosterType.studentRoster) {
        userRoster.userList.sort((a, b) {
          int rollA =
              int.tryParse(a.studentDetails?.rollNumber?.toString() ?? '') ?? 0;
          int rollB =
              int.tryParse(b.studentDetails?.rollNumber?.toString() ?? '') ?? 0;
          return rollA.compareTo(rollB);
        });
      }
      await _firestoreService.updateDocument(
          _collectionPath, userRoster.id, userRoster.toMap());
    } catch (e) {
      print('Error updating user roster: $e');
      rethrow;
    }
  }

  /// Deletes a UserRoster from Firestore.
  Future<void> deleteUserRoster(String rosterId) async {
    try {
      await _firestoreService.deleteDocument(_collectionPath, rosterId);
    } catch (e) {
      print('Error deleting user roster: $e');
      rethrow;
    }
  }

  /// Retrieves all UserRosters from Firestore.
  Future<List<UserRoster>> getAllUserRosters() async {
    try {
      final querySnapshot =
          await _firestoreService.getAllDocuments(_collectionPath);
      return querySnapshot
          .map((doc) => UserRoster.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting all user rosters: $e');
      return [];
    }
  }

  /// Queries UserRosters based on a specific field value.
  Future<List<UserRoster>> queryUserRosters(
      String fieldName, dynamic value) async {
    try {
      final querySnapshot = await _firestoreService.queryDocuments(
          _collectionPath, fieldName, value);

      return querySnapshot
          .map((doc) => UserRoster.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error querying user rosters: $e');
      return []; // Or rethrow
    }
  }

  /// Returns a stream of a single UserRoster from Firestore.
  Stream<UserRoster?> getUserRosterStream(String rosterId) {
    return _firestoreService
        .getDocumentStream(_collectionPath, rosterId)
        .map((docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserRoster.fromMap(docSnapshot.data()!);
      }
      return null;
    });
  }

  /// Generates a new ID for UserRoster documents with a prefix.
  Future<String> generateNewRosterId(String schoolId) async {
    try {
      final prefix = 'ROSTER_${schoolId}_'; // Prefix includes schoolId
      return await _firestoreService.generateNewIdWithPrefix(
          prefix, _collectionPath);
    } catch (e) {
      print('Error generating new roster ID: $e');
      rethrow;
    }
  }
}
