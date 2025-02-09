import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentStep2FormController extends GetxController {
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();

  final TextEditingController selectedSchoolController = TextEditingController();
  final TextEditingController admissionDateController = TextEditingController();
  final Rx<String> selectedClass = Rx<String>('');
  final Rx<String> selectedSection = Rx<String>('');
  final TextEditingController rollNoController = TextEditingController();
  final Rx<String> selectedHouseOrTeam = Rx<String>('');
  final RxString selectedVehicleNo = RxString('');
  final RxString selectedModeOfTransport = RxString('');

  Rx<DateTime> selectedAdmissionDate = DateTime.now().obs;

  final RxList<Map<String, dynamic>> schoolList = <Map<String, dynamic>>[].obs;

  void clearForm() {
    selectedSchoolController.clear();
    admissionDateController.clear();
    selectedClass.value = '';
    selectedSection.value = '';
    rollNoController.clear();
    selectedHouseOrTeam.value = '';
    selectedVehicleNo.value = '';
    selectedModeOfTransport.value = '';
  }

  @override
  void onClose() {
    selectedSchoolController.dispose();
    admissionDateController.dispose();
    rollNoController.dispose();
    super.onClose();
  }

  bool isFormValid() {
    return step2FormKey.currentState?.validate() ?? false;
  }
}