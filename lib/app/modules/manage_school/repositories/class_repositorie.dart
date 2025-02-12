// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../../data/services/firebase/firbase_services.dart';
//
//
// class ClassRepository {
//   final FirebaseService _firebaseService = FirebaseService();
//
//   // Add a new class to Firestore
//   Future<void> addClass(Class class) async {
//   try {
//   // Convert the Class instance to a JSON map
//   Map<String, dynamic> classData = class.toJson();
//
//   // Add class data to Firestore
//   await _firebaseService.addDocument('classes', class.id, classData);
//
//   print('Class added successfully!');
//   } catch (e) {
//   print('Error adding class: $e');
//   rethrow;
//   }
//   }
//
//   // Retrieve a class document by ID
//   Future<Class?> getClassById(String id) async {
//   try {
//   DocumentSnapshot doc = await _firebaseService.getDocument('classes', id);
//   if (doc.exists) {
//   return Class.fromJson(doc.data() as Map<String, dynamic>);
//   } else {
//   print('Class not found');
//   return null;
//   }
//   } catch (e) {
//   print('Error retrieving class: $e');
//   rethrow;
//   }
//   }
//
//   // Update a class document
//   Future<void> updateClass(Class class) async {
//   try {
//   Map<String, dynamic> classData = class.toJson();
//   await _firebaseService.updateDocument('classes', class.id, classData);
//   print('Class updated successfully!');
//   } catch (e) {
//   print('Error updating class: $e');
//   rethrow;
//   }
//   }
//
//   // Delete a class document
//   Future<void> deleteClass(String id) async {
//   try {
//   await _firebaseService.deleteDocument('classes', id);
//   print('Class deleted successfully!');
//   } catch (e) {
//   print('Error deleting class: $e');
//   rethrow;
//   }
//   }
//
//   // Retrieve all classes
//   Future<List<Class>> getAllClasses() async {
//   try {
//   QuerySnapshot snapshot = await _firebaseService.getCollection('classes');
//   return snapshot.docs.map((doc) => Class.fromJson(doc.data() as Map<String, dynamic>)).toList();
//   } catch (e) {
//   print('Error retrieving classes: $e');
//   rethrow;
//   }
//   }
//
// // Additional methods for class operations can be added here
// }
