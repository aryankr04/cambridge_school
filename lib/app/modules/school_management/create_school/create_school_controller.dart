import 'dart:io';
import 'dart:math';

import 'package:cambridge_school/app/modules/user_management/create_user/repositories/user_repository.dart';
import 'package:cambridge_school/core/services/firebase/firestore_service.dart';
import 'package:cambridge_school/core/services/firebase/storage_service.dart';
import 'package:cambridge_school/core/utils/constants/enums/account_status.dart';
import 'package:cambridge_school/core/utils/constants/enums/campus_area.dart';
import 'package:cambridge_school/core/utils/constants/enums/fee_payment_methods.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_board.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_gender_policy.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_specialization.dart';
import 'package:cambridge_school/core/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/utils/constants/enums/academic_level.dart';
import '../../../../core/utils/constants/enums/exam_pattern.dart';
import '../../../../core/utils/constants/enums/grading_system.dart';
import '../../../../core/utils/constants/enums/medium_of_instruction.dart';
import '../../../../core/utils/constants/enums/school_ownership.dart';
import '../../exam/models/exam_pattern_model.dart';
import '../../fees/models/fee_structure.dart';
import '../school_model.dart';
import '../school_repository.dart';
import 'create_school_screen.dart';

class CreateSchoolController extends GetxController {
  final UserRepository firebaseFunction = UserRepository();
  final FirebaseStorageService firebaseStorageService =
      FirebaseStorageService();
  final FirestoreService firestoreService = FirestoreService();

  String schoolId = 'SCH00001';

  // Step 1 - General Information
  final schoolNameController = TextEditingController();
  final establishedYearController = TextEditingController();
  final affiliationRegistrationNumberController = TextEditingController();
  final schoolCodeController = TextEditingController();
  final schoolMottoController = TextEditingController();
  final aboutSchoolController = TextEditingController();
  final affiliationBoardController = TextEditingController();

  RxString selectedSchoolOwnership = ''.obs;
  RxString selectedSchoolSpecialization = ''.obs;
  RxString selectedSchoolGenderPolicy = ''.obs;

  // Step 2 - Location Details
  final addressController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final landmarksNearbyController = TextEditingController();

  RxString selectedCountry = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedDistrict = ''.obs;

  // Step 3 - Contact Information
  final primaryPhoneNumberController = TextEditingController();
  final secondaryPhoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final websiteController = TextEditingController();
  final faxNumberController = TextEditingController();

  // Step 4 - Infrastructure Details
  final campusSizeController = TextEditingController();
  RxString selectedNumberOfBuildings = ''.obs;
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

  // Step 5 - Administrative Details
  final periodsPerDayController = TextEditingController();
  final Rx<TimeOfDay?> arrivalTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> departureTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyEndTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakEndTime = Rx<TimeOfDay?>(null);
  // State for co-curricular activities
  RxString selectedAcademicYearStart = ''.obs;
  RxString selectedAcademicYearEnd = ''.obs;

  // Step 6 - Academic Information
  RxString selectedSchoolBoard = ''.obs;

  RxString selectedAcademicLevel = ''.obs;
  RxString selectedMediumOfInstruction = ''.obs;
  RxString selectedGradingSystem = ''.obs;
  RxString selectedExaminationPattern = ''.obs;

  // Step 7 - Branding Setup
  final ImagePicker picker = ImagePicker();
  final RxList<SchoolImage> schoolImages = <SchoolImage>[].obs; // Use RxList
  final schoolLogoImage = Rx<File?>(null);
  final schoolCoverImage = Rx<File?>(null);

  RxString schoolLogoImageUrl = ''.obs;
  RxString schoolCoverImageUrl = ''.obs;

  // Step 8 - Authentication
  final adminPhoneNoController = TextEditingController();

  // Overall Controller State
  RxInt activeStep = 0.obs;
  late final PageController pageController =
      PageController(initialPage: activeStep.value);

  String getStepName() => stepNamesForCreateSchool[activeStep.value];

  void incrementStep() async {
    if (activeStep.value < stepNamesForCreateSchool.length - 1) {
      // Add form validation logic here before incrementing
      // For example, validate the current step's fields before moving on.
      if (_validateStep(activeStep.value) || true) {
        activeStep.value++;
        pageController.jumpToPage(activeStep.value);
      } else {
        // Show an error message or prevent the step from incrementing
        MyHelperFunctions.showAlertSnackBar(
            "Please fill in all the required fields in this step.");
      }
    }
  }

  bool _validateStep(int step) {
    // Add validation logic for each step here
    switch (step) {
      case 0: // General Information
        return schoolNameController.text.isNotEmpty &&
            establishedYearController.text.isNotEmpty &&
            affiliationRegistrationNumberController.text.isNotEmpty &&
            schoolCodeController.text.isNotEmpty &&
            selectedSchoolOwnership.value.isNotEmpty &&
            selectedSchoolSpecialization.value.isNotEmpty &&
            selectedSchoolGenderPolicy.value.isNotEmpty;
      case 1: // Location Details
        return addressController.text.isNotEmpty &&
            streetController.text.isNotEmpty &&
            cityController.text.isNotEmpty &&
            zipCodeController.text.isNotEmpty &&
            selectedCountry.value.isNotEmpty &&
            selectedState.value.isNotEmpty &&
            selectedDistrict.value.isNotEmpty;
      case 2: // Contact Information
        return primaryPhoneNumberController.text.isNotEmpty &&
            emailAddressController
                .text.isNotEmpty; // Add more validation if needed
      case 3: // Infrastructure Details
        return campusSizeController.text.isNotEmpty &&
            selectedNumberOfBuildings.value.isNotEmpty;
      case 4: // Administrative Details
        return periodsPerDayController.text.isNotEmpty &&
            arrivalTime.value != null &&
            departureTime.value != null &&
            selectedAcademicYearStart.value.isNotEmpty &&
            selectedAcademicYearEnd.value.isNotEmpty;
      case 5: // Academic Information
        return selectedSchoolBoard.value.isNotEmpty &&
            selectedAcademicLevel.value.isNotEmpty &&
            selectedMediumOfInstruction.value.isNotEmpty &&
            selectedGradingSystem.value.isNotEmpty &&
            selectedExaminationPattern.value.isNotEmpty;
      case 6: // Branding Setup -  No specific validation here as images are optional for the moment
        return true;
      case 7: // Authentication
        return adminPhoneNoController.text.isNotEmpty;
      default:
        return false;
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
    if (schoolLogoImage.value == null) {
      MyHelperFunctions.showAlertSnackBar('Please select a school logo.');
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
            'Please fill in all required details and select an image.');
        return;
      }

      final SchoolModel? school = await _buildSchoolData();
      if (school == null) {
        Get.back();
        MyHelperFunctions.showErrorSnackBar(
            'There was an error while building the school. Please try again');
        return;
      }

      String? schoolLogoImageUrl;
      try {
        schoolLogoImageUrl = await firebaseStorageService.uploadImageFromMemory(
          schoolLogoImage.value!,
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
        district: selectedDistrict.value,
        pinCode: zipCodeController.text,
        village: landmarksNearbyController.text,
      );

      final schoolData = SchoolModel(
        schoolId: schoolId,
        schoolLogoUrl: schoolLogoImageUrl.value,
        schoolName: schoolNameController.text,
        schoolSlogan: schoolMottoController.text,
        aboutSchool: aboutSchoolController.text,
        status: AccountStatus.active,
        establishedYear: establishedYearController.text.trim(),
        createdAt: DateTime.now(),
        schoolBoard: SchoolBoardExtension.fromString(selectedSchoolBoard.value),
        schoolCode: schoolCodeController.text.trim(),
        schoolOwnership:
            SchoolOwnershipExtension.fromString(selectedSchoolOwnership.value),
        affiliationNumber: affiliationRegistrationNumberController.text,
        address: address,
        primaryPhoneNo: primaryPhoneNumberController.text,
        secondaryPhoneNo: secondaryPhoneNumberController.text,
        email: emailAddressController.text,
        website: websiteController.text,
        faxNumber: faxNumberController.text,
        gradingSystem:
            GradingSystemExtension.fromString(selectedGradingSystem.value),
        examPattern: ExaminationPatternExtension.fromString(
            selectedExaminationPattern.value),
        academicLevel:
            AcademicLevelExtension.fromString(selectedAcademicLevel.value),
        mediumOfInstruction: MediumOfInstructionExtension.fromString(
            selectedMediumOfInstruction.value),
        academicYear:
            '${selectedAcademicYearStart.value} - ${selectedAcademicYearEnd.value}',
        campusSize: double.tryParse(campusSizeController.text) ?? 0.0,
        sportsFacilities: selectedSportsFacilities,
        numberOfBuildings: int.tryParse(selectedNumberOfBuildings.value) ?? 1,
        schoolTimings: SchoolTimings(
          arrivalTime: arrivalTime.value ?? const TimeOfDay(hour: 8, minute: 0),
          departureTime:
              departureTime.value ?? const TimeOfDay(hour: 15, minute: 0),
        ),
        noOfPeriodsPerDay: int.tryParse(periodsPerDayController.text) ?? 0,
        feePaymentMethods: [FeePaymentMethod.cash], // Assuming a single default
        schoolSpecialization: SchoolSpecializationExtension.fromString(
            selectedSchoolSpecialization.value),
        schoolGenderPolicy: SchoolGenderPolicyExtension.fromString(
            selectedSchoolGenderPolicy.value),
        musicAndArtFacilities: selectedMusicAndArtFacilities,
        studentClubs: selectedStudentClubs,
        specialTrainingPrograms: selectedSpecialTrainingPrograms,
        labsAvailable: selectedLabsAvailable,
        generalFacilities: selectedGeneralFacilities,
        transportFacilities: selectedTransportFacilities,
        sportsInfrastructure: selectedSportsInfrastructure,
        healthAndSafetyFacilities: selectedHealthAndSafetyFacilities,
        additionalFacilities: selectedAdditionalFacilities,
        schoolImages: schoolImages,
        schoolCoverImageUrl: schoolCoverImageUrl.value,
        employees: [],
        rankings: [],
        awards: [],
        vehicles: [],
        classroomsList: [],
        libraries: [],
        examHalls: [],
        auditoriums: [],
        hostels: [],
        staffRooms: [],
        medicalRooms: [],
        cafeterias: [],
        parking: Parking(
          cctvInstalled: false,
          parkingChargesPerHour: 0.0,
          parkingName: 'School Parking',
          reservedSlots: 0,
          totalSlots: 0,
        ),
        securitySystem: SecuritySystem(
          cctvLocations: [],
          monitoringCenter: 'Main Office',
          realTimeMonitoring: false,
          securityGuards: [],
        ),
        accreditations: [],
        alumni: [],
        featuredNews: [],
        holidays: [],
        totalBoys: 0,
        totalGirls: 0,
        studentTeacherRatio: 0.0,
        feeStructure: FeeStructure(
          year: DateTime.now().year.toString(),
        ),
        lateFeePolicy: '',
        feeDueDate: DateTime.now(),
        totalStudents: 0, createdById: '', createdByName: '', classes: [],
        subjects: [], academicEvents: [],
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
    establishedYearController.clear();
    affiliationBoardController.clear();
    schoolMottoController.clear();
    selectedSchoolOwnership.value = '';
    selectedAcademicLevel.value = '';

    addressController.clear();
    streetController.clear();
    cityController.clear();
    zipCodeController.clear();
    landmarksNearbyController.clear();
    selectedState.value = '';
    selectedCountry.value = '';

    primaryPhoneNumberController.clear();
    secondaryPhoneNumberController.clear();
    emailAddressController.clear();
    websiteController.clear();
    faxNumberController.clear();

    campusSizeController.clear();
    selectedAvailableFacilities.clear();
    selectedSportsFacilities.clear();

    periodsPerDayController.clear();
    arrivalTime.value = null;
    departureTime.value = null;
    assemblyStartTime.value = null;
    assemblyEndTime.value = null;
    breakStartTime.value = null;
    breakEndTime.value = null;
    selectedAcademicYearStart.value = '';
    selectedAcademicYearEnd.value = '';

    adminPhoneNoController.clear();
    schoolLogoImage.value = null;
    schoolCoverImage.value = null;
    schoolImages.clear();
  }

  Future<void> pickLogoImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      schoolLogoImage.value = File(pickedFile.path);
      print("School Logo Path: ${schoolLogoImage.value!.path}");
    }
  }

  Future<void> pickCoverImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      schoolCoverImage.value = File(pickedFile.path);
      print("School Cover Path: ${schoolCoverImage.value!.path}");
    }
  }

  Future<void> pickImages(CampusArea campusArea) async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      MyHelperFunctions.showLoadingOverlay();
      List<String> imageUrls = await uploadImagesToFirebase(pickedFiles);
      Get.back();
      schoolImages.addAll(imageUrls
          .map((url) => SchoolImage(campusArea: campusArea, imageUrls: [url])));
      print("School Gallery images count: ${schoolImages.length}");
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile> pickedFiles) async {
    List<String> uploadedUrls = [];
    try {
      for (XFile file in pickedFiles) {
        File imageFile = File(file.path);
        String fileName =
            "school_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await snapshot.ref.getDownloadURL();
        uploadedUrls.add(imageUrl);
      }
    } catch (e) {
      print("Error uploading images: $e");
      MyHelperFunctions.showErrorSnackBar(
          "Error uploading images, please try again");
    }

    return uploadedUrls;
  }

  @override
  void onClose() {
    schoolNameController.dispose();
    establishedYearController.dispose();
    affiliationBoardController.dispose();
    schoolMottoController.dispose();

    addressController.dispose();
    streetController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    landmarksNearbyController.dispose();

    primaryPhoneNumberController.dispose();
    secondaryPhoneNumberController.dispose();
    emailAddressController.dispose();
    websiteController.dispose();
    faxNumberController.dispose();

    campusSizeController.dispose();
    periodsPerDayController.dispose();

    adminPhoneNoController.dispose();
    pageController.dispose();
    super.onClose();
  }

  double ftToCm(int ft, double inch) => ((ft * 12) + inch) * 2.54;

  Future<void> sendDummySchoolsToFirebase() async {
    final CollectionReference schoolsCollection =
        FirebaseFirestore.instance.collection('schools');

    // Dummy School 1
    final SchoolModel school1 = SchoolModel(
      schoolId: 'dummy_school_1',
      schoolLogoUrl: 'https://example.com/logo1.png',
      schoolName: 'Cambridge Academy',
      schoolSlogan: 'Excellence in Education',
      createdById: 'admin_123',
      createdByName: 'Admin User',
      schoolCode: 'CA001',
      aboutSchool: 'A leading school focused on holistic development.',
      status: AccountStatus.active,
      establishedYear: '2005',
      createdAt: DateTime.now(),
      address: SchoolAddress(
        streetAddress: '123 Main Street',
        city: 'Anytown',
        state: 'CA',
        country: 'USA',
        pinCode: '91234',
      ),
      primaryPhoneNo: '555-123-4567',
      secondaryPhoneNo: '555-987-6543',
      email: 'info@cambridgeacademy.edu',
      website: 'https://cambridgeacademy.edu',
      faxNumber: '555-111-2222',
      schoolBoard: SchoolBoard.cbse,
      schoolOwnership: SchoolOwnership.private,
      schoolSpecialization: SchoolSpecialization.science,
      schoolGenderPolicy: SchoolGenderPolicy.coEducation,
      employees: [],
      affiliationNumber: 'CBSE12345',
      gradingSystem: GradingSystem.percentage,
      examPattern: ExaminationPattern.quarterly,
      academicLevel: AcademicLevel.seniorSecondary,
      mediumOfInstruction: MediumOfInstruction.english,
      campusSize: 10.5,
      classes: [],
      subjects: [],
      academicEvents: [],
      sportsFacilities: [],
      musicAndArtFacilities: [],
      studentClubs: [],
      specialTrainingPrograms: [],
      labsAvailable: [],
      generalFacilities: [],
      transportFacilities: [],
      sportsInfrastructure: [],
      healthAndSafetyFacilities: [],
      additionalFacilities: [],
      schoolCoverImageUrl: 'https://example.com/cover1.png',
      accreditations: [],
      rankings: [],
      awards: [],
      holidays: [],
      numberOfBuildings: 3,
      noOfPeriodsPerDay: 8,
      schoolTimings: SchoolTimings(
        arrivalTime: TimeOfDay(hour: 8, minute: 0),
        departureTime: TimeOfDay(hour: 15, minute: 0),
      ),
      academicYear: '2023-2024',
      feeStructure: FeeStructure(year: "2025"),
      totalBoys: 250,
      totalGirls: 200,
      studentTeacherRatio: 20.0,
      feePaymentMethods: [FeePaymentMethod.online, FeePaymentMethod.cash],
      lateFeePolicy: 'Rs. 100 per day after due date.',
      featuredNews: [],
      alumni: [],
      feeDueDate: DateTime.now().add(const Duration(days: 30)),
      totalStudents: 450,
      vehicles: [],
      classroomsList: [],
      libraries: [],
      examHalls: [],
      auditoriums: [],
      hostels: [],
      staffRooms: [],
      medicalRooms: [],
      cafeterias: [],
      parking: Parking(
        parkingName: 'Main Parking Lot',
        totalSlots: 150,
        reservedSlots: 20, // For staff and visitors
        cctvInstalled: true,
        parkingChargesPerHour: 2.50, // USD or your local currency
      ),
      securitySystem: SecuritySystem(
        cctvLocations: [
          'Entrance Gate',
          'Main Building Lobby',
          'Parking Lot',
          'Cafeteria Entrance',
          'Library Entrance',
        ],
        securityGuards: [
          'John Doe',
          'Jane Smith',
          'Robert Jones',
        ],
        monitoringCenter: 'Security Room A101',
        realTimeMonitoring: true,
      ),
      schoolImages: [],
    );

    // Dummy School 2
    final SchoolModel school2 = SchoolModel(
      schoolId: 'dummy_school_2',
      schoolLogoUrl: 'https://example.com/logo2.png',
      schoolName: 'Greenwood High',
      schoolSlogan: 'Cultivating Future Leaders',
      createdById: 'admin_456',
      createdByName: 'Another Admin',
      schoolCode: 'GH002',
      aboutSchool: 'Committed to providing a nurturing environment.',
      status: AccountStatus.active,
      establishedYear: '1998',
      createdAt: DateTime.now(),
      address: SchoolAddress(
        streetAddress: '456 Park Avenue',
        city: 'Hillview',
        state: 'NY',
        country: 'USA',
        pinCode: '10001',
      ),
      primaryPhoneNo: '212-555-7890',
      secondaryPhoneNo: '212-555-0123',
      email: 'info@greenwoodhigh.edu',
      website: 'https://greenwoodhigh.edu',
      faxNumber: '212-555-4444',
      schoolBoard: SchoolBoard.icse,
      schoolOwnership: SchoolOwnership.private,
      schoolSpecialization: SchoolSpecialization.sports,
      schoolGenderPolicy: SchoolGenderPolicy.boysOnly,
      employees: [],
      affiliationNumber: 'ICSE67890',
      gradingSystem: GradingSystem.percentage,
      examPattern: ExaminationPattern.trimester,
      academicLevel: AcademicLevel.secondary,
      mediumOfInstruction: MediumOfInstruction.english,
      campusSize: 8.2,
      classes: [],
      subjects: [],
      academicEvents: [],
      sportsFacilities: [],
      musicAndArtFacilities: [],
      studentClubs: [],
      specialTrainingPrograms: [],
      labsAvailable: [],
      generalFacilities: [],
      transportFacilities: [],
      sportsInfrastructure: [],
      healthAndSafetyFacilities: [],
      additionalFacilities: [],
      schoolCoverImageUrl: 'https://example.com/cover2.png',
      accreditations: [],
      rankings: [],
      awards: [],
      holidays: [],
      numberOfBuildings: 4,
      noOfPeriodsPerDay: 7,
      schoolTimings: SchoolTimings(
        arrivalTime: TimeOfDay(hour: 7, minute: 45),
        departureTime: TimeOfDay(hour: 14, minute: 45),
      ),
      academicYear: '2023-2024',
      feeStructure: FeeStructure(year: "2025"),
      totalBoys: 350,
      totalGirls: 0,
      studentTeacherRatio: 18.0,
      feePaymentMethods: [
        FeePaymentMethod.bankTransfer,
        FeePaymentMethod.cheque
      ],
      lateFeePolicy: '2% per month after due date.',
      featuredNews: [],
      alumni: [],
      feeDueDate: DateTime.now().add(Duration(days: 25)),
      totalStudents: 350,
      vehicles: [],
      classroomsList: [],
      libraries: [],
      examHalls: [],
      auditoriums: [],
      hostels: [],
      staffRooms: [],
      medicalRooms: [],
      cafeterias: [],
      parking: Parking(
        parkingName: 'Main Parking Lot',
        totalSlots: 150,
        reservedSlots: 20, // For staff and visitors
        cctvInstalled: true,
        parkingChargesPerHour: 2.50, // USD or your local currency
      ),
      securitySystem: SecuritySystem(
        cctvLocations: [
          'Entrance Gate',
          'Main Building Lobby',
          'Parking Lot',
          'Cafeteria Entrance',
          'Library Entrance',
        ],
        securityGuards: [
          'John Doe',
          'Jane Smith',
          'Robert Jones',
        ],
        monitoringCenter: 'Security Room A101',
        realTimeMonitoring: true,
      ),
      schoolImages: [],
    );

    // Dummy School 3
    final SchoolModel school3 = SchoolModel(
      schoolId: 'dummy_school_3',
      schoolLogoUrl: 'https://example.com/logo3.png',
      schoolName: 'Sunshine Montessori',
      schoolSlogan: 'Where Learning is Fun',
      createdById: 'admin_789',
      createdByName: 'Yet Another Admin',
      schoolCode: 'SM003',
      aboutSchool: 'Early childhood education with a focus on creativity.',
      status: AccountStatus.inactive,
      establishedYear: '2010',
      createdAt: DateTime.now(),
      address: SchoolAddress(
        streetAddress: '789 Sunny Lane',
        city: 'Beachville',
        state: 'FL',
        country: 'USA',
        pinCode: '33000',
      ),
      primaryPhoneNo: '305-555-3210',
      secondaryPhoneNo: '305-555-6543',
      email: 'info@sunshinemontessori.edu',
      website: 'https://sunshinemontessori.edu',
      faxNumber: '305-555-7777',
      schoolBoard: SchoolBoard.other,
      schoolOwnership: SchoolOwnership.trust,
      schoolSpecialization: SchoolSpecialization.arts,
      schoolGenderPolicy: SchoolGenderPolicy.coEducation,
      employees: [],
      affiliationNumber: 'OTHER45678',
      gradingSystem: GradingSystem.cgpa,
      examPattern: ExaminationPattern.trimester,
      academicLevel: AcademicLevel.primary,
      mediumOfInstruction: MediumOfInstruction.english,
      campusSize: 2.5,
      classes: [],
      subjects: [],
      academicEvents: [],
      sportsFacilities: [],
      musicAndArtFacilities: [],
      studentClubs: [],
      specialTrainingPrograms: [],
      labsAvailable: [],
      generalFacilities: [],
      transportFacilities: [],
      sportsInfrastructure: [],
      healthAndSafetyFacilities: [],
      additionalFacilities: [],
      schoolCoverImageUrl: 'https://example.com/cover3.png',
      accreditations: [],
      rankings: [],
      awards: [],
      holidays: [],
      numberOfBuildings: 1,
      noOfPeriodsPerDay: 6,
      schoolTimings: SchoolTimings(
        arrivalTime: TimeOfDay(hour: 9, minute: 0),
        departureTime: TimeOfDay(hour: 13, minute: 0),
      ),
      academicYear: '2023-2024',
      feeStructure: FeeStructure(year: "2025"),
      totalBoys: 80,
      totalGirls: 70,
      studentTeacherRatio: 10.0,
      feePaymentMethods: [FeePaymentMethod.cash, FeePaymentMethod.cheque],
      lateFeePolicy: 'Rs. 50 per week after due date.',
      featuredNews: [],
      alumni: [],
      feeDueDate: DateTime.now().add(Duration(days: 20)),
      totalStudents: 150,
      vehicles: [],
      classroomsList: [],
      libraries: [],
      examHalls: [],
      auditoriums: [],
      hostels: [],
      staffRooms: [],
      medicalRooms: [],
      cafeterias: [],
      parking: Parking(
        parkingName: 'Main Parking Lot',
        totalSlots: 150,
        reservedSlots: 20, // For staff and visitors
        cctvInstalled: true,
        parkingChargesPerHour: 2.50, // USD or your local currency
      ),
      securitySystem: SecuritySystem(
        cctvLocations: [
          'Entrance Gate',
          'Main Building Lobby',
          'Parking Lot',
          'Cafeteria Entrance',
          'Library Entrance',
        ],
        securityGuards: [
          'John Doe',
          'Jane Smith',
          'Robert Jones',
        ],
        monitoringCenter: 'Security Room A101',
        realTimeMonitoring: true,
      ),
      schoolImages: [],
    );

    try {
      await schoolsCollection.doc(school1.schoolId).set(school1.toMap());
      print('School 1 sent to Firebase');

      await schoolsCollection.doc(school2.schoolId).set(school2.toMap());
      print('School 2 sent to Firebase');

      await schoolsCollection.doc(school3.schoolId).set(school3.toMap());
      print('School 3 sent to Firebase');
    } catch (e) {
      print('Error sending schools to Firebase: $e');
    }
  }
}
