import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/roles.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String userCollection = 'users'; // Collection name in Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Utility Methods ---
  UserModel _documentToUser(DocumentSnapshot doc) =>
      UserModel.fromMap(doc.data() as Map<String, dynamic>)!;

  List<String> _roleNames(List<UserRole> roles) =>
      roles.map((role) => role.name.toLowerCase()).toList();

  // --- Core CRUD Operations ---

  /// Creates a new user document in Firestore.  Important: no unique constraint on phone number.
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(user.userId)
          .set(user.toMap()); // Create a document with the generated userId.
      print('User created successfully with ID: ${user.userId}');
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Retrieves a user document from Firestore by its `userId`.
  Future<UserModel?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(userCollection)
          .doc(userId)
          .get();

      return doc.exists ? _documentToUser(doc) : null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Gets all users with a specific phone number. This is KEY.
  Future<List<UserModel>> getUsersByPhoneNumber(String phoneNumber) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('phoneNo', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error getting users by phone number: $e');
      return [];
    }
  }

  /// No longer needed, as we don't assume phone number uniqueness.
  // Future<UserModelMain?> getUserByPhoneNumber(String phoneNumber) async { ... }


  /// Deletes a user document from Firestore by its `userId`.
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(userId)
          .delete();
      print('User deleted successfully with ID: ${userId}');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // --- Querying Operations ---
  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
      await _firestore.collection(userCollection).get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
    }
  }

  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('roles', arrayContains: role.name.toLowerCase())
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error fetching users by role: $e');
      return [];
    }
  }

  Future<List<UserModel>> searchUsersByName(String searchTerm) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('fullName', isGreaterThanOrEqualTo: searchTerm)
          .where('fullName', isLessThan: searchTerm + 'z')
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error searching users by name: $e');
      return [];
    }
  }

  Future<List<UserModel>> getUsersByMultipleRoles(
      List<UserRole> roles) async {
    try {
      final roleNames = _roleNames(roles);

      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('roles', arrayContainsAny: roleNames)
          .get();

      return querySnapshot.docs.map(_documentToUser).toList();
    } catch (e) {
      print('Error fetching users by multiple roles: $e');
      return [];
    }
  }

  Future<List<UserModel>> getUsersByAllRoles(List<UserRole> roles) async {
    try {
      final roleNames = _roleNames(roles);

      QuerySnapshot querySnapshot = await _firestore
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

  // --- Stream ---

  Stream<List<UserModel>> getUserStream() {
    return _firestore.collection(userCollection).snapshots().map((snapshot) {
      return snapshot.docs.map(_documentToUser).toList();
    });
  }

  // --- Update Field ---
  Future<void> updateUserField(
      String userId, String field, dynamic value) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(userId)
          .update({field: value});
      print('User field "$field" updated successfully for ID: ${userId}');
    } catch (e) {
      print('Error updating user field: $e');
      rethrow;
    }
  }
}