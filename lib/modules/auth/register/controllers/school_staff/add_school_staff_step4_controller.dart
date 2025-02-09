import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolStaffStep4FormController extends GetxController {
  final step4FormKey = GlobalKey<FormState>();

  final mobileNoController = TextEditingController();
  final emailAddressController = TextEditingController();
  final aadhaarNoController = TextEditingController();
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();
  RxString selectedVehicleNo = RxString('');
  RxString selectedModeOfTransport = RxString('');

  RxString selectedState = RxString('');
  RxString selectedDistrict = RxString('');
  RxString selectedCity = RxString('');

  @override
  void onClose() {
    mobileNoController.dispose();
    emailAddressController.dispose();
    aadhaarNoController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    super.onClose();
  }


  @override
  void updateFormValidity() {
    // TODO: implement updateFormValidity
  }

  bool isFormValid() {
    return step4FormKey.currentState?.validate() ?? false;
  }
}
