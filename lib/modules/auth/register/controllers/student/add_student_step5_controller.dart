import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentStep5FormController extends GetxController {
  final GlobalKey<FormState> step5FormKey = GlobalKey<FormState>();

  final RxString selectedHeightFt = RxString('');
  final RxString selectedHeightInch = RxString('');
  final TextEditingController weightController = TextEditingController();
  final RxString selectedBloodGroup = RxString('');
  final RxString selectedVisionCondition = RxString('');
  final RxString selectedMedicalCondition = RxString('');
  final RxString isPhysicalDisability = RxString('');

  void clearForm() {
    selectedHeightFt.value = '';
    selectedHeightInch.value = '';
    weightController.clear();
    selectedBloodGroup.value = '';
    selectedVisionCondition.value = '';
    selectedMedicalCondition.value = '';
    isPhysicalDisability.value = '';
  }


  @override
  void onClose() {
    weightController.dispose();
    super.onClose();
  }


  bool isFormValid() {
    return step5FormKey.currentState?.validate() ?? false;
  }
}