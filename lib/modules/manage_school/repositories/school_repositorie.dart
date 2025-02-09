// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../../data/services/firebase/firbase_services.dart';
// import '../models/school_model.dart';
//
//
// class SchoolRepository {
//   final FirebaseService _firebaseService = FirebaseService();
//
//   // Add a new school to Firestore
//   Future<void> addSchool(School school) async {
//     try {
//       // Convert the School instance to a JSON map
//       Map<String, dynamic> schoolData = school.toJson();
//
//       // Add school data to Firestore
//       await _firebaseService.addDocument('schools', school.schoolId, schoolData);
//
//       print('School added successfully!');
//     } catch (e) {
//       print('Error adding school: $e');
//       rethrow;
//     }
//   }
//
//   // Retrieve a school document by ID
//   Future<School?> getSchoolById(String id) async {
//     try {
//       DocumentSnapshot doc = await _firebaseService.getDocument('schools', id);
//       if (doc.exists) {
//         return School.fromJson(doc.data() as Map<String, dynamic>);
//       } else {
//         print('School not found');
//         return null;
//       }
//     } catch (e) {
//       print('Error retrieving school: $e');
//       rethrow;
//     }
//   }
//
//   // Update a school document
//   Future<void> updateSchool(School school) async {
//     try {
//       Map<String, dynamic> schoolData = school.toJson();
//       await _firebaseService.updateDocument('schools', school.schoolId, schoolData);
//       print('School updated successfully!');
//     } catch (e) {
//       print('Error updating school: $e');
//       rethrow;
//     }
//   }
//
//   // Delete a school document
//   Future<void> deleteSchool(String id) async {
//     try {
//       await _firebaseService.deleteDocument('schools', id);
//       print('School deleted successfully!');
//     } catch (e) {
//       print('Error deleting school: $e');
//       rethrow;
//     }
//   }
//
//   // Retrieve all schools
//   Future<List<School>> getAllSchools() async {
//     try {
//       QuerySnapshot snapshot = await _firebaseService.getCollection('schools');
//       return snapshot.docs.map((doc) => School.fromJson(doc.data() as Map<String, dynamic>)).toList();
//     } catch (e) {
//       print('Error retrieving schools: $e');
//       rethrow;
//     }
//   }
//
// // Additional methods for school operations can be added here
// }
