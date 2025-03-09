import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/firebase/firestore_service.dart';
import 'notice_model.dart';

class NoticeRosterRepository {
  //----------------------------------------------------------------------------
  // Instance Variables
  final FirestoreService _firestoreService = FirestoreService();
  final String noticeRosterCollection = 'notice_rosters';

  //----------------------------------------------------------------------------
  // Get Operations

  /// Retrieves a NoticeRoster for a given school and academic year.
  Future<NoticeRoster?> getNoticeRoster({
    required String schoolId,
    required String academicYear,
  }) async {
    try {
      final doc = await _firestoreService.getDocumentById(
        noticeRosterCollection,
        '$schoolId-$academicYear',
      );

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        List<dynamic> noticeMaps = data['notices'] as List<dynamic>;

        List<Notice> notices = noticeMaps
            .map((noticeMap) => Notice.fromMap(noticeMap as Map<String, dynamic>))
            .toList();

        return NoticeRoster(
          schoolId: data['schoolId'] as String,
          academicYear: data['academicYear'] as String,
          notices: notices,
        );
      } else {
        return null; // Document not found
      }
    } catch (e) {
      print('Error fetching NoticeRoster: $e');
      return null;
    }
  }

  /// Retrieves all notices from a NoticeRoster for a given school and academic year.
  Future<List<Notice>> getAllNotices(String schoolId, String academicYear) async {
    try {
      print("Fetching notices for schoolId: $schoolId, academicYear: $academicYear");

      DocumentSnapshot docSnapshot = await _firestoreService.getDocumentById(
        noticeRosterCollection,
        '$schoolId-$academicYear',
      );

      if (docSnapshot.exists) {
        print("Document exists: ${docSnapshot.id}");

        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('notices')) {
          print("Notices field found in document");

          List<dynamic> noticeMaps = data['notices'] as List<dynamic>;

          print("Number of notices found: ${noticeMaps.length}");

          // Iterate through the notices and print each notice data
          for (int i = 0; i < noticeMaps.length; i++) {
            print("Notice $i data: ${noticeMaps[i]}");
          }

          // Generate the list of Notice objects
          List<Notice> notices = List<Notice>.generate(noticeMaps.length, (i) {
            return Notice.fromMap(noticeMaps[i] as Map<String, dynamic>);
          });

          print("Generated ${notices.length} Notice objects.");
          return notices;
        } else {
          print("No 'notices' field found in the document.");
          return [];
        }
      } else {
        print("Document does not exist for ID: $schoolId-$academicYear");
        return [];
      }
    } catch (e) {
      print("Error fetching notices: $e");
      return [];
    }
  }


  //----------------------------------------------------------------------------
  // Create Operations

  /// Creates a new NoticeRoster.
  Future<void> createNoticeRoster(NoticeRoster noticeRoster) async {
    try {
      final docRef = '$noticeRosterCollection/${noticeRoster.schoolId}-${noticeRoster.academicYear}';

      // Convert Notice objects to Map
      List<Map<String, dynamic>> noticeMaps =
      noticeRoster.notices.map((notice) => notice.toMap()).toList();

      await _firestoreService.addDocument(noticeRosterCollection, {
        'schoolId': noticeRoster.schoolId,
        'academicYear': noticeRoster.academicYear,
        'notices': noticeMaps,
      });
    } catch (e) {
      print('Error creating NoticeRoster: $e');
      rethrow; // Or handle the error as appropriate
    }
  }

  /// Adds a new notice to an existing NoticeRoster, or creates a new one if it doesn't exist.
  Future<void> addNoticeToRoster({
    required String schoolId,
    required String academicYear,
    required Notice notice,
  }) async {
    try {
      final docId = '$schoolId-$academicYear';
      final docRef = FirebaseFirestore.instance
          .collection(noticeRosterCollection)
          .doc(docId);

      // Use set with merge: true to create or update the document
      await docRef.set({
        'schoolId': schoolId,
        'academicYear': academicYear,
        'notices': FieldValue.arrayUnion([notice.toMap()]),
      }, SetOptions(merge: true));

    } catch (e) {
      print('Error adding notice to NoticeRoster: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Update Operations

  /// Updates an existing NoticeRoster.
  Future<void> updateNoticeRoster(NoticeRoster noticeRoster) async {
    try {
      final docRef = _firestoreService.getDocumentById(noticeRosterCollection, '${noticeRoster.schoolId}-${noticeRoster
          .academicYear}');

      List<Map<String, dynamic>> noticeMaps =
      noticeRoster.notices.map((notice) => notice.toMap()).toList();

      await FirebaseFirestore.instance
          .collection(noticeRosterCollection)
          .doc('${noticeRoster.schoolId}-${noticeRoster.academicYear}')
          .update({
        'notices': noticeMaps,
      });
    } catch (e) {
      print('Error updating NoticeRoster: $e');
      rethrow; // Or handle the error as appropriate
    }
  }

  /// Updates an existing notice within a NoticeRoster.  (discouraged, using createdTime)
  Future<void> updateNoticeInRoster({
    required String schoolId,
    required String academicYear,
    required DateTime createdTime, // Using createdTime as (discouraged) unique key
    required Notice notice, // The updated notice object
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(noticeRosterCollection)
          .doc('$schoolId-$academicYear');

      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('NoticeRoster not found for $schoolId - $academicYear');
      }

      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> noticeMaps = data['notices'] as List<dynamic>? ?? [];

      // Find the index of the notice to update based on the unique identifier (createdTime)
      int indexToUpdate = -1;
      for (int i = 0; i < noticeMaps.length; i++) {
        //This is the corrected comparison
        if (noticeMaps[i]['createdTime'] != null && (noticeMaps[i]['createdTime'] as Timestamp).toDate().isAtSameMomentAs(createdTime)) {
          indexToUpdate = i;
          break;
        }
      }

      if (indexToUpdate == -1) {
        throw Exception('Notice with createdTime "$createdTime" not found in roster.');
      }

      // Replace the old notice with the updated notice
      noticeMaps[indexToUpdate] = notice.toMap();

      // Update the document with the modified notices list
      await docRef.update({'notices': noticeMaps});
    } catch (e) {
      print('Error updating notice in NoticeRoster: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Delete Operations

  /// Deletes a notice from an existing NoticeRoster, identified by its title.
  Future<void> deleteNoticeFromRoster({
    required String schoolId,
    required String academicYear,
    required String noticeTitle,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(noticeRosterCollection)
          .doc('$schoolId-$academicYear');

      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('NoticeRoster not found for $schoolId - $academicYear');
      }

      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> noticeMaps = data['notices'] as List<dynamic>? ?? [];

      // Find the index of the notice to remove (based on title).
      int indexToRemove = -1;
      for (int i = 0; i < noticeMaps.length; i++) {
        if (noticeMaps[i]['title'] == noticeTitle) {
          indexToRemove = i;
          break;
        }
      }

      if (indexToRemove == -1) {
        throw Exception('Notice with title "$noticeTitle" not found in roster.');
      }

      // Create a new list excluding the notice to be deleted.
      noticeMaps.removeAt(indexToRemove);

      // Update the document with the modified notices list.
      await docRef.update({'notices': noticeMaps});
    } catch (e) {
      print('Error deleting notice from NoticeRoster: $e');
      rethrow;
    }
  }

  /// Deletes an entire NoticeRoster.
  Future<void> deleteNoticeRoster({
    required String schoolId,
    required String academicYear,
  }) async {
    try {
      await _firestoreService.deleteDocument(
        noticeRosterCollection,
        '$schoolId-$academicYear',
      );
    } catch (e) {
      print('Error deleting NoticeRoster: $e');
      rethrow;
    }
  }

//----------------------------------------------------------------------------
// Future Enhancements (Filtering and Sorting)

//Consider adding methods for filtering notices based on category, importance, etc.
}