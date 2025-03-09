import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../notice_model.dart';
import '../notice_repository.dart';

class CreateNoticeController extends GetxController {
  //----------------------------------------------------------------------------
  // Static Data (Consider making these configurable or injectable)

  String schoolId = 'SCH00001';
  String academicYear = '2024-2025';
  String createdById = 'STU00001';
  String createdByName = 'Aryan Kumar';

  //----------------------------------------------------------------------------
  // Observables (Reactive Variables)

  final isLoading = false.obs;
  final selectedCategory = Rxn<String>();
  final RxList<String>? selectedTargetAudience = <String>[].obs;
  final RxList<String>? selectedForClass = <String>[].obs;

  //----------------------------------------------------------------------------
  // Controllers (For Form Fields)

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //----------------------------------------------------------------------------
  // Repository

  final noticeRosterRepository = NoticeRosterRepository();

  //----------------------------------------------------------------------------
  // Validation

  String? validateForm() {
    if (titleController.text.isEmpty) {
      return 'Title cannot be empty.';
    }
    if (descriptionController.text.isEmpty) {
      return 'Description cannot be empty.';
    }
    if (selectedTargetAudience == null || selectedTargetAudience!.isEmpty) {
      return 'Please select at least one target audience.';
    }
    return null;
  }

  //----------------------------------------------------------------------------
  // Firebase Interaction (Adding and Updating Notices)

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
      final targetAudience = List<String>.from(
          selectedTargetAudience!.where((e) => e != null).map((e) => e!));

      List<String>? targetClass = selectedForClass
          ?.where((e) => e != null)
          .map((e) => e!)
          .toList();

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
        createdById: createdById,
        createdByName: createdByName,
        createdTime: DateTime.now(),
        category: category ?? 'General',
        targetAudience: targetAudience,
        targetClass: targetClass,
      );

      await noticeRosterRepository.addNoticeToRoster(
        schoolId: schoolId,
        academicYear: academicYear,
        notice: newNotice,
      );

      clearForm();
    } catch (e) {
      print('Error adding notice to Firebase: $e');
      Get.snackbar(
          'Error', 'Failed to add notice. Please try again. Error: $e');
    } finally {
      MyFullScreenLoading.hide();
    }
  }

  Future<void> updateNoticeInFirebase(Notice existingNotice) async {
    MyFullScreenLoading.show(loadingText: 'Updating Notice...');
    try {
      final validationError = validateForm();
      if (validationError != null) {
        Get.snackbar('Error', validationError);
        return;
      }

      final title = titleController.text;
      final description = descriptionController.text;
      final category = selectedCategory.value;
      final targetAudience = List<String>.from(
          selectedTargetAudience!.where((e) => e != null).map((e) => e!));

      List<String>? targetClass = selectedForClass
          ?.where((e) => e != null)
          .map((e) => e!)
          .toList();

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
        createdById: createdById,
        createdByName: createdByName,
        createdTime: DateTime.now(),
        category: category ?? 'General',
        targetAudience: targetAudience,
        targetClass: targetClass,
      );

      await noticeRosterRepository.updateNoticeInRoster(
        schoolId: schoolId,
        academicYear: academicYear,
        createdTime: existingNotice.createdTime,
        notice: updatedNotice,
      );
    } catch (e) {
      print('Error updating notice in Firebase: $e');
      Get.snackbar(
          'Error', 'Failed to update notice. Please try again. Error: $e');
    } finally {
      MyFullScreenLoading.hide();
    }
  }

  //----------------------------------------------------------------------------
  // UI Interaction Logic

  void toggleTargetAudience(String value) {
    if (selectedTargetAudience?.contains(value) == true) {
      selectedTargetAudience?.remove(value);
    } else {
      selectedTargetAudience?.add(value);
    }
  }

  void toggleForClass(String value) {
    if (selectedForClass?.contains(value) == true) {
      selectedForClass?.remove(value);
    } else {
      selectedForClass?.add(value);
    }
  }

  //----------------------------------------------------------------------------
  // Form Management

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory.value = null;
    selectedTargetAudience?.clear();
    selectedForClass?.clear();
  }

  void populateFormForEdit(Notice notice) {
    titleController.text = notice.title;
    descriptionController.text = notice.description;
    selectedCategory.value = notice.category;
    selectedTargetAudience?.assignAll(notice.targetAudience ?? []);
    selectedForClass?.assignAll(notice.targetClass ?? []);
  }
}
