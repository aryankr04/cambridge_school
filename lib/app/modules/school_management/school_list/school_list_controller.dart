import 'package:get/get.dart';
import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import '../school_repository.dart';
import 'package:flutter/material.dart';  // Import for Get.snackbar


class SchoolListController extends GetxController {
  final FirestoreSchoolRepository schoolRepository = FirestoreSchoolRepository();

  final schools = <SchoolModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isRefreshing = false.obs; // Add a refreshing state

  @override
  void onInit() {
    super.onInit();
    loadSchools();
  }

  Future<void> loadSchools() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final fetchedSchools = await schoolRepository.getAllSchools();
      schools.value = fetchedSchools;
    } catch (e) {
      errorMessage.value = "Failed to load schools: $e";
      print("Error loading schools: $e");
      Get.snackbar("Error", "Failed to load schools: $e",
          snackPosition: SnackPosition.BOTTOM); // Show error using GetX
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSchools() async {
    try {
      isRefreshing.value = true; // Set refreshing state
      errorMessage.value = null;
      final fetchedSchools = await schoolRepository.getAllSchools();
      schools.value = fetchedSchools;
    } catch (e) {
      errorMessage.value = "Failed to refresh schools: $e";
      print("Error refreshing schools: $e");
      Get.snackbar("Error", "Failed to refresh schools: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isRefreshing.value = false; // Clear refreshing state
    }
  }

  void editSchool(SchoolModel school) {
    // Implement edit logic (e.g., navigate to an edit screen)
    print('Editing school: ${school.schoolName}');
    Get.snackbar("Edit", "Edit school: ${school.schoolName}",
        snackPosition: SnackPosition.BOTTOM); // Example feedback
  }

  Future<void> deleteSchool(String schoolId) async {
    try {
      await schoolRepository.deleteSchool(schoolId);
      schools.removeWhere((school) => school.schoolId == schoolId); //optimistically update list.
      Get.snackbar("Success", "School deleted successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error deleting school: $e");
      Get.snackbar(
        "Error",
        "Failed to delete school: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}