import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new document to a collection
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
      print('Document added successfully');
    } catch (e) {
      print('Add Document Error: $e');
    }
  }

  // Get a document by ID from a collection
  Future<DocumentSnapshot> getDocumentById(String collectionPath, String documentId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(collectionPath).doc(documentId).get();
      return docSnapshot;
    } catch (e) {
      print('Get Document Error: $e');
      rethrow;
    }
  }

  // Update an existing document
  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
      print('Document updated successfully');
    } catch (e) {
      print('Update Document Error: $e');
    }
  }

  // Delete a document
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Delete Document Error: $e');
    }
  }

  // Get all documents from a collection
  Future<QuerySnapshot> getAllDocuments(String collectionPath) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionPath).get();
      return snapshot;
    } catch (e) {
      print('Get All Documents Error: $e');
      rethrow;
    }
  }

  // Query documents based on a field value
  Future<QuerySnapshot> queryDocuments(String collectionPath, String fieldName, dynamic value) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where(fieldName, isEqualTo: value)
          .get();
      return snapshot;
    } catch (e) {
      print('Query Documents Error: $e');
      rethrow;
    }
  }

  // Listen to real-time updates of a document
  Stream<DocumentSnapshot> getDocumentStream(String collectionPath, String documentId) {
    try {
      return _firestore.collection(collectionPath).doc(documentId).snapshots();
    } catch (e) {
      print('Get Document Stream Error: $e');
      rethrow;
    }
  }

  // Listen to real-time updates of all documents in a collection
  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    try {
      return _firestore.collection(collectionPath).snapshots();
    } catch (e) {
      print('Get Collection Stream Error: $e');
      rethrow;
    }
  }
  static Future<String?> generateNewIdWithPrefix(
      String prefix, String collection) async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(collection).get();

      if (querySnapshot.docs.isEmpty) {
        return '$prefix${'0000000001'}';
      }

      String latestId = querySnapshot.docs.last.id;
      int latestNumericPart =
          int.tryParse(latestId.substring(prefix.length)) ?? 0;
      int newNumericPart = latestNumericPart + 1;
      return '$prefix${newNumericPart.toString().padLeft(10, '0')}';
    } catch (e) {
      print('Error generating new ID with prefix: $e');
      return null;
    }
  }
}
