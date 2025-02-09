import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Adjust the path if needed

class UserRepository {
  static const String userCollection = 'users'; // Collection name in Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Utility Methods ---

  /// Converts a Firestore document snapshot to a UserModelMain object.
  UserModelMain _documentToUser(DocumentSnapshot doc) =>
      UserModelMain.fromMap(doc.data() as Map<String, dynamic>)!; // Converts Firestore document to user model

  /// Converts a list of UserRole enums to a list of lowercase role names.
  List<String> _roleNames(List<UserRole> roles) =>
      roles.map((role) => role.name.toLowerCase()).toList(); // Converts roles to lowercase string names

  // --- Core CRUD Operations ---

  /// Creates a new user document in Firestore.
  Future<void> createUser(UserModelMain user) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(user.userId)
          .set(user.toMap());
      print('User created successfully with ID: ${user.userId}');
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Retrieves a user document from Firestore by its `userId`.
  Future<UserModelMain?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(userCollection)
          .doc(userId)
          .get();

      return doc.exists ? _documentToUser(doc) : null; // Returns user if exists, otherwise null
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Updates an existing user document in Firestore.
  Future<void> updateUser(UserModelMain user) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(user.userId)
          .update(user.toMap());
      print('User updated successfully with ID: ${user.userId}');
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

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

  /// Fetches all user documents from Firestore.
  Future<List<UserModelMain>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
      await _firestore.collection(userCollection).get();

      return querySnapshot.docs.map(_documentToUser).toList(); // Returns all users from Firestore
    } catch (e) {
      print('Error fetching all users: $e');
      return [];
    }
  }

  /// Fetches user documents from Firestore with a specific `role`.
  Future<List<UserModelMain>> getUsersByRole(UserRole role) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('roles', arrayContains: role.name.toLowerCase())
          .get();

      return querySnapshot.docs.map(_documentToUser).toList(); // Returns users with the specified role
    } catch (e) {
      print('Error fetching users by role: $e');
      return [];
    }
  }

  /// Searches for user documents in Firestore by `fullName`.
  Future<List<UserModelMain>> searchUsersByName(String searchTerm) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('fullName', isGreaterThanOrEqualTo: searchTerm)
          .where('fullName', isLessThan: searchTerm + 'z')
          .get();

      return querySnapshot.docs.map(_documentToUser).toList(); // Returns users matching the search term
    } catch (e) {
      print('Error searching users by name: $e');
      return [];
    }
  }

  // --- Complex Querying Operations ---

  /// Fetches users with *any* of the specified roles.
  Future<List<UserModelMain>> getUsersByMultipleRoles(
      List<UserRole> roles) async {
    try {
      final roleNames = _roleNames(roles);

      final QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('roles', arrayContainsAny: roleNames)
          .get();

      return querySnapshot.docs.map(_documentToUser).toList(); // Returns users with any of the specified roles
    } catch (e) {
      print('Error fetching users by multiple roles: $e');
      return [];
    }
  }

  /// Fetches users with *all* of the specified roles.  Less efficient, use with caution.
  Future<List<UserModelMain>> getUsersByAllRoles(List<UserRole> roles) async {
    try {
      final roleNames = _roleNames(roles);

      QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('roles', arrayContains: roleNames[0])
          .get();

      List<UserModelMain> results =
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

  /// Returns a stream of user documents from Firestore.
  Stream<List<UserModelMain>> getUserStream() {
    return _firestore.collection(userCollection).snapshots().map((snapshot) {
      return snapshot.docs.map(_documentToUser).toList(); // Returns a stream of users
    });
  }

  // --- Update Field ---

  /// Updates a specific field of a user document in Firestore.
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