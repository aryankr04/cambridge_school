import 'dart:io';

import 'package:cambridge_school/app/modules/user_management/create_user/repositories/user_repository.dart';
import 'package:cambridge_school/core/services/firebase/firestore_service.dart';
import 'package:cambridge_school/core/services/firebase/storage_service.dart';
import 'package:cambridge_school/core/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../school_model.dart';
import 'create_school_screen.dart';

class CreateSchoolController extends GetxController {
  final UserRepository firebaseFunction = UserRepository();
  final FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  final FirestoreService firestoreService = FirestoreService();

  // Step 1 - General Information
  final schoolNameController = TextEditingController();
  final schoolIdController = TextEditingController();
  final establishedYearController = TextEditingController();
  final affiliationBoardController = TextEditingController();
  final schoolMottoController = TextEditingController();
  final aboutSchoolController = TextEditingController();
  final affiliationRegistrationNumberController = TextEditingController();
  final schoolManagementAuthorityController = TextEditingController();
  final image = Rx<File?>(null);
  RxString selectedSchoolType = ''.obs;
  RxString selectedAcademicLevel = ''.obs;
  RxString selectedMediumOfInstruction = ''.obs;

  // Step 2 - Location Details
  final addressController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();
  final landmarksNearbyController = TextEditingController();
  RxString selectedCountry = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedDistrict = ''.obs;
  var states = [
    'Bihar',
    'Uttar Pradesh',
    'Maharashtra',
    'Tamil Nadu',
    'Karnataka',
    'Punjab'
  ].obs;
  var countries = [
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia'
  ].obs;

  // Step 3 - Contact Information
  final primaryPhoneNumberController = TextEditingController();
  final secondaryPhoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final websiteController = TextEditingController();
  final faxNumberController = TextEditingController();

  // Step 4 - Infrastructure Details
  final campusSizeController = TextEditingController();
  final numberOfBuildingsController = TextEditingController();
  RxString selectedNumberOfFloors = ''.obs;
  RxString selectedNumberOfBuildings = ''.obs;
  RxString selectedTotalClassrooms = ''.obs;
  final selectedAvailableFacilities = <String>[].obs;
  final selectedSportsFacilities = <String>[].obs;
  final selectedMusicAndArtFacilities = <String>[].obs;
  final selectedStudentClubs = <String>[].obs;
  final selectedSpecialTrainingPrograms = <String>[].obs;
  final selectedLabsAvailable = <String>[].obs;
  final selectedGeneralFacilities = <String>[].obs;
  final selectedTransportFacilities = <String>[].obs;
  final selectedSportsInfrastructure = <String>[].obs;
  final selectedHealthAndSafetyFacilities = <String>[].obs;
  final selectedAdditionalFacilities = <String>[].obs;

  // Step 5 - Academic Details
  final periodsPerDayController = TextEditingController();
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyEndTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakEndTime = Rx<TimeOfDay?>(null);
  // State for co-curricular activities
  var selectedAcademicYearStart = ''.obs;
  var selectedAcademicYearEnd = ''.obs;

  // Step 6 - Administrative Information
  final principalNameController = TextEditingController();
  final vicePrincipalNameController = TextEditingController();
  final headOfAdministrationController = TextEditingController();
  final numberOfTeachingStaffController = TextEditingController();
  final numberOfNonTeachingStaffController = TextEditingController();
  RxString selectedGradingSystem = ''.obs;
  RxString selectedExaminationPattern = ''.obs;

  // Step 7 - Branding Setup
  final ImagePicker picker = ImagePicker();
  final List<SchoolImage> schoolGallery = <SchoolImage>[].obs;
  final schoolLogoImage = Rx<File?>(null);
  final schoolCoverImage = Rx<File?>(null);

  // Step 8 - Authentication
  final adminPhoneNoController = TextEditingController();

  // Overall Controller State
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

  void decrementStep() {
    if (activeStep.value > 0) {
      activeStep.value--;
      pageController.jumpToPage(activeStep.value);
    }
  }

  bool isFormValid() {
    return schoolNameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        primaryPhoneNumberController.text.isNotEmpty &&
        campusSizeController.text.isNotEmpty &&
        periodsPerDayController.text.isNotEmpty;
  }

