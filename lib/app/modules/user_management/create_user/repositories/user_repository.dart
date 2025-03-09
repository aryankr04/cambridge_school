import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/services/firebase/firestore_service.dart';
import '../models/roles.dart';
import '../models/user_model.dart';

class UserRepository {
  //----------------------------------------------------------------------------
  // Constants

  static const String userCollection = 'users'; // Collection name in Firestore

  //----------------------------------------------------------------------------
  // Instance Variables

  final FirestoreService _firestoreService = FirestoreService();

  //----------------------------------------------------------------------------
  // Utility Methods (Private)

  /// Converts a Firestore document to a `UserModel` object.
  UserModel _documentToUser(DocumentSnapshot doc) =>
      UserModel.fromMap(doc.data() as Map<String, dynamic>)!;

  /// Extracts role names from a list of `UserRole` objects.
  List<String> _roleNames(List<UserRole> roles) =>
      roles.map((role) => role.name.toLowerCase()).toList();

  //----------------------------------------------------------------------------
  // Core CRUD Operations

  /// Creates a new user document in Firestore.  Important: no unique constraint on phone number.
  Future<void> createUser(UserModel user) async {
    try {
      await _firestoreService.addDocument(userCollection, user.toMap());
      await FirebaseFirestore.instance.collection(userCollection).doc(user.userId).set(user.toMap());//no
      print('User created successfully with ID: ${user.userId}');
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Retrieves a user document from Firestore by its `userId`.
  Future<UserModel?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestoreService.getDocumentById(userCollection, userId);

      return doc.exists ? _documentToUser(doc) : null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Deletes a user document from Firestore by its `userId`.
  Future<void> deleteUser(String userId) async {
    try {
      await _firestoreService.deleteDocument(userCollection, userId);
      print('User deleted successfully with ID: ${userId}');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Query Operations

  /// Retrieves all users from Firestore.
  Future<List<UserModel>> getAllUsers() async {
    try {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> querySnapshot =
      await _firestoreService.getAllDocuments(userCollection);

      return querySnapshot.map((doc) => _documentToUser(doc)).toList();
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
    }
  }

  /// Gets all users with a specific phone number. This is KEY.
  Future<List<UserModel>> getUsersByPhoneNumber(String phoneNumber) async {
    try {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> querySnapshot =
      await _firestoreService.queryDocuments(userCollection, 'phoneNo', phoneNumber);

      return querySnapshot.map((doc) => _documentToUser(doc)).toList();
    } catch (e) {
      print('Error getting users by phone number: $e');
      return [];
    }
  }

  /// Retrieves users from Firestore based on a single `UserRole`.
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .where('roles', arrayContains: role.name.toLowerCase())
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error fetching users by role: $e');
      return [];
    }
  }

  /// Searches users by name using a `searchTerm`.
  Future<List<UserModel>> searchUsersByName(String searchTerm) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .where('fullName', isGreaterThanOrEqualTo: searchTerm)
          .where('fullName', isLessThan: '${searchTerm}z')
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error searching users by name: $e');
      return [];
    }
  }

  /// Retrieves users from Firestore that have *any* of the specified `roles`.
  Future<List<UserModel>> getUsersByMultipleRoles(
      List<UserRole> roles) async {
    try {
      final roleNames = _roleNames(roles);

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .where('roles', arrayContainsAny: roleNames)
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error fetching users by multiple roles: $e');
      return [];
    }
  }

  /// Retrieves users from Firestore that have *all* of the specified `roles`.
  Future<List<UserModel>> getUsersByAllRoles(List<UserRole> roles) async {
    try {
      final roleNames = _roleNames(roles);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(userCollection)
          .where('roles', arrayContains: roleNames[0])
          .get();

      List<UserModel> results =
      querySnapshot.docs.map(_documentToUser).toList();

      for (int i = 1; i < roleNames.length; i++) {
        results.removeWhere((user) =>
        user.roles?.any((role) => role.name == roleNames[i]) == false);
      }

      return results;
    } catch (e) {
      print("Error fetching users with all specified roles: $e");
      return [];
    }
  }

  //----------------------------------------------------------------------------
  // Stream Operations

  /// Returns a stream of `UserModel` objects from Firestore.
  Stream<List<UserModel>> getUserStream() {
    return FirebaseFirestore.instance.collection(userCollection).snapshots().map((snapshot) {
      return snapshot.docs.map(_documentToUser).toList();
    });
  }

  //----------------------------------------------------------------------------
  // Update Operations

  /// Updates a specific field in a user document.
  Future<void> updateUserField(
      String userId, String field, dynamic value) async {
    try {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(userId)
          .update({field: value});
      print('User field "$field" updated successfully for ID: $userId');
    } catch (e) {
      print('Error updating user field: $e');
      rethrow;
    }
  }
}