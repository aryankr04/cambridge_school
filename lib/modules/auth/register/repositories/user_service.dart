import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = "users";

  // Add a user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception("Failed to add user: $e");
    }
  }

  // Get a user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc =
      await _firestore.collection(_collectionName).doc(userId).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get user: $e");
    }
  }

  Future<UserModel?> getUserByRoles(List<String> roles) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('roles',
          arrayContainsAny: roles) // Check if the user has any of the roles
          .get();

      // Iterate through documents and find the first one matching the roles
      for (var doc in querySnapshot.docs) {
        var user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        return user; // Return the first user matching the roles
      }

      return null; // Return null if no user is found with the required roles
    } catch (e) {
      throw Exception("Failed to get user: $e");
    }
  }

  Future<UserModel?> getUserByMultipleConditions(Map<String, dynamic> conditions) async {
    try {
      Query query = _firestore.collection(_collectionName);

      // Apply each condition to the query
      conditions.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });

      // Execute the query
      final QuerySnapshot querySnapshot = await query.get();

      // If there are results, return the first one
      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }

      return null; // Return null if no user is found
    } catch (e) {
      throw Exception("Failed to get user: $e");
    }
  }


  // Update a user's details
  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .update(updatedFields);
    } catch (e) {
      throw Exception("Failed to update user: $e");
    }
  }

  // Delete a user by ID
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).delete();
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
      await _firestore.collection(_collectionName).get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to get all users: $e");
    }
  }
}
