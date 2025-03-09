import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //----------------------------------------------------------------------------
  // Singleton Instance
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;

  //----------------------------------------------------------------------------
  // Instance Variables
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //----------------------------------------------------------------------------
  // Constructor (Private)
  FirestoreService._internal() {
    // Enable offline persistence and cache size
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  //----------------------------------------------------------------------------
  // CRUD Operations (Basic)

  /// Adds a new document to the specified collection.

  Future<DocumentReference<Map<String, dynamic>>> addDocument(
      String collectionPath, Map<String, dynamic> data, {String? documentId}) async {
    try {
      if (documentId != null) {
        // Set document with a custom ID
        DocumentReference<Map<String, dynamic>> docRef =
        _firestore.collection(collectionPath).doc(documentId);
        await docRef.set(data);
        return docRef;
      } else {
        // Add a document with an auto-generated ID
        return await _firestore.collection(collectionPath).add(data);
      }
    } catch (e) {
      print('Add Document Error: $e');
      rethrow;
    }
  }


  /// Retrieves a document from the specified collection by its ID.
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String collectionPath, String documentId) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(documentId).get();
      if (!doc.exists) {
        throw Exception('Document not found: $documentId in $collectionPath');
      }
      return doc;
    } catch (e) {
      print('Get Document Error: $e');
      rethrow;
    }
  }

  /// Updates an existing document in the specified collection.
  Future<void> updateDocument(
      String collectionPath, String documentId, Map<String, dynamic> data) async {
    try {
      WriteBatch batch = _firestore.batch();
      DocumentReference docRef = _firestore.collection(collectionPath).doc(documentId);
      batch.update(docRef, data);
      await batch.commit();
    } catch (e) {
      print('Update Document Error: $e');
      rethrow;
    }
  }

  /// Deletes a document from the specified collection.
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      WriteBatch batch = _firestore.batch();
      DocumentReference docRef = _firestore.collection(collectionPath).doc(documentId);
      batch.delete(docRef);
      await batch.commit();
    } catch (e) {
      print('Delete Document Error: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Query Operations

  /// Retrieves all documents from the specified collection.
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllDocuments(
      String collectionPath) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(collectionPath).get();
      return snapshot.docs;
    } catch (e) {
      print('Get All Documents Error: $e');
      rethrow;
    }
  }

  /// Queries documents in the specified collection based on a field value.
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> queryDocuments(
      String collectionPath, String fieldName, dynamic value) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(collectionPath)
          .where(fieldName, isEqualTo: value)
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Query Documents Error: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Stream Operations (Real-time)

  /// Returns a real-time stream of a single document in the specified collection.
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String collectionPath, String documentId) {
    return _firestore.collection(collectionPath).doc(documentId).snapshots();
  }

  /// Returns a real-time stream of all documents in the specified collection.
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getCollectionStream(
      String collectionPath) {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) => snapshot.docs);
  }

  //----------------------------------------------------------------------------
  // ID Generation

  /// Generates a new, unique ID with a prefix for a given collection.
  Future<String> generateNewIdWithPrefix(String prefix, String collection) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      int newNumericPart = 1; // Default value if the collection is empty

      if (querySnapshot.docs.isNotEmpty) {
        String latestId = querySnapshot.docs.first.id;
        int latestNumericPart = int.tryParse(latestId.substring(prefix.length)) ?? 0;
        newNumericPart = latestNumericPart + 1;
      }

      return '$prefix${newNumericPart.toString().padLeft(10, '0')}';
    } catch (e) {
      print('Error generating new ID with prefix: $e');
      rethrow;
    }
  }
}