// create_notice_controller.dart
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../notice_model.dart';
import '../notice_repository.dart';

class CreateNoticeController extends GetxController {
  // Static Data (Consider making these configurable)
  String schoolId = 'SCH00001';
  String academicYear = '2024-2025';
  String createdBy = 'STU00001';

  // Observables (Reactive Variables)
  final isLoading = false.obs;
  final isImportant = false.obs;
  final selectedCategory = Rxn<String>();
  final selectedTargetAudience = <String>[].obs;
  final selectedForClass = <String>[].obs;

  // Controllers (For Form Fields)
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Repository
  final noticeRosterRepository = NoticeRosterRepository();

  //----------------------------------------------------------------------------
  // Validation function
  String? validateForm() {
    if (titleController.text.isEmpty) {
      return 'Title cannot be empty.';
    }
    if (descriptionController.text.isEmpty) {
      return 'Description cannot be empty.';
    }
    if (selectedTargetAudience.isEmpty) {
      return 'Please select at least one target audience.';
    }
    return null; // Return null if the form is valid
  }

  //----------------------------------------------------------------------------
  // Firebase Interaction
  Future<void> addNoticeToFirebase() async {
    MyFullScreenLoading.show();
    try {
      final validationError = validateForm();
      if (validationError != null) {
        Get.snackbar('Error', validationError);
        return;
      }

      final title = titleController.text;
      final description = descriptionController.text;
      final category = selectedCategory.value;
      final createdById = createdBy;
      final isImportantValue = isImportant.value;
      final targetAudience = List<String>.from(selectedTargetAudience);

      List<String>? targetClass = List<String>.from(selectedForClass);

      if (!(targetAudience.contains('All') ||
          targetAudience.contains('Student'))) {
        targetClass = null;
      }
      if (targetAudience.contains('All')) {
        targetClass = null;
      }

      final newNotice = Notice(
        title: title,
        description: description,
        createdById: createdById.isNotEmpty ? createdById : 'System',
        createdTime: DateTime.now(),
        category: category ?? 'General',
        isImportant: isImportantValue,
        targetAudience: targetAudience,
        targetClass: targetClass,
      );

      await noticeRosterRepository.addNoticeToRoster(
        schoolId: schoolId,
        academicYear: academicYear,
        notice: newNotice,
      );

      Get.snackbar('Success', 'Notice added successfully!');
      clearForm();
    } catch (e) {
      print('Error adding notice to Firebase: $e');
      Get.snackbar(
          'Error', 'Failed to add notice. Please try again. Error: $e');
    } finally {
      MyFullScreenLoading.hide();
    }
  }

  // Function to update a notice in Firebase
  Future<void> updateNoticeInFirebase(Notice existingNotice) async {
    MyFullScreenLoading.show(
        loadingText: 'Updating Notice...'); // Show the loading indicator

    try {
      final validationError = validateForm();
      if (validationError != null) {
        Get.snackbar('Error', validationError);
        return;
      }

      final title = titleController.text;
      final description = descriptionController.text;
      final category = selectedCategory.value;
      final createdById = createdBy;
      final isImportantValue = isImportant.value;
      final targetAudience = List<String>.from(selectedTargetAudience);
      List<String>? targetClass = List<String>.from(selectedForClass);

      if (!(targetAudience.contains('All') ||
          targetAudience.contains('Student'))) {
        targetClass = null;
      }
      if (targetAudience.contains('All')) {
        targetClass = null;
      }

      final updatedNotice = Notice(
        title: title,
        description: description,
        createdById: createdById.isNotEmpty ? createdById : 'System',
        createdTime: DateTime.now(),
        category: category ?? 'General',
        isImportant: isImportantValue,
        targetAudience: targetAudience,
        targetClass: targetClass,
      );

      await noticeRosterRepository.updateNoticeInRoster(
        schoolId: schoolId,
        academicYear: academicYear,
        createdTime: existingNotice.createdTime,
        notice: updatedNotice,
      );
      //clearForm();
    } catch (e) {
      print('Error updating notice in Firebase: $e');
      Get.snackbar(
          'Error', 'Failed to update notice. Please try again. Error: $e');
    } finally {
      MyFullScreenLoading.hide();
      // Get.toNamed('notice-screen');
    }
  }

  //----------------------------------------------------------------------------
  // UI Interaction Logic
  void toggleImportance(bool value) {
    isImportant.value = value;
  }

  void toggleTargetAudience(String value) {
    if (selectedTargetAudience.contains(value)) {
      selectedTargetAudience.remove(value);
    } else {
      selectedTargetAudience.add(value);
    }
  }

  void toggleForClass(String value) {
    if (selectedForClass.contains(value)) {
      selectedForClass.remove(value);
    } else {
      selectedForClass.add(value);
    }
  }

  //----------------------------------------------------------------------------
  // Form Management
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory.value = null;
    isImportant.value = false;
    selectedTargetAudience.value = [];
    selectedForClass.clear();
  }

  void populateFormForEdit(Notice notice) {
    titleController.text = notice.title;
    descriptionController.text = notice.description;
    selectedCategory.value = notice.category;
    isImportant.value = notice.isImportant;
    selectedTargetAudience.assignAll(notice.targetAudience ?? []);
    selectedForClass.assignAll(notice.targetClass ?? []);
  }
}