  bool isImageSelected() {
    if (image.value == null) {
      MyHelperFunctions.showAlertSnackBar('Please select an image.');
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
            'Please fill valid details and select an image.');
        return;
      }

      final SchoolModel? school = await _buildSchoolData();
      if (school == null) {
        Get.back();
        MyHelperFunctions.showErrorSnackBar(
            'There was an error while building the school. Please try again');
        return;
      }

      const String schoolId = 'SCH00001';

      String? schoolLogoImageUrl;
      try {
        schoolLogoImageUrl =
        await firebaseStorageService.uploadImageFromMemory(
          image.value!,
          schoolId,
          'school_logo_images',
        );
        if (schoolLogoImageUrl == null || schoolLogoImageUrl.isEmpty) {
          MyHelperFunctions.showErrorSnackBar(
              'Error uploading school logo. Please check your network connection.');
          return;
        }
      } catch (imageUploadError) {
        print('Error uploading image: $imageUploadError');
        MyHelperFunctions.showErrorSnackBar(
            'Failed to upload school logo. Please try again.');
        return;
      }

      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('schools').doc(schoolId).set(school.toMap());
      } catch (firestoreError) {
        print('Firestore Error: $firestoreError');
        MyHelperFunctions.showErrorSnackBar(
            'Failed to add school to Firestore: ${firestoreError.toString()}');
        return;
      }

      clearForm();
      Get.back();
      MyHelperFunctions.showSuccessSnackBar(
          '${schoolNameController.text} added successfully!');
    } catch (e) {
      print('Unexpected Error adding school: $e');
      MyHelperFunctions.showErrorSnackBar(
          'An unexpected error occurred. Please try again.');
    } finally {
      Get.back();
    }
  }

  Future<SchoolModel?> _buildSchoolData() async {
    try {
      final address = SchoolAddress(
        streetAddress: addressController.text,
        country: selectedCountry.value,
        state: selectedState.value,
        city: cityController.text,
        district: districtController.text,
        pinCode: zipCodeController.text,
        village: landmarksNearbyController.text,
      );

      final schoolData = SchoolModel(
        schoolId: '',
        logoUrl: '',
        schoolName: schoolNameController.text,
        schoolSlogan: schoolMottoController.text,
        aboutSchool: aboutSchoolController.text,
        status: 'Pending',
        establishedYear: DateTime.now(),
        createdAt: DateTime.now(),
        schoolingSystem: selectedSchoolType.value,
        schoolBoard: selectedAcademicLevel.value,
        schoolCode: schoolIdController.text,
        schoolType: selectedSchoolType.value,
        affiliationNumber: affiliationRegistrationNumberController.text,
        schoolManagementAuthority: schoolManagementAuthorityController.text,
        address: address,
        primaryPhoneNo: primaryPhoneNumberController.text,
        secondaryPhoneNo: secondaryPhoneNumberController.text,
        email: emailAddressController.text,
        website: websiteController.text,
        faxNumber: faxNumberController.text,
        gradingSystem: selectedGradingSystem.value,
        examPattern: selectedExaminationPattern.value,
        academicLevel: selectedAcademicLevel.value,
        mediumOfInstruction: selectedMediumOfInstruction.value,
        academicYear: AcademicYear(start: DateTime.now(), end: DateTime.now()),
        classes: [],
        subjects: [],
        grades: [],
        campusSize: double.tryParse(campusSizeController.text) ?? 0.0,
        facilitiesAvailable: selectedAvailableFacilities,
        laboratoriesAvailable: selectedLabsAvailable,
        sportsFacilities: selectedSportsFacilities,
        numberOfBuildings: int.tryParse(numberOfBuildingsController.text) ?? 0,
        numberOfFloors: 0,
        numberOfClassrooms: 0,
        schoolTimings: SchoolTimings(openingTime: DateTime.now(), closingTime: DateTime.now()),
        extracurricularActivities: [],
        clubs: [],
        societies: [],
        sportsTeams: [],
        academicEvents: [],
        accreditations: [],
        rankings: [],
        awards: [],
        schoolImagesUrl: [],
        holidays: [],
        noOfPeriodsPerDay: int.tryParse(periodsPerDayController.text) ?? 0,
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
        emergencyContactName: '',
        emergencyContactPhone: '',
        firstAidFacilities: '',
        primaryColor: const Color(0xFF007BFF),
        secondaryColor: const Color(0xFF6C757D),
        managingTrustName: '',
        registeredAddress: '',
        registeredContactNumber: '',
        totalBoys: 0,
        totalGirls: 0,
        studentTeacherRatio: 0.0,
        scholarshipPrograms: [],
        transportationDetails: '',
        feePaymentMethods: '',
        lateFeePolicy: '',
        curriculumFrameworks: [],
        languagesOffered: [],
        specializedPrograms: [],
        hasCCTV: false,
        hasFireSafetyEquipment: false,
        isWheelchairAccessible: false,
        hasSmartClassrooms: false,
        numberOfComputers: 0,
        hasInternetAccess: false,
        onlineLearningPlatform: '',
        featuredNews: [],
        importantNotices: [],
        alumni: [],
        feeDueDate: DateTime.now(),
      );

      return schoolData;
    } catch (dataError) {
      print('Error while building school data: $dataError');
      MyHelperFunctions.showErrorSnackBar(
          'Failed to collect school data. Please check your input.');
      return null;
    }
  }

  void clearForm() {
    schoolNameController.clear();
    schoolIdController.clear();
    establishedYearController.clear();
    affiliationBoardController.clear();
    schoolMottoController.clear();
    selectedSchoolType.value = '';
    selectedAcademicLevel.value = '';

    addressController.clear();
    streetController.clear();
    cityController.clear();
    stateController.clear();
    districtController.clear();
    zipCodeController.clear();
    countryController.clear();
    landmarksNearbyController.clear();
    selectedState.value = '';
    selectedCountry.value = '';

    primaryPhoneNumberController.clear();
    secondaryPhoneNumberController.clear();
    emailAddressController.clear();
    websiteController.clear();
    faxNumberController.clear();

    campusSizeController.clear();
    numberOfBuildingsController.clear();
    selectedAvailableFacilities.clear();
    selectedSportsFacilities.clear();

    periodsPerDayController.clear();
    startTime.value = null;
    endTime.value = null;
    assemblyStartTime.value = null;
    assemblyEndTime.value = null;
    breakStartTime.value = null;
    breakEndTime.value = null;
    selectedAcademicYearStart.value = '';
    selectedAcademicYearEnd.value = '';

    principalNameController.clear();
    vicePrincipalNameController.clear();
    headOfAdministrationController.clear();
    numberOfTeachingStaffController.clear();
    numberOfNonTeachingStaffController.clear();

    adminPhoneNoController.clear();
    image.value = null;
    schoolLogoImage.value = null;
    schoolCoverImage.value = null;
    schoolGallery.clear();

  }

  Future<void> pickImages(String placeName) async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      List<String> imageUrls = await uploadImagesToFirebase(pickedFiles);
      schoolGallery.add(SchoolImage(placeName: placeName, imageUrls: imageUrls));
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile> pickedFiles) async {
    List<String> uploadedUrls = [];
    for (XFile file in pickedFiles) {
      File imageFile = File(file.path);
      String fileName = "school_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      uploadedUrls.add(imageUrl);
    }
    return uploadedUrls;
  }

  @override
  void onClose() {
    schoolNameController.dispose();
    schoolIdController.dispose();
    establishedYearController.dispose();
    affiliationBoardController.dispose();
    schoolMottoController.dispose();

    addressController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    districtController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    landmarksNearbyController.dispose();

    primaryPhoneNumberController.dispose();
    secondaryPhoneNumberController.dispose();
    emailAddressController.dispose();
    websiteController.dispose();
    faxNumberController.dispose();

    campusSizeController.dispose();
    numberOfBuildingsController.dispose();

    periodsPerDayController.dispose();

    principalNameController.dispose();
    vicePrincipalNameController.dispose();
    headOfAdministrationController.dispose();
    numberOfTeachingStaffController.dispose();
    numberOfNonTeachingStaffController.dispose();

    adminPhoneNoController.dispose();
    pageController.dispose();
    super.onClose();
  }

  double ftToCm(int ft, double inch) => ((ft * 12) + inch) * 2.54;
}

class SchoolImage {
  final String placeName;
  final List<String> imageUrls;

  SchoolImage({required this.placeName, required this.imageUrls});
}