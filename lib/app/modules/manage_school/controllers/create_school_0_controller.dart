import 'package:cambridge_school/app/modules/user_management/repositories/user_repository.dart';
import 'package:cambridge_school/core/services/firebase/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore

import '../../../../../core/services/firebase/storage_service.dart';

import '../../../../../core/utils/helpers/helper_functions.dart';
import '../models/school_model.dart';
import '../screens/create_school_step_0.dart';
import 'create_school_step_1_controller.dart'; // Add This
import 'create_school_step_2_controller.dart';
import 'create_school_step_3_controller.dart';
import 'create_school_step_4_controller.dart';
import 'create_school_step_5_controller.dart';
import 'create_school_step_6_controller.dart';
import 'create_school_step_7_controller.dart';
import 'create_school_step_8_controller.dart';

class CreateSchool0Controller extends GetxController {
  final UserRepository firebaseFunction = UserRepository();
  final FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  final FirestoreService firestoreService = FirestoreService();

  final CreateSchoolStep1GeneralInformationController step1Controller =
  CreateSchoolStep1GeneralInformationController();

  final CreateSchoolStep2LocationDetailsController step2Controller =
  CreateSchoolStep2LocationDetailsController();

  final CreateSchoolStep3ContactInformationController step3Controller =
  CreateSchoolStep3ContactInformationController();

  final CreateSchoolStep4InfrastructureDetailsController step4Controller =
  CreateSchoolStep4InfrastructureDetailsController();

  final CreateSchoolStep5AcademicDetailsController step5Controller =
  CreateSchoolStep5AcademicDetailsController();

  final CreateSchoolStep6AdministrativeInformationController step6Controller =
  CreateSchoolStep6AdministrativeInformationController();

  final CreateSchoolStep7AccreditationAndAchievementsController step7Controller =
  CreateSchoolStep7AccreditationAndAchievementsController();

  final CreateSchoolStep8ExtracurricularDetailsController step8Controller =
  CreateSchoolStep8ExtracurricularDetailsController();

  RxInt activeStep = 0.obs;
  late final PageController pageController =
  PageController(initialPage: activeStep.value);

  String getStepName() => stepNamesForCreateSchool[activeStep.value];

  void incrementStep() async {
    if (activeStep.value < stepNamesForCreateSchool.length - 1) {
      if (true) {
        activeStep.value++;
        pageController.jumpToPage(activeStep.value);
      }
    }
  }

  // --  Private helper method to validate forms --
  bool isFormValid(){
    return step1Controller.schoolNameController.text.isNotEmpty &&
        step2Controller.addressController.text.isNotEmpty &&
        step3Controller.primaryPhoneNumberController.text.isNotEmpty &&
        step4Controller.campusSizeController.text.isNotEmpty &&
        step5Controller.periodsPerDayController.text.isNotEmpty &&
        step6Controller.principalNameController.text.isNotEmpty &&
        step7Controller.accreditationDetailsController.text.isNotEmpty;
  }

  // -- Private helper method to validate image selection--
  bool isImageSelected() {
    if (step1Controller.image.value == null) {
      MyHelperFunctions.showAlertSnackBar(
        'Please select an image.',
      );
      return false;
    }
    return true;
  }

  Future<void> addSchoolToFirebase() async {
    try {
      MyHelperFunctions.showLoadingOverlay();

      if (!isImageSelected() || !isFormValid()) {
        Get.back();
        MyHelperFunctions.showErrorSnackBar(
          'Please fill valid details and select an image.',
        );
        return;
      }

      final School? school = await _buildSchoolData();
      if(school == null){
        Get.back();
        MyHelperFunctions.showErrorSnackBar(
          'There was an error while building the school. Please try again',
        );
        return;
      }

      final String? schoolId = await FirestoreService.generateNewIdWithPrefix('SCH', 'schools');
      if (schoolId == null) {
        MyHelperFunctions.showErrorSnackBar(
          'Failed to generate school ID. Please try again.',
        );
        return;
      }

      String? schoolLogoImageUrl;
      try {
        schoolLogoImageUrl = await firebaseStorageService.uploadImageFromMemory(
          step1Controller.image.value!,
          schoolId,
          'school_logo_images',
        );
        if (schoolLogoImageUrl == null || schoolLogoImageUrl.isEmpty) {
          MyHelperFunctions.showErrorSnackBar(
            'Error uploading school logo. Please check your network connection.',
          );
          return;
        }
      } catch (imageUploadError) {
        print('Error uploading image: $imageUploadError');
        MyHelperFunctions.showErrorSnackBar(
          'Failed to upload school logo. Please try again.',
        );
        return;
      }

      try{

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('schools').doc(schoolId).set(school.toMap());
      }catch (firestoreError) {
        print('Firestore Error: $firestoreError');
        MyHelperFunctions.showErrorSnackBar(
          'Failed to add school to Firestore: ${firestoreError.toString()}',
        );
        return;
      }

      clearForm();
      Get.back();
      MyHelperFunctions.showSuccessSnackBar(
        '${step1Controller.schoolNameController.text} added successfully!',
      );

    } catch (e) {
      print('Unexpected Error adding school: $e');
      MyHelperFunctions.showErrorSnackBar(
        'An unexpected error occurred. Please try again.',
      );
    } finally {
      Get.back();
    }
  }

  // -- Private Method to Build School Data --
  Future<School?> _buildSchoolData() async {
    try {
      return School(
        schoolId: '',// To be generated later
        logoUrl: '',// Upload URL To be Uploaded Later

        schoolName: step1Controller.schoolNameController.text,
        schoolSlogan: step1Controller.schoolMottoController.text,
        aboutSchool: '',
        status: '',
        establishedYear: DateTime.now(),
        createdAt: DateTime.now(),

        schoolingSystem: step1Controller.selectedSchoolType.value,
        schoolBoard: step1Controller.selectedAcademicLevel.value,
        schoolCode: step1Controller.schoolIdController.text,
        schoolType: step1Controller.selectedSchoolType.value,
        affiliationNumber: '',

        schoolManagementAuthority: '',

        address: step2Controller.addressController.text,
        country: step2Controller.selectedCountry.value,
        state: step2Controller.selectedState.value,
        city: step2Controller.cityController.text,

        district: step2Controller.districtController.text,
        pinCode: step2Controller.zipCodeController.text,
        street: step2Controller.streetController.text,
        landmark: step2Controller.landmarksNearbyController.text,

        primaryPhoneNo: step3Controller.primaryPhoneNumberController.text,
        secondaryPhoneNo: step3Controller.secondaryPhoneNumberController.text,
        email: step3Controller.emailAddressController.text,

        website: step3Controller.websiteController.text,
        faxNumber: step3Controller.faxNumberController.text,
        gradingSystem: '',
        examPattern: '',
        academicLevel: '',
        mediumOfInstruction: '',
        academicYear: AcademicYear(start: DateTime.now(),end:  DateTime.now()),
        classes: [],
        campusSize: double.tryParse(step4Controller.campusSizeController.text)?? 0.0 ,
        facilitiesAvailable: step4Controller.selectedAvailableFacilities,
        laboratoriesAvailable: step4Controller.selectedLaboratories,
        sportsFacilities: step4Controller.selectedSportsFacilities,
        numberOfBuildings: int.tryParse(step4Controller.numberOfBuildingsController.text) ?? 0 ,
        numberOfFloors: int.tryParse(step4Controller.numberOfFloorsController.text)?? 0,
        numberOfClassrooms: int.tryParse(step4Controller.totalClassroomsController.text)?? 0,
        schoolTimings: SchoolTimings(openingTime: DateTime.now(), closingTime: DateTime.now()),
        extracurricularActivities: [],
        clubs: [],
        societies: [],
        sportsTeams: [],
        annualEvents: [],
        rankings: [],
        awards: [],
        accreditations: [],
        schoolImagesUrl: [],
        holidays: [],
        noOfPeriodsPerDay: 0,
        feeStructure: [],
        principals: [],
        vicePrincipals: [],
        teachers: [],
        maintenanceStaff: [],
        drivers: [],
        securityGuards: [],
        directors: [],
        sportsCoaches: [],
        schoolNurses: [],
        schoolAdministrators: [],
        itSupportStaff: [],
        librarians: [],
        departmentHeads: [],
        guidanceCounselors: [],
      );
    } catch (dataError) {
      print('Error while building school data: $dataError');
      MyHelperFunctions.showErrorSnackBar(
        'Failed to collect school data. Please check your input.',
      );
      return null;
    }
  }

  //Clear form fields
  void clearForm(){
    step1Controller.schoolNameController.clear();
    step1Controller.schoolIdController.clear();
    step1Controller.establishedYearController.clear();
    step1Controller.affiliationBoardController.clear();
    step1Controller.schoolMottoController.clear();
    step1Controller.selectedSchoolType.value = '';
    step1Controller.selectedAcademicLevel.value = '';

    step2Controller.addressController.clear();
    step2Controller.streetController.clear();
    step2Controller.cityController.clear();
    step2Controller.stateController.clear();
    step2Controller.districtController.clear();
    step2Controller.zipCodeController.clear();
    step2Controller.countryController.clear();
    step2Controller.landmarksNearbyController.clear();
    step2Controller.selectedState.value ='';
    step2Controller.selectedCountry.value ='';

    step3Controller.primaryPhoneNumberController.clear();
    step3Controller.secondaryPhoneNumberController.clear();
    step3Controller.emailAddressController.clear();
    step3Controller.websiteController.clear();
    step3Controller.faxNumberController.clear();

    step4Controller.campusSizeController.clear();
    step4Controller.numberOfBuildingsController.clear();
    step4Controller.numberOfFloorsController.clear();
    step4Controller.totalClassroomsController.clear();
    step4Controller.selectedAvailableFacilities.clear();
    step4Controller.selectedLaboratories.clear();
    step4Controller.selectedSportsFacilities.clear();

    step5Controller.periodsPerDayController.clear();
    step5Controller.startTime;
    step5Controller.endTime;
    step5Controller.assemblyStartTime;
    step5Controller.assemblyEndTime;
    step5Controller.breakStartTime;
    step5Controller.breakEndTime;
    step5Controller.holidayNameController.clear();
    step5Controller.holidayDescriptionController.clear();
    step5Controller.holidayDurationController.clear();
    step5Controller.holidayDate;
    step5Controller.selectedHolidayType.value ='';
    step5Controller.selectedAcademicYearStart.value ='';
    step5Controller.selectedAcademicYearEnd.value ='';

    step6Controller.principalNameController.clear();
    step6Controller.vicePrincipalNameController.clear();
    step6Controller.headOfAdministrationController.clear();
    step6Controller.numberOfTeachingStaffController.clear();
    step6Controller.numberOfNonTeachingStaffController.clear();
    step6Controller.affiliationRegistrationNumberController.clear();
    step6Controller.schoolManagementAuthorityController.clear();

    step7Controller.accreditationDetailsController.clear();
    step7Controller.awardsReceivedController.clear();
    step7Controller.rankingRecognitionController.clear();
    step7Controller.accreditingBodyController.clear();
    step7Controller.certificationNumberController.clear();
    step7Controller.accreditationDateController.clear();
    step7Controller.validityPeriodController.clear();
    step7Controller.standardsMetController.clear();
    step7Controller.selectedAccreditationLevel.value ='';
    step7Controller.selectedSection.value ='';

    step8Controller.clubsController.clear();
    step8Controller.societiesController.clear();
    step8Controller.sportsTeamsController.clear();
    step8Controller.annualEventsController.clear();
    step8Controller.communityServiceController.clear();
  }

  void decrementStep() {
    if (activeStep.value > 0) {
      activeStep.value--;
      pageController.jumpToPage(activeStep.value);
    }
  }

  @override
  void onClose() {
    step1Controller.onClose();
    step2Controller.onClose();
    step3Controller.onClose();
    step4Controller.onClose();
    step5Controller.onClose();
    step6Controller.onClose();
    step7Controller.onClose();
// step8Controller.onClose();
    super.onClose();
  }

  double ftToCm(int ft, double inch) => ((ft * 12) + inch) * 2.54;
}