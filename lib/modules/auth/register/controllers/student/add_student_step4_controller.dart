import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentStep4FormController extends GetxController {
  final step4FormKey = GlobalKey<FormState>();

  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController fatherMobileNoController = TextEditingController();
  final TextEditingController fatherOccupationController = TextEditingController();

  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController motherMobileNoController = TextEditingController();
  final TextEditingController motherOccupationController = TextEditingController();

  final TextEditingController guardianNameController = TextEditingController();
  final TextEditingController guardianMobileNoController = TextEditingController();
  final TextEditingController relationshipToGuardianController = TextEditingController();


  void clearForm() {
    fatherNameController.clear();
    fatherMobileNoController.clear();
    fatherOccupationController.clear();
    motherNameController.clear();
    motherMobileNoController.clear();
    motherOccupationController.clear();
    guardianNameController.clear();
    guardianMobileNoController.clear();
    relationshipToGuardianController.clear();
  }


  @override
  void onClose() {
    fatherNameController.dispose();
    motherNameController.dispose();
    fatherMobileNoController.dispose();
    fatherOccupationController.dispose();
    motherMobileNoController.dispose();
    motherOccupationController.dispose();
    guardianNameController.dispose();
    guardianMobileNoController.dispose();
    relationshipToGuardianController.dispose();
    super.onClose();
  }

  bool isFormValid() {
    return step4FormKey.currentState?.validate() ?? false;
  }
}