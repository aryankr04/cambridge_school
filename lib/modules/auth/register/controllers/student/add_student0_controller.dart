import 'package:cambridge_school/core/services/firebase/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/services/firebase/storage_service.dart';
import '../../../../../core/services/local_storage/hive_database_service.dart';
import '../../../../../core/utils/helpers/helper_functions.dart';
import '../../models/user_model.dart';
import '../../repositories/user_service.dart';
import 'add_student_step1_controller.dart';
import 'add_student_step5_controller.dart';
import 'add_student_step3_controller.dart';
import 'add_student_step4_controller.dart';
import 'add_student_step2_controller.dart';
import 'add_student_step6_controller.dart';
import 'add_student_step7_controller.dart';
import 'add_student_step8_controller.dart';

const List<String> stepNamesForStudent = [
  'Introduction to Student Registration',
  'Basic Information',
  'Academic Information',
  'Contact Information',
  'Parental/Guardian Information',
  'Physical and Health Information',
  'Favorites and Personal Interests',
  'Document Uploads',
  'Authentication'
];

class AddStudent0Controller extends GetxController {
  final FirebaseUserService _firebaseFunction = FirebaseUserService();
  final FirebaseStorageService _firebaseStorageService =
  FirebaseStorageService();
  final FirestoreService _firestoreService = FirestoreService();
  RxInt activeStep = 0.obs;
  late final PageController pageController =
  PageController(initialPage: activeStep.value);

  String getStepName() => stepNamesForStudent[activeStep.value];

  @override
  void onInit() {
    super.onInit();
    Get.put(StudentStep1FormController());
    Get.put(StudentStep2FormController());
    Get.put(StudentStep3FormController());
    Get.put(StudentStep4FormController());
    Get.put(StudentStep5FormController());
    Get.put(StudentStep6FormController());
    Get.put(StudentStep7FormController());
    Get.put(StudentStep8FormController());
  }

  Future<void> incrementStep() async {
    if (activeStep.value < stepNamesForStudent.length - 1) {
      final bool isValid = _isCurrentStepValid();
      if (isValid) {
        activeStep.value++;
        pageController.jumpToPage(activeStep.value);
      } else {
        MyHelperFunctions.showErrorSnackBar("Please complete the current form");
      }
    }
  }

  void decrementStep() {
    if (activeStep.value > 0) {
      activeStep.value--;
      pageController.jumpToPage(activeStep.value);
    }
  }

  bool _isCurrentStepValid() {
    return [
      true,
      Get.find<StudentStep1FormController>().isFormValid(),
      Get.find<StudentStep2FormController>().isFormValid(),
      Get.find<StudentStep3FormController>().isFormValid(),
      Get.find<StudentStep4FormController>().isFormValid(),
      Get.find<StudentStep5FormController>().isFormValid(),
      Get.find<StudentStep6FormController>().isFormValid(),
      Get.find<StudentStep7FormController>().isFormValid(),
    ][activeStep.value];
  }


  Future<void> registerStudent() async {
    try {
      MyHelperFunctions.showLoadingOverlay();
      final userCredential = await _createUserWithEmailAndPassword(
          Get.find<StudentStep8FormController>().emailAddressController.text.trim(),
          Get.find<StudentStep8FormController>().passwordController.text.trim());
      if (userCredential != null && userCredential.user != null) {
        final UserModel? student =
        await _addStudentToFirebase(userCredential.user!.uid);
        MyHelperFunctions.showSuccessSnackBar("Registration Successfully!");
        if (student != null) {
          await _storeUserDataLocally(student);
          await _attemptAutoLogin(
              Get.find<StudentStep8FormController>().emailAddressController.text.trim(),
              Get.find<StudentStep8FormController>().passwordController.text.trim());
          // _clearAllControllers();
          Get.offNamed('/pending-approval');
        }
      } else {
        MyHelperFunctions.showErrorSnackBar("Error in user creation");
      }
    } on FirebaseAuthException catch (e) {
      MyHelperFunctions.showErrorSnackBar(e.message.toString());
    } finally {
      Get.back();
    }
  }

  Future<UserCredential?> _createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> _addStudentToFirebase(String uid) async {
    try {
      final String? selectedSchool =
          Get.find<StudentStep2FormController>().selectedSchoolController.text;
      // if (selectedSchool == null) return null;

      final String? profileImageUrl =
      await _firebaseStorageService.uploadImageFromMemory(
          Get.find<StudentStep7FormController>().profileImage.value!,
          uid,
          'student_profile_images');
      final String? birthCertificateImageUrl =
      await _firebaseStorageService.uploadImageFromMemory(
          Get.find<StudentStep7FormController>().birthCertificateImage.value!,
          uid,
          'student_birth_certificate_images');
      final String? transferCertificateImageUrl =
      await _firebaseStorageService.uploadImageFromMemory(
          Get.find<StudentStep7FormController>().transferCertificateImage.value!,
          uid,
          'student_transfer_certificate_images');
      final String? aadhaarCardImageUrl =
      await _firebaseStorageService.uploadImageFromMemory(
          Get.find<StudentStep7FormController>().aadhaarCardImage.value!,
          uid,
          'student_aadhaar_card_images');

      final UserModel student = UserModel(
        id: uid,
        roles: ['student'],
        // schoolId: selectedSchool,
        schoolId: '',
        name:
        '${Get.find<StudentStep1FormController>().firstNameController.text.trim()} ${ Get.find<StudentStep1FormController>().lastNameController.text.trim()}',
        nationality: Get.find<StudentStep1FormController>().selectedNationality.value.trim(),
        dob: Get.find<StudentStep1FormController>().selectedDateOfBirth.value,
        height: MyHelperFunctions.convertFeetInchesToCm(
            Get.find<StudentStep5FormController>().selectedHeightFt.value.trim(),
            Get.find<StudentStep5FormController>().selectedHeightInch.value.trim()),
        weight: Get.find<StudentStep5FormController>().weightController.text.trim(),
        visionCondition: Get.find<StudentStep5FormController>().selectedVisionCondition.value.trim(),
        medicalCondition: Get.find<StudentStep5FormController>().selectedMedicalCondition.value.trim(),
        isPhysicalDisability:
        Get.find<StudentStep5FormController>().isPhysicalDisability.value.trim() == 'Yes',
        religion: Get.find<StudentStep1FormController>().selectedReligion.value.trim(),
        category: Get.find<StudentStep1FormController>().selectedCategory.value.trim(),
        gender: Get.find<StudentStep1FormController>().selectedGender.value.trim(),
        bloodGroup: Get.find<StudentStep5FormController>().selectedBloodGroup.value.trim(),
        phoneNumber: Get.find<StudentStep8FormController>().mobileNoController.text.trim(),
        email: Get.find<StudentStep8FormController>().emailAddressController.text.trim(),
        aadhaarNo: Get.find<StudentStep7FormController>().aadhaarNoController.text.trim(),
        address: Get.find<StudentStep3FormController>().houseAddressController.text.trim(),
        state: Get.find<StudentStep3FormController>().selectedState.value.trim(),
        district: Get.find<StudentStep3FormController>().selectedDistrict.value.trim(),
        city: Get.find<StudentStep3FormController>().selectedCity.value.trim(),
        pinCode: Get.find<StudentStep3FormController>().pinCodeController.text.trim(),
        modeOfTransport: Get.find<StudentStep2FormController>().selectedModeOfTransport.value.trim(),
        vehicleNo: Get.find<StudentStep2FormController>().selectedVehicleNo.value.trim(),
        houseOrTeam: Get.find<StudentStep2FormController>().selectedHouseOrTeam.value.trim(),
        favSubject: Get.find<StudentStep6FormController>().selectedFavoriteSubject.value.trim(),
        favTeacher: Get.find<StudentStep6FormController>().selectedFavoriteTeacher.value.trim(),
        favSports: Get.find<StudentStep6FormController>().selectedFavoriteSport.value.trim(),
        favFood: Get.find<StudentStep6FormController>().favoriteFoodController.text.toString().trim(),
        hobbies:  Get.find<StudentStep6FormController>().selectedHobbies,
        goal: Get.find<StudentStep6FormController>().goalController.text.trim(),
        username: Get.find<StudentStep8FormController>().usernameController.text.trim(),
        password: Get.find<StudentStep8FormController>().passwordController.text.trim(),
        profilePictureUrl: profileImageUrl ?? '',
        aadhaarCardImageUrl: aadhaarCardImageUrl ?? '',
        isActive: false,
        accountStatus: 'pending',
        lastLogin: DateTime.now(),
        createdAt: DateTime.now(),
        followers: [],
        following: [],
        posts: 0,
        studentDetails: StudentDetails(
            admissionDate:
            Get.find<StudentStep2FormController>().selectedAdmissionDate.value,
            admissionNo: '',
            className: Get.find<StudentStep2FormController>().selectedClass.value.toString().trim(),
            sectionName:
            Get.find<StudentStep2FormController>().selectedSection.value.toString().trim(),
            rollNo: Get.find<StudentStep2FormController>().rollNoController.text.trim(),
            birthCertificateImageUrl: birthCertificateImageUrl ?? '',
            transferCertificateImageUrl: transferCertificateImageUrl ?? '',
            aadhaarCardImageUrl: aadhaarCardImageUrl ?? '',
            fatherName: Get.find<StudentStep4FormController>().fatherNameController.text.trim(),
            fatherMobileNo:
            Get.find<StudentStep4FormController>().fatherMobileNoController.text.trim(),
            fatherOccupation:
            Get.find<StudentStep4FormController>().fatherOccupationController.text.trim(),
            motherName: Get.find<StudentStep4FormController>().motherNameController.text.trim(),
            motherMobileNo:
            Get.find<StudentStep4FormController>().motherMobileNoController.text.trim(),
            motherOccupation:
            Get.find<StudentStep4FormController>().motherOccupationController.text.trim(),
            feeDetails: [],
            feePayments: [],
            classRank: 0,
            schoolRank: 0,
            allIndiaRank: 0),
        profileDescription: '',
        emergencyContact: '',
        languagesSpoken:  Get.find<StudentStep1FormController>().selectedLanguages,
        presentDays: 0,
        absentDays: 0,
        performanceRating: 5,
        points: 45,
        isDarkMode: false,
        isNotificationsEnabled: true,
        languagePreference: 'en',
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(student.toMap());
      return student;
    } catch (e) {
      print('Error adding student: $e');
      MyHelperFunctions.showErrorSnackBar(
          'Error adding student. Please try again.');
      return null;
    }
  }

  Future<void> _storeUserDataLocally(UserModel user) async {
    final HiveDatabaseService hive = HiveDatabaseService();
    await hive.saveUser(user.toMap());
  }

  Future<void> _attemptAutoLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      print('Error during automatic login: ${e.message}');
      Get.offAllNamed('/login');
    }
  }

  @override
  void onClose() {
    // step1Controller.onClose();
    // step2Controller.onClose();
    // step3Controller.onClose();
    // step4Controller.onClose();
    // step5Controller.onClose();
    // step6Controller.onClose();
    // step7Controller.onClose();
    //step8Controller.onClose();
    super.onClose();
  }
}
