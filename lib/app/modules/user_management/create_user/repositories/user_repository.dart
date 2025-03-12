import 'package:collection/collection.dart';
import '../../../../../core/services/firebase/firestore_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String _collectionPath = 'users';

  /// Adds or updates a user in Firestore.
  Future<void> addUserOrUpdate(UserModel user) async {
    try {
      await _firestoreService.addDocument(
        _collectionPath,
        user.toMap(),
        documentId: user.userId,
      );
    } catch (e) {
      print('Error adding/updating user: $e');
      rethrow;
    }
  }

  /// Deletes a user from Firestore by userId.
  Future<void> deleteUserByUserId(String userId) async {
    try {
      await _firestoreService.deleteDocument(_collectionPath, userId);
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Retrieves a user from Firestore by userId. Returns null if not found.
  Future<UserModel?> getUserById(String userId) async {
    try {
      final documentSnapshot =
          await _firestoreService.getDocumentById(_collectionPath, userId);
      return UserModel.fromMap(documentSnapshot.data()!);
    } catch (e) {
      if (e is Exception && e.toString().contains('Document not found')) {
        return null;
      }
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  /// Retrieves a list of users from Firestore by phoneNumber.
  Future<List<UserModel>> getUsersByPhoneNumber(String phoneNumber) async {
    try {
      final querySnapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        'phoneNo',
        phoneNumber,
      );
      return querySnapshot
          .map((doc) => UserModel.fromMap(doc.data())!)
          .toList();
    } catch (e) {
      print('Error getting users by phone number: $e');
      rethrow;
    }
  }

  /// Retrieves all users in a school from Firestore by schoolId.
  Future<List<UserModel>> getUsersBySchoolId(String schoolId) async {
    try {
      final querySnapshot = await _firestoreService.queryDocuments(
        _collectionPath,
        'schoolId',
        schoolId,
      );
      return querySnapshot
          .map((doc) => UserModel.fromMap(doc.data())!)
          .toList();
    } catch (e) {
      print('Error getting users by schoolId: $e');
      rethrow;
    }
  }

  /// Returns a real-time stream of a single user. Returns null if the user does not exist.
  Stream<UserModel?> getUserStream(String userId) {
    return _firestoreService.getDocumentStream(_collectionPath, userId).map(
        (snapshot) =>
            snapshot.exists ? UserModel.fromMap(snapshot.data()!) : null);
  }

  /// Returns a real-time stream of all users in the specified school.
  Stream<List<UserModel>> getUsersCollectionStream(String schoolId) {
    return _firestoreService
        .queryDocuments(_collectionPath, 'schoolId', schoolId)
        .then((querySnapshot) =>
            querySnapshot.map((doc) => UserModel.fromMap(doc.data())!).toList())
        .asStream();
  }

  /// Updates a user only if different from the existing user.
  Future<void> updateUserIfDifferent(UserModel newUser) async {
    try {
      final existingUser = await getUserById(newUser.userId);

      if (existingUser == null) {
        await addUserOrUpdate(newUser);
        print('User ${newUser.userId} added as it did not exist.');
        return;
      }

      if (const DeepCollectionEquality().equals(
        newUser.toMap(),
        existingUser.toMap(),
      )) {
        print('User ${newUser.userId} is the same. No update needed.');
        return;
      }

      await addUserOrUpdate(newUser);
      print('User ${newUser.userId} updated as it was different.');
    } catch (e) {
      print('Error updating user (with comparison): $e');
      rethrow;
    }
  }
}
