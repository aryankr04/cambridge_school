import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/helpers/helper_functions.dart';

class SchoolStaffStep3FormController extends GetxController {
  final step3FormKey = GlobalKey<FormState>();

  List<String> get yearList {
    return List<String>.generate(30, (index) => (index + 1).toString());
  }

  var educationEntries = <Map<String, dynamic>>[].obs;
  var certificationEntries = <Map<String, dynamic>>[].obs;

  Rx<String> selectedTeachingExperience = Rx<String>('');
  TextEditingController previousInstitutionController = TextEditingController();

  SchoolStaffStep3FormController() {
    // Add initial entries
    addEducationEntry();
    addCertificationEntry();
  }

  void addEducationEntry() {
    educationEntries.add({
      'degree': '',
      'universityController': TextEditingController(),
      'yearController': TextEditingController(),
    });
    update();
  }

  void removeEducationEntry(int index) {
    if (educationEntries.length > 1) {
      // Ensure at least one entry
      educationEntries[index]['universityController'].dispose();
      educationEntries[index]['yearController'].dispose();
      educationEntries.removeAt(index);
      update();
    } else {
      MyHelperFunctions.showErrorSnackBar(
          'At least one education entry is required.');
    }
  }

  void addCertificationEntry() {
    certificationEntries.add({
      'nameController': TextEditingController(),
      'organizationController': TextEditingController(),
      'yearController': TextEditingController(),
    });
    update();
  }

  void removeCertificationEntry(int index) {
    if (certificationEntries.length > 1) {
      // Ensure at least one entry
      certificationEntries[index]['nameController'].dispose();
      certificationEntries[index]['organizationController'].dispose();
      certificationEntries[index]['yearController'].dispose();
      certificationEntries.removeAt(index);
      update();
    } else {
      // Optionally show an error message if you want
      MyHelperFunctions.showErrorSnackBar(
          'At least one certification entry is required.');
    }
  }

  // Dispose controllers
  @override
  void onClose() {
    previousInstitutionController.dispose();
    for (var entry in educationEntries) {
      entry['universityController'].dispose();
      entry['yearController'].dispose();
    }
    for (var entry in certificationEntries) {
      entry['nameController'].dispose();
      entry['organizationController'].dispose();
      entry['yearController'].dispose();
    }
    super.onClose();
  }

  bool isFormValid() {
    return step3FormKey.currentState?.validate() ?? false;
  }
}
