import 'package:cloud_firestore/cloud_firestore.dart';

import 'notice_model.dart';

class NoticeRosterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String noticeRosterCollection = 'noticeRosters';

  /// Retrieves a NoticeRoster for a given school and academic year.
  Future<NoticeRoster?> getNoticeRoster({
    required String schoolId,
    required String academicYear,
  }) async {
    try {
      final doc = await _firestore
          .collection(noticeRosterCollection)
          .doc('$schoolId-$academicYear')
          .get();

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

  /// Creates a new NoticeRoster.
  Future<void> createNoticeRoster(NoticeRoster noticeRoster) async {
    try {
      final docRef = _firestore
          .collection(noticeRosterCollection)
          .doc('${noticeRoster.schoolId}-${noticeRoster.academicYear}');

      // Convert Notice objects to Map
      List<Map<String, dynamic>> noticeMaps =
      noticeRoster.notices.map((notice) => notice.toMap()).toList();

      await docRef.set({
        'schoolId': noticeRoster.schoolId,
        'academicYear': noticeRoster.academicYear,
        'notices': noticeMaps,
      });
    } catch (e) {
      print('Error creating NoticeRoster: $e');
      rethrow; // Or handle the error as appropriate
    }
  }

  /// Updates an existing NoticeRoster.
  Future<void> updateNoticeRoster(NoticeRoster noticeRoster) async {
    try {
      final docRef = _firestore
          .collection(noticeRosterCollection)
          .doc('${noticeRoster.schoolId}-${noticeRoster.academicYear}');

      List<Map<String, dynamic>> noticeMaps =
      noticeRoster.notices.map((notice) => notice.toMap()).toList();

      await docRef.update({
        'notices': noticeMaps,
      });
    } catch (e) {
      print('Error updating NoticeRoster: $e');
      rethrow; // Or handle the error as appropriate
    }
  }

  Future<List<Notice>> getAllNotices(
      String schoolId, String academicYear) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('noticeRosters')
          .doc('${schoolId}-${academicYear}')
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
        docSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('notices')) {
          List<dynamic> noticeMaps = data['notices'] as List<dynamic>;

          //Iterate with a index i and generate the list with the new parameter to get a Notice with the documentId attribute in null
          List<Notice> notices = List<Notice>.generate(noticeMaps.length, (i) {
            return Notice.fromMap(noticeMaps[i] as Map<String, dynamic>);
          });

          return notices;
        } else {
          // 'notices' field does not exist in the document
          return [];
        }
      } else {
        // Document does not exist
        return [];
      }
    } catch (e) {
      print("Error fetching notices: $e");
      return []; // Return an empty list in case of error
    }
  }

  /// Adds a new notice to an existing NoticeRoster, or creates a new one if it doesn't exist.
  Future<void> addNoticeToRoster({
    required String schoolId,
    required String academicYear,
    required Notice notice,
  }) async {
    try {
      final docRef = _firestore
          .collection(noticeRosterCollection)
          .doc('$schoolId-$academicYear');

      final doc = await docRef.get();

      if (!doc.exists) {
        // NoticeRoster does not exist, create it with the new notice
        await docRef.set({
          'schoolId': schoolId,
          'academicYear': academicYear,
          'notices': [notice.toMap()], // Initialize with the new notice
        });
        return; // Exit the function after creating the roster
      }

      // NoticeRoster exists, add the new notice to the existing notices array
      await docRef.update({
        'notices': FieldValue.arrayUnion([notice.toMap()])
      });
    } catch (e) {
      print('Error adding notice to NoticeRoster: $e');
      rethrow;
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
      final docRef = _firestore
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

  /// Deletes a notice from an existing NoticeRoster.  It identifies the notice by its title.
  Future<void> deleteNoticeFromRoster({
    required String schoolId,
    required String academicYear,
    required String noticeTitle,
  }) async {
    try {
      final docRef = _firestore
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

  ///Deletes entire notice roster
  Future<void> deleteNoticeRoster({
    required String schoolId,
    required String academicYear,
  }) async {
    try {
      final docRef = _firestore
          .collection(noticeRosterCollection)
          .doc('$schoolId-$academicYear');

      await docRef.delete();
    } catch (e) {
      print('Error deleting NoticeRoster: $e');
      rethrow;
    }
  }

//Consider adding methods for filtering notices based on category, importance, etc.
}