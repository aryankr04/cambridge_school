import 'package:cloud_firestore/cloud_firestore.dart';
import '../../create_user/models/user_model.dart';
import '../models/roster_model.dart';

class FirestoreRosterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String rostersCollection = 'rosters';

  // ----------------- Class Rosters -----------------

  // Add a Class Roster
  Future<void> addClassRoster(ClassRoster classRoster) async {
    try {
      final classRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc('class_roster')
          .collection('classes')
          .doc(classRoster.id);

      await classRosterDocRef.set(classRoster.toMap());
      print('Class roster added successfully: ${classRoster.classId}');
    } catch (e) {
      print('Error adding class roster: $e');
      rethrow;
    }
  }

  // Get a Class Roster
  Future<ClassRoster?> getClassRoster(String classId) async {
    try {
      final classRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc('class_roster')
          .collection('classes')
          .doc(classId);

      final docSnapshot = await classRosterDocRef.get();

      if (docSnapshot.exists) {
        return ClassRoster.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Class roster not found for class ID: $classId');
        return null;
      }
    } catch (e) {
      print('Error fetching class roster: $e');
      return null;
    }
  }

  // Helper function to compare students by roll number
  int _compareStudentsByRollNumber(UserModel a, UserModel b) {
    final rollNumberA = a.studentDetails?.rollNumber ?? '0';
    final rollNumberB = b.studentDetails?.rollNumber ?? '0';

    try {
      int rollA = int.parse(rollNumberA);
      int rollB = int.parse(rollNumberB);
      return rollA.compareTo(rollB);
    } catch (e) {
      print(
          'Invalid roll number format, sorting as string: $rollNumberA, $rollNumberB. Error: $e');
      return rollNumberA.compareTo(rollNumberB);
    }
  }

  Future<List<UserModel>> getAllUsersInClassRoster(
      String className, String section, String schoolId) async {
    List<UserModel> userList = [];

    try {
      // 1. Get the Class Roster Document
      QuerySnapshot classRosterQuery = await _firestore
          .collection(rostersCollection)
          .doc('class_roster')
          .collection('classes')
          .where('className', isEqualTo: className)
          .where('sectionName', isEqualTo: section)
          .where('schoolId', isEqualTo: schoolId)
          .get();

      if (classRosterQuery.docs.isEmpty) {
        print(
            'No Class Rosters found for className: $className, section: $section, schoolId: $schoolId');
        return userList;
      }

      DocumentSnapshot classRosterDoc =
          classRosterQuery.docs.first;
      ClassRoster classRoster = ClassRoster.fromMap(classRosterDoc.data() as Map<String, dynamic>)!;

      if (classRoster != null) {
        userList = classRoster.studentList;
      }

      // Sort userList by rollNumber, using the custom comparison function
      userList.sort(_compareStudentsByRollNumber);
    } catch (e) {
      print('Error fetching users from class roster: $e');
    }

    return userList;
  }
  // Update a Class Roster
  Future<void> updateClassRoster(ClassRoster classRoster) async {
    try {
      final classRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc('class_roster')
          .collection('classes')
          .doc(classRoster.classId);

      await classRosterDocRef
          .update(classRoster.toMap()); // Use update instead of set
      print('Class roster updated successfully: ${classRoster.classId}');
    } catch (e) {
      print('Error updating class roster: $e');
      rethrow;
    }
  }

  // Delete a Class Roster
  Future<void> deleteClassRoster(String classId) async {
    try {
      final classRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc('class_roster')
          .collection('classes')
          .doc(classId);

      await classRosterDocRef.delete();
      print('Class roster deleted successfully: $classId');
    } catch (e) {
      print('Error deleting class roster: $e');
      rethrow;
    }
  }

  // ----------------- User Rosters -----------------

  // Add a User Roster (for teachers, admins, etc.)
  Future<void> addUserRoster(UserRoster userRoster) async {
    try {
      final userRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc(userRoster.rosterType)
          .collection('schools')
          .doc(userRoster.schoolId);

      await userRosterDocRef.set(userRoster.toMap());
      print(
          'User roster added successfully: ${userRoster.rosterType} for school ${userRoster.schoolId}');
    } catch (e) {
      print('Error adding user roster: $e');
      rethrow;
    }
  }

  // Get a User Roster (for teachers, admins, etc.)
  Future<UserRoster?> getUserRoster(String rosterType, String schoolId) async {
    try {
      final userRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc(rosterType)
          .collection('schools')
          .doc(schoolId);

      final docSnapshot = await userRosterDocRef.get();

      if (docSnapshot.exists) {
        return UserRoster.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('User roster not found: $rosterType for school ID: $schoolId');
        return null;
      }
    } catch (e) {
      print('Error fetching user roster: $e');
      return null;
    }
  }

  //Get all the users of a Roster
  Future<List<UserModel>> getAllUsersInUserRoster(
      String rosterType, String schoolId) async {
    List<UserModel> userList = [];

    try {
      // 1. Get the User Roster
      final userRoster = await getUserRoster(rosterType, schoolId);

      if (userRoster == null) {
        print('User roster not found: $rosterType for school ID: $schoolId');
        return userList; // Return empty list if roster doesn't exist
      }

      // 2. Access the userList directly from the UserRoster object
      userList = userRoster
          .userList; // DIRECT ACCESS to the list of UserModel objects!
    } catch (e) {
      print('Error fetching users from roster: $e');
    }

    return userList;
  }

  // Update a User Roster
  Future<void> updateUserRoster(UserRoster userRoster) async {
    try {
      final userRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc(userRoster.rosterType)
          .collection('schools')
          .doc(userRoster.schoolId);

      await userRosterDocRef
          .update(userRoster.toMap()); // Use update instead of set
      print(
          'User roster updated successfully: ${userRoster.rosterType} for school ${userRoster.schoolId}');
    } catch (e) {
      print('Error updating user roster: $e');
      rethrow;
    }
  }

  // Delete a User Roster
  Future<void> deleteUserRoster(String rosterType, String schoolId) async {
    try {
      final userRosterDocRef = _firestore
          .collection(rostersCollection)
          .doc(rosterType)
          .collection('schools')
          .doc(schoolId);

      await userRosterDocRef.delete();
      print(
          'User roster deleted successfully: $rosterType for school $schoolId');
    } catch (e) {
      print('Error deleting user roster: $e');
      rethrow;
    }
  }
}
