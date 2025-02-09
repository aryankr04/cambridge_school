import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StudentStep7FormController extends GetxController {
  final TextEditingController aadhaarNoController = TextEditingController();

  final Rx<File?> birthCertificateImage = Rx<File?>(null);
  final Rx<File?> transferCertificateImage = Rx<File?>(null);
  final Rx<File?> aadhaarCardImage = Rx<File?>(null);
  final Rx<File?> profileImage = Rx<File?>(null);

  void clearForm(){
    birthCertificateImage.value = null;
    transferCertificateImage.value = null;
    aadhaarCardImage.value = null;
    profileImage.value = null;
  }


  void setBirthCertificateImage(File value) {
    birthCertificateImage.value = value;
  }

  void setTransferCertificateImage(File value) {
    transferCertificateImage.value = value;
  }

  void setAadhaarCardImage(File value) {
    aadhaarCardImage.value = value;
  }

  void setPassportSizeImage(File value) {
    profileImage.value = value;
  }

  bool isFormValid() {
    return birthCertificateImage.value != null &&
        transferCertificateImage.value != null &&
        aadhaarCardImage.value != null &&
        profileImage.value != null;
  }
}