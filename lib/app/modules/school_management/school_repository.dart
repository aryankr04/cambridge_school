import 'package:cambridge_school/app/modules/class_management/class_management_controller.dart';
import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/async.dart';

import '../../../core/services/firebase/firestore_service.dart';
import '../../../core/widgets/snack_bar.dart';

class SchoolRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String _schoolsCollection = 'schools';

  // ************************ Basic CRUD operations ************************

  /// Adds a new school to Firestore.
  Future<String> addSchool(SchoolModel school) async {
    try {
      // Generate a unique school ID
      final schoolId = await _firestoreService.generateNewIdWithPrefix(
          'SCH', _schoolsCollection);
      // Ensure the school model has the generated ID
      final updatedSchool = school.copyWith(schoolId: schoolId);

      // Convert the updated SchoolModel to a map
      final schoolMap = updatedSchool.toMap();

      // Add the school data to Firestore
      await _firestoreService.addDocument(_schoolsCollection, schoolMap,
          documentId: schoolId);
      MySnackBar.showSuccessSnackBar("School created successfully!");
      return schoolId;
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error adding school: $e');
      rethrow;
    }
  }

  /// Retrieves a school from Firestore by its ID.
  Future<SchoolModel?> getSchool(String schoolId) async {
    try {
      final documentSnapshot =
          await _firestoreService.getDocumentById(_schoolsCollection, schoolId);
      if (documentSnapshot.exists) {
        return SchoolModel.fromMap(documentSnapshot.data()!);
      } else {
        MySnackBar.showInfoSnackBar('School not found with ID: $schoolId');
        return null;
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error getting school: $e');
      rethrow;
    }
  }

  /// Updates a school in Firestore.
  Future<void> updateSchool(SchoolModel school) async {
    try {
      await _firestoreService.updateDocument(
          _schoolsCollection, school.schoolId, school.toMap());
      MySnackBar.showSuccessSnackBar('School updated successfully!');
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error updating school: $e');
      rethrow;
    }
  }

  /// Deletes a school from Firestore.
  Future<void> deleteSchool(String schoolId) async {
    try {
      await _firestoreService.deleteDocument(_schoolsCollection, schoolId);
      MySnackBar.showSuccessSnackBar('School deleted successfully!');
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error deleting school: $e');
      rethrow;
    }
  }

  // ************************ Get All Schools ************************
  Future<List<SchoolModel>> getAllSchools() async {
    try {
      final documents =
          await _firestoreService.getAllDocuments(_schoolsCollection);
      return documents.map((doc) => SchoolModel.fromMap(doc.data())).toList();
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error getting all schools: $e');
      rethrow;
    }
  }

  // ************************ Stream operations ************************

  /// Returns a stream of a single school in Firestore.
  Stream<SchoolModel?> getSchoolStream(String schoolId) {
    return _firestoreService
        .getDocumentStream(_schoolsCollection, schoolId)
        .map((snapshot) {
      if (snapshot.exists) {
        return SchoolModel.fromMap(snapshot.data()!);
      } else {
        MySnackBar.showInfoSnackBar('School not found with ID: $schoolId');
        return null;
      }
    });
  }

  // ************************ Class management operations ************************

  /// Get a all classes from a school's class list.
  Future<List<ClassData>> getClasses(String schoolId) async {
    try {
      final docSnapshot =
          await _firestoreService.getDocumentById('schools', schoolId);

      if (docSnapshot.exists && docSnapshot.data()!.containsKey('classes')) {
        final classes = docSnapshot.data()!['classes'] as List;
        return classes
            .map((e) => ClassData.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class data: $e');
      return [];
    }
  }

  Future<List<String>> getClassNames(String schoolId) async {
    try {
      final docSnapshot =
          await _firestoreService.getDocumentById(_schoolsCollection, schoolId);

      if (docSnapshot.exists && docSnapshot.data()!.containsKey('classes')) {
        final classes = (docSnapshot['classes'] as List)
            .map((e) => ClassData.fromMap(e as Map<String, dynamic>))
            .toList();

        return classes.map((classData) => classData.className.label).toList();
      } else {
        MySnackBar.showInfoSnackBar(
            'No classes found for school ID: $schoolId');
        return [];
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class names: $e');
      return [];
    }
  }

  /// Adds a new class to a school's class list.
  Future<void> addClassToSchool(String schoolId, ClassData classData) async {
    try {
      final school = await getSchool(schoolId);
      if (school != null) {
        List<ClassData> updatedClasses = List.from(school.classes);
        updatedClasses.add(classData);

        final updatedSchool = school.copyWith(classes: updatedClasses);
        await updateSchool(updatedSchool);
        MySnackBar.showSuccessSnackBar('Class added successfully!');
      } else {
        MySnackBar.showErrorSnackBar('School not found with ID: $schoolId');
        throw Exception('School not found with ID: $schoolId');
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error adding class to school: $e');
      rethrow;
    }
  }

  /// Updates a class in a school's class list.
  Future<void> updateClassInSchool(
      String schoolId, ClassData updatedClass) async {
    try {
      final school = await getSchool(schoolId);
      if (school != null) {
        List<ClassData> updatedClasses = school.classes.map((existingClass) {
          if (existingClass.classId == updatedClass.classId) {
            return updatedClass; // Replace with the updated class data
          }
          return existingClass;
        }).toList();

        final updatedSchool = school.copyWith(classes: updatedClasses);
        await updateSchool(updatedSchool);
        MySnackBar.showSuccessSnackBar('Class updated successfully!');
      } else {
        MySnackBar.showErrorSnackBar('School not found with ID: $schoolId');
        throw Exception('School not found with ID: $schoolId');
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error updating class in school: $e');
      rethrow;
    }
  }

  /// Adds a new class data to an existing school document in Firestore.
  Future<void> addOrUpdateClassData(
      String schoolId, ClassData classData) async {
    try {
      final schoolDocRef = FirebaseFirestore.instance
          .collection(_schoolsCollection)
          .doc(schoolId);

      // Fetch the school document
      final schoolDoc = await schoolDocRef.get();

      if (!schoolDoc.exists) {
        MySnackBar.showErrorSnackBar(
            'School with ID: $schoolId does not exist.');
        throw Exception('School with ID: $schoolId does not exist.');
      }

      // Get current classes
      List<Map<String, dynamic>> classList =
          (schoolDoc.data()?['classes'] as List<dynamic>?)
                  ?.map((c) => Map<String, dynamic>.from(c))
                  .toList() ??
              [];

      // Find existing class index
      int existingIndex =
          classList.indexWhere((c) => c['classId'] == classData.classId);

      if (existingIndex != -1) {
        classList[existingIndex] = classData.toMap(); // Update existing class
        MySnackBar.showSuccessSnackBar('Class data updated successfully!');
      } else {
        classList.add(classData.toMap()); // Add new class
        MySnackBar.showSuccessSnackBar('Class data added successfully!');
      }

      // Update Firestore document
      await schoolDocRef.update({'classes': classList});
    } catch (e) {
      MySnackBar.showErrorSnackBar('Error in addOrUpdateClassData: $e');
      rethrow;
    }
  }

  // ********** Section management operations *********

  Future<List<SectionData>> getSections(String schoolId) async {
    try {
      final List<ClassData> classData = await getClasses(schoolId);
      List<SectionData> allSections = [];
      print('Length ${classData.length}');
      for (var classItem in classData) {
        if (classItem.sectionName.isEmpty) {
          SectionData section = SectionData(
            classId: classItem.classId,
            className: classItem.className,
            sectionName: '',
          );
          print(
              "Created SectionData: ${classItem.className}"); // Print SectionData
          allSections.add(section);
        } else {
          for (var sectionName in classItem.sectionName) {
            SectionData section = SectionData(
              classId: classItem.classId,
              className: classItem.className,
              sectionName: sectionName,
            );
            print(
                "Created SectionData: ${section.toMap()}"); // Print SectionData
            allSections.add(section);
          }
        }
      }

      final uniqueSections = <SectionData>{};
      uniqueSections.addAll(allSections);
      allSections = uniqueSections.toList();

      return allSections;
    } catch (error) {
      MySnackBar.showErrorSnackBar('Error fetching school sections: $error');
      return [];
    }
  }

  Future<List<String>> extractClassNames(
      List<SectionData>? sectionsData) async {
    if (sectionsData == null) return [];
    Set<String> uniqueClassNames = {};
    for (var section in sectionsData) {
      uniqueClassNames.add(section.className.label);
    }
    return uniqueClassNames.toList();
  }

  Future<List<String>> extractSectionNames(
      List<SectionData>? sectionsData, String className) async {
    if (sectionsData == null) return [];
    List<String> sectionNames = [];
    for (var section in sectionsData) {
      if (section.className == ClassName.fromString(className)) {
        sectionNames.add(section.sectionName);
      }
    }
    return sectionNames;
  }
}
