import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/utils/constants/enums/academic_level.dart';
import '../../../../core/utils/constants/enums/exam_pattern.dart';
import '../../../../core/utils/constants/enums/grading_system.dart';
import '../../../../core/utils/constants/enums/medium_of_instruction.dart';
import '../../../../core/utils/constants/enums/school_ownership.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../fees/models/fee_structure.dart';
import '../school_model.dart';
import '../school_repository.dart';
import 'package:cambridge_school/app/modules/user_management/create_user/repositories/user_repository.dart';
import 'package:cambridge_school/core/services/firebase/firestore_service.dart';
import 'package:cambridge_school/core/services/firebase/storage_service.dart';
import 'package:cambridge_school/core/utils/constants/enums/account_status.dart';
import 'package:cambridge_school/core/utils/constants/enums/campus_area.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_board.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_gender_policy.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_specialization.dart';

class EditSchoolController extends GetxController
    with GetTickerProviderStateMixin {
  final SchoolRepository schoolRepository;
  final UserRepository firebaseFunction;
  final FirebaseStorageService firebaseStorageService;
  final FirestoreService firestoreService;

  // Use RxString for schoolId to make it reactive
  final schoolId;

  EditSchoolController({
    required String initialSchoolId, // Pass initialSchoolId to the constructor
    SchoolRepository? schoolRepository,
    UserRepository? firebaseFunction,
    FirebaseStorageService? firebaseStorageService,
    FirestoreService? firestoreService,
  })  : schoolRepository = schoolRepository ?? SchoolRepository(),
        firebaseFunction = firebaseFunction ?? UserRepository(),
        firebaseStorageService =
            firebaseStorageService ?? FirebaseStorageService(),
        firestoreService = firestoreService ?? FirestoreService(),
        schoolId = RxString(
            initialSchoolId), // Initialize RxString in initializer list
        super() {
    print("School id in constructor: ${schoolId.value}");
  }

  // Step 1 - General Information
  final schoolNameController = TextEditingController();
  final establishedYearController = TextEditingController();
  final affiliationRegistrationNumberController = TextEditingController();
  final schoolCodeController = TextEditingController();
  final schoolMottoController = TextEditingController();
  final aboutSchoolController = TextEditingController();

  //Provide default values for enums to avoid null values when updating
  final selectedSchoolOwnership = ''.obs;
  final selectedSchoolSpecialization = ''.obs;
  final selectedSchoolGenderPolicy = ''.obs;

  // Step 2 - Location Details
  final addressController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final landmarksNearbyController = TextEditingController();

  final selectedCountry = ''.obs;
  final selectedState = ''.obs;
  final selectedDistrict = ''.obs;

  // Step 3 - Contact Information
  final primaryPhoneNumberController = TextEditingController();
  final secondaryPhoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final websiteController = TextEditingController();
  final faxNumberController = TextEditingController();

  // Step 4 - Infrastructure Details
  final campusSizeController = TextEditingController();
  final selectedNumberOfBuildings = '1'.obs;
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

  // Provide default values for time
  final Rx<TimeOfDay?> arrivalTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> departureTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> assemblyEndTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakStartTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> breakEndTime = Rx<TimeOfDay?>(null);

  // Step 5 - Administrative Details
  final periodsPerDayController = TextEditingController();

  // State for co-curricular activities
  final selectedAcademicYearStart = ''.obs;
  final selectedAcademicYearEnd = ''.obs;

  // Provide default values for enums to avoid null values when updating
  final selectedSchoolBoard = SchoolBoard.cbse.label.obs;
  final selectedAcademicLevel = AcademicLevel.primary.label.obs;
  final selectedMediumOfInstruction = MediumOfInstruction.english.label.obs;
  final selectedGradingSystem = GradingSystem.percentage.label.obs;
  final selectedExaminationPattern = ExaminationPattern.semester.label.obs;

  // Step 7 - Branding Setup
  final ImagePicker picker = ImagePicker();
  final schoolImages = <SchoolImage>[].obs; // Use RxList
  final schoolLogoImage = Rx<File?>(null);
  final schoolCoverImage = Rx<File?>(null);

  final schoolLogoImageUrl = ''.obs;
  final schoolCoverImageUrl = ''.obs;

  // Step 8 - Authentication
  final adminPhoneNoController = TextEditingController();

  // Overall Controller State
  final activeStep = 0.obs;
  late final TabController tabController =
      TabController(length: 8, vsync: this);

  // RxBool to track loading state
  final isLoading = false.obs;
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch data when schoolId is available

    fetchSchoolData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchSchoolData() async {
    isLoading.value = true;
    try {
      final school = await schoolRepository.getSchool(schoolId.value);
      // MyHelperFunctions.showErrorSnackBar('School found!');

      if (school != null) {
        populateFields(school);
      } else {
        MyHelperFunctions.showErrorSnackBar('School not found!');
      }
    } catch (e) {
      print('Error fetching school data: $e');
      MyHelperFunctions.showErrorSnackBar(
          'Failed to load school data. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void populateFields(SchoolModel school) {
    schoolNameController.text = school.schoolName;
    establishedYearController.text = school.establishedYear;
    affiliationRegistrationNumberController.text = school.affiliationNumber;
    schoolCodeController.text = school.schoolCode;
    schoolMottoController.text = school.schoolSlogan;
    aboutSchoolController.text = school.aboutSchool;

    selectedSchoolOwnership.value = school.schoolOwnership.label;
    selectedSchoolSpecialization.value = school.schoolSpecialization.label;
    selectedSchoolGenderPolicy.value = school.schoolGenderPolicy.label;

    streetController.text = school.address.streetAddress ?? '';
    cityController.text = school.address.city ?? '';
    zipCodeController.text = school.address.pinCode ?? '';
    selectedCountry.value = school.address.country ?? '';
    selectedState.value = school.address.state ?? '';
    selectedDistrict.value = school.address.district ?? '';

    primaryPhoneNumberController.text = school.primaryPhoneNo;
    secondaryPhoneNumberController.text = school.secondaryPhoneNo;
    emailAddressController.text = school.email;
    websiteController.text = school.website;
    faxNumberController.text = school.faxNumber;

    campusSizeController.text = school.campusSize.toString();
    selectedNumberOfBuildings.value = school.numberOfBuildings.toString();

    selectedAvailableFacilities.assignAll(school.generalFacilities);
    selectedSportsFacilities.assignAll(school.sportsFacilities);
    selectedMusicAndArtFacilities.assignAll(school.musicAndArtFacilities);
    selectedStudentClubs.assignAll(school.studentClubs);
    selectedSpecialTrainingPrograms.assignAll(school.specialTrainingPrograms);
    selectedLabsAvailable.assignAll(school.labsAvailable);
    selectedGeneralFacilities.assignAll(school.generalFacilities);
    selectedTransportFacilities.assignAll(school.transportFacilities);
    selectedSportsInfrastructure.assignAll(school.sportsInfrastructure);
    selectedHealthAndSafetyFacilities
        .assignAll(school.healthAndSafetyFacilities);
    selectedAdditionalFacilities.assignAll(school.additionalFacilities);
    selectedAcademicYearStart.value =
        getYearFromString(school.academicYear, YearPosition.first).toString();
    selectedAcademicYearEnd.value =
        getYearFromString(school.academicYear, YearPosition.last).toString();
    periodsPerDayController.text = school.noOfPeriodsPerDay.toString();
    arrivalTime.value = school.schoolTimings.arrivalTime;
    departureTime.value = school.schoolTimings.departureTime;
    assemblyStartTime.value = school
        .schoolTimings.assemblyStart;
    assemblyEndTime.value = school
        .schoolTimings.assemblyEnd;
    breakStartTime.value = school
        .schoolTimings.breakStart;
    breakEndTime.value =
        school.schoolTimings.breakEnd;

    selectedSchoolBoard.value = school.schoolBoard.label;
    selectedAcademicLevel.value = school.academicLevel.label;
    selectedMediumOfInstruction.value = school.mediumOfInstruction.label;
    selectedGradingSystem.value = school.gradingSystem.label;
    selectedExaminationPattern.value = school.examPattern.label;

    schoolLogoImageUrl.value = school.schoolLogoUrl;
    schoolCoverImageUrl.value = school.schoolCoverImageUrl;
    schoolImages.assignAll(school.schoolImages);
  }

  Future<void> updateSchoolData() async {
    isUpdating.value = true;
    try {
      final updatedSchool =
          await createSchoolModelFromForm(); // Await the Future<SchoolModel>

      await schoolRepository.updateSchool(updatedSchool);
      MyHelperFunctions.showSuccessSnackBar('School updated successfully!');
    } catch (e) {
      print('Error updating school: $e');
      MyHelperFunctions.showErrorSnackBar(
          'Failed to update school. Please try again.');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<SchoolModel> createSchoolModelFromForm() async {
    // Mark as async and return a Future
    final schoolName = schoolNameController.text.trim();
    final establishedYear = establishedYearController.text.trim();
    final affiliationNumber =
        affiliationRegistrationNumberController.text.trim();
    final schoolCode = schoolCodeController.text.trim();
    final schoolSlogan = schoolMottoController.text.trim();
    final aboutSchool = aboutSchoolController.text.trim();

    final streetAddress = streetController.text.trim();
    final city = cityController.text.trim();
    final pinCode = zipCodeController.text.trim();

    final primaryPhoneNo = primaryPhoneNumberController.text.trim();
    final secondaryPhoneNo = secondaryPhoneNumberController.text.trim();
    final email = emailAddressController.text.trim();
    final website = websiteController.text.trim();
    final faxNumber = faxNumberController.text.trim();

    final campusSize = double.tryParse(campusSizeController.text.trim()) ?? 0.0;
    final numberOfBuildings =
        int.tryParse(selectedNumberOfBuildings.value) ?? 1;
    final noOfPeriodsPerDay =
        int.tryParse(periodsPerDayController.text.trim()) ?? 0;

    final address = SchoolAddress(
      streetAddress: streetAddress,
      city: city,
      pinCode: pinCode,
      country: selectedCountry.value,
      state: selectedState.value,
      district: selectedDistrict.value,
      landmark: landmarksNearbyController.text.trim(),
    );

    final schoolTimings = SchoolTimings(
      arrivalTime: arrivalTime.value ?? TimeOfDay.now(),
      departureTime: departureTime.value ?? TimeOfDay.now(),
      assemblyStart: assemblyStartTime.value,
      assemblyEnd: assemblyEndTime.value,
      breakStart: breakStartTime.value,
      breakEnd: breakEndTime.value,
    );

    String logoUrl = schoolLogoImageUrl.value;
    String coverUrl = schoolCoverImageUrl.value;

    // Upload and get new logo URL if a new logo has been picked
    if (schoolLogoImage.value != null) {
      logoUrl = await uploadImage(schoolLogoImage.value!, 'logos');
    }

    // Upload and get new cover URL if a new cover has been picked
    if (schoolCoverImage.value != null) {
      coverUrl = await uploadImage(schoolCoverImage.value!, 'covers');
    }

    //Convert enums to appropriate types
    SchoolOwnership schoolOwnership =
        SchoolOwnershipExtension.fromString(selectedSchoolOwnership.value);
    SchoolSpecialization schoolSpecialization =
        SchoolSpecializationExtension.fromString(
            selectedSchoolSpecialization.value);
    SchoolGenderPolicy schoolGenderPolicy =
        SchoolGenderPolicyExtension.fromString(
            selectedSchoolGenderPolicy.value);

    // Store admin phone number for future use (e.g., sending SMS notifications)
    final adminPhoneNo = adminPhoneNoController.text.trim();
    //Store address

    return SchoolModel(
      schoolId: schoolId.value, // Use the existing schoolId
      schoolName: schoolName,
      schoolSlogan: schoolSlogan,
      aboutSchool: aboutSchool,
      establishedYear: establishedYear,
      schoolCode: schoolCode,
      affiliationNumber: affiliationNumber,
      address: address,
      primaryPhoneNo: primaryPhoneNo,
      secondaryPhoneNo: secondaryPhoneNo,
      email: email,
      website: website,
      faxNumber: faxNumber,
      campusSize: campusSize,
      numberOfBuildings: numberOfBuildings,
      noOfPeriodsPerDay: noOfPeriodsPerDay,
      schoolTimings: schoolTimings,
      schoolBoard: SchoolBoardExtension.fromString(selectedSchoolBoard.value),
      schoolOwnership: schoolOwnership,
      schoolSpecialization: schoolSpecialization,
      schoolGenderPolicy: schoolGenderPolicy,
      generalFacilities: selectedGeneralFacilities.toList(),
      sportsFacilities: selectedSportsFacilities.toList(),
      musicAndArtFacilities: selectedMusicAndArtFacilities.toList(),
      studentClubs: selectedStudentClubs,
      specialTrainingPrograms: selectedSpecialTrainingPrograms,
      labsAvailable: selectedLabsAvailable,
      transportFacilities: selectedTransportFacilities,
      sportsInfrastructure: selectedSportsInfrastructure,
      healthAndSafetyFacilities: selectedHealthAndSafetyFacilities,
      additionalFacilities: selectedAdditionalFacilities,
      schoolLogoUrl: logoUrl, // Use the new logo URL
      schoolCoverImageUrl: coverUrl, // Use the new cover URL
      schoolImages: schoolImages.toList(),
      featuredNews: [],
      accreditations: [],
      alumni: [],
      awards: [],
      cafeterias: [],
      classroomsList: [],
      employees: [],
      examHalls: [],
      feeDueDate: DateTime.now(),
      feePaymentMethods: [],
      feeStructure: FeeStructure(year: ''),
      holidays: [],
      hostels: [],
      lateFeePolicy: '',
      libraries: [],
      medicalRooms: [],
      parking: Parking(
          cctvInstalled: false,
          parkingChargesPerHour: 0,
          parkingName: '',
          reservedSlots: 0,
          totalSlots: 0),
      rankings: [],
      securitySystem: SecuritySystem(
          cctvLocations: [],
          monitoringCenter: '',
          realTimeMonitoring: false,
          securityGuards: []),
      staffRooms: [],
      status: AccountStatus.active,
      studentTeacherRatio: 0,
      totalBoys: 0,
      totalGirls: 0,
      totalStudents: 0,
      vehicles: [],
      createdAt: DateTime.now(),
      createdById: '',
      createdByName: '',
      academicEvents: [],
      academicLevel:
          AcademicLevelExtension.fromString(selectedAcademicLevel.value),
      academicYear: '$selectedAcademicYearStart - $selectedAcademicYearEnd',
      examPattern: ExaminationPatternExtension.fromString(
          selectedExaminationPattern.value),
      gradingSystem:
          GradingSystemExtension.fromString(selectedGradingSystem.value),
      mediumOfInstruction: MediumOfInstructionExtension.fromString(
          selectedMediumOfInstruction.value),
      classes: [],
      auditoriums: [],
    );
  }

  Future<String> uploadImage(File image, String folderName) async {
    try {
      String fileName =
          '$folderName/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      MyHelperFunctions.showErrorSnackBar(
          "Error uploading image, please try again");
      return ''; // Or throw the error again, depending on how you want to handle it
    }
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
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    MyHelperFunctions.showLoadingOverlay();
    List<String> imageUrls = await uploadImagesToFirebase(pickedFiles);
    Get.back();
    schoolImages.addAll(imageUrls
        .map((url) => SchoolImage(campusArea: campusArea, imageUrls: [url])));
    print("School Gallery images count: ${schoolImages.length}");
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

  int? getYearFromString(String yearRange, YearPosition position) {
    // Regular expression to extract years from the "YYYY - YYYY" format.
    final RegExp yearRegex = RegExp(r'(\d{4})\s*-\s*(\d{4})');
    final match = yearRegex.firstMatch(yearRange);

    if (match != null) {
      final firstYear =
          int.tryParse(match.group(1)!); // Use ! to assert non-null
      final lastYear =
          int.tryParse(match.group(2)!); // Use ! to assert non-null

      switch (position) {
        case YearPosition.first:
          return firstYear;
        case YearPosition.last:
          return lastYear;
        default:
          return null; // Should not happen, but good to have a default
      }
    } else {
      // Return null if the input string doesn't match the expected format.
      return null;
    }
  }
}

enum YearPosition {
  first,
  last,
}
