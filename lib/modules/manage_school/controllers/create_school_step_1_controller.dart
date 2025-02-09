import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateSchoolStep1GeneralInformationController extends GetxController {
  // Controllers for text fields
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController schoolIdController = TextEditingController();
  final TextEditingController establishedYearController = TextEditingController();
  final TextEditingController affiliationBoardController = TextEditingController();
  final TextEditingController schoolMottoController = TextEditingController();

  final image = Rx<File?>(null);

  // Dropdown options
  var mediumOfInstruction = ['Hindi', 'English', 'Other'].obs;
  var schoolTypes = ['Public', 'Private', 'Semi-Government'].obs;
  var academicLevels = [
    'Pre-primary',
    'Primary',
    'Secondary',
    'Higher Secondary'
  ].obs;

  // Selected values for dropdowns
  RxString selectedSchoolType = ''.obs;
  RxString selectedAcademicLevel = ''.obs;
  RxString selectedGradingSystem = ''.obs;
  RxString selectedExaminationPattern = ''.obs;

  // Method to reset all fields (optional)
  void resetFields() {
    schoolNameController.clear();
    schoolIdController.clear();
    establishedYearController.clear();
    affiliationBoardController.clear();
    schoolMottoController.clear();
    selectedSchoolType.value = '';
    selectedAcademicLevel.value = '';
  }

  // Dispose controllers when the controller is deleted
  @override
  void onClose() {
    schoolNameController.dispose();
    schoolIdController.dispose();
    establishedYearController.dispose();
    affiliationBoardController.dispose();
    schoolMottoController.dispose();
    super.onClose();
  }
}
