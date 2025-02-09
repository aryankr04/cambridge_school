import 'dart:io';
import 'package:cambridge_school/app/modules/user_management/screens/create_user_screen.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/text_field.dart';
import '../models/user_model.dart';

class CreateUserController extends GetxController {
  final requiredValidator =
  RequiredValidator(errorText: 'This field is required');

  // Validation Flags (NEW)
  RxBool personalInfoValid = true.obs;
  RxBool loginInfoValid = true.obs;
  RxBool studentDetailsValid = true.obs;
  RxBool teacherDetailsValid = true.obs;
  RxBool driverDetailsValid = true.obs;
  RxBool fatherDetailsValid = true.obs;
  RxBool motherDetailsValid = true.obs;
  RxBool addressDetailsValid = true.obs;
  RxBool emergencyContactValid = true.obs;
  RxBool physicalHealthValid = true.obs;
  RxBool transportDetailsValid = true.obs;
  RxBool accountDetailsValid = true.obs;
  RxBool personalInterestsValid = true.obs;

  // --- Core Identity ---
  final userId = '';
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  // --- Profile Information ---
  Rx<File?> profileImage = Rx<File?>(null);
  final profileImageUrl = '';
  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final Rx<DateTime?> joiningDate = Rx<DateTime?>(null);
  RxString gender = ''.obs;
  RxString religion = ''.obs;
  RxString category = ''.obs;
  final phoneNoController = TextEditingController();
  final profileDescriptionController = TextEditingController();
  RxList<String> languagesSpoken = <String>[].obs;
  RxList<String> hobbies = <String>[].obs;
  RxString nationality = ''.obs;

  // --- Physical Attributes ---
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  RxString bloodGroup = ''.obs;
  RxBool isPhysicalDisability = false.obs;

  // --- Relationship ---
  RxString maritalStatus = ''.obs;

  // --- Address ---
  final isSameAsPermanent = RxBool(false);

  final permanentHouseAddressController = TextEditingController();
  final permanentCityController = TextEditingController();
  final permanentDistrict = ''.obs;
  final permanentState = ''.obs;
  final permanentVillageController = TextEditingController();
  final permanentPinCodeController = TextEditingController();

  final currentHouseAddressController = TextEditingController();
  final currentCityController = TextEditingController();
  final currentDistrict = ''.obs;
  final currentState = ''.obs;
  final currentVillageController = TextEditingController();
  final currentPinCodeController = TextEditingController();

  RxString modeOfTransport = ''.obs;
  final transportRouteNumberController = TextEditingController();
  final transportPickupPointController = TextEditingController();
  final transportDropOffPointController = TextEditingController();
  final transportVehicleNumberController = TextEditingController();
  final transportFareController = TextEditingController();

  // --- Roles
  RxList<String> selectedRoles = <String>[].obs;

  // --- Role-Based Details ---

  // Student Details
  final studentIdController = TextEditingController();
  final rollNumberController = TextEditingController();
  final admissionNoController = TextEditingController();
  RxString className = ''.obs;
  RxString section = ''.obs;
  RxString house = ''.obs;
  Rx<DateTime?> admissionDate = Rx<DateTime?>(null);
  final previousSchoolNameController = TextEditingController();
  final ambitionController = TextEditingController();

  final selectedGuardian = Rx<String?>(null);

  Rx<File?> studentImage = Rx<File?>(null);
  Rx<File?> aadhaarCardImage = Rx<File?>(null);
  Rx<File?> birthCertificateImage = Rx<File?>(null);
  Rx<File?> transferCertificateImage = Rx<File?>(null);

  // Teacher Details
  final teacherIdController = TextEditingController();
  RxList<String> subjectsTaught = <String>[].obs;
  final experienceController = TextEditingController();

  // Security Guard Details
  final assignedAreaController = TextEditingController();

  // Maintenance Staff Details
  RxList<String> maintenanceResponsibilities = <String>[].obs;

  // Driver Details
  final licenseNumberController = TextEditingController();
  RxList<String> routesAssigned = <String>[].obs;

  // Admin Details
  RxList<String> adminPermissions = <String>[].obs;
  RxList<String> assignedModules = <String>[].obs;
  RxList<String> manageableSchools = <String>[].obs;

  // School Admin Details
  RxList<String> schoolAdminPermissions = <String>[].obs;
  RxList<String> schoolAdminAssignedModules = <String>[].obs;

  // Director Details
  RxList<String> directorSchools = <String>[].obs;
  final yearsInManagementController = TextEditingController();
  RxList<String> directorPermissions = <String>[].obs;

  // Department Head Details
  final departmentController = TextEditingController();
  final yearsAsHeadController = TextEditingController();
  RxList<String> departmentResponsibilities = <String>[].obs;

  // --- Emergency Contact ---
  final emergencyFullNameController = TextEditingController();
  final emergencyRelationshipController = TextEditingController();
  final emergencyPhoneNumberController = TextEditingController();
  final emergencyEmailAddressController = TextEditingController();

  // --- Parent Details ---
  final fatherFullNameController = TextEditingController();
  RxString fatherRelationshipToStudent = ''.obs;
  RxString fatherOccupation = ''.obs;
  final fatherPhoneNumberController = TextEditingController();
  final fatherEmailAddressController = TextEditingController();
  final fatherHighestEducationLevel = ''.obs;
  final fatherAnnualIncomeController = TextEditingController();

  final motherFullNameController = TextEditingController();
  RxString motherRelationshipToStudent = ''.obs;
  RxString motherOccupation = ''.obs;
  final motherPhoneNumberController = TextEditingController();
  final motherEmailAddressController = TextEditingController();
  final motherHighestEducationLevel = ''.obs;
  final motherAnnualIncomeController = TextEditingController();

  final guardianFullNameController = TextEditingController();
  RxString guardianRelationshipToStudent = ''.obs;
  final guardianOccupation = ''.obs;
  final guardianPhoneNumberController = TextEditingController();
  final guardianEmailAddressController = TextEditingController();
  final guardianHighestEducationLevel = ''.obs;
  final guardianAnnualIncomeController = TextEditingController();

  // --- Favorites ---
  RxString favoriteDish = ''.obs;
  RxString favoriteSubject = ''.obs;
  RxString favoriteTeacher = ''.obs;
  RxString favoriteBook = ''.obs;
  RxString favoriteSport = ''.obs;
  RxString favoriteAthlete = ''.obs;
  RxString favoriteMovie = ''.obs;
  RxString favoriteCuisine = ''.obs;
  RxString favoriteSinger = ''.obs;
  RxString favoritePlaceToVisit = ''.obs;
  RxString favoriteFestival = ''.obs;
  RxString favoritePersonality = ''.obs;
  RxString favoriteSeason = ''.obs;
  RxString favoriteAnimal = ''.obs;
  RxString favoriteQuote = ''.obs;

  final formKey = GlobalKey<FormState>(); // Form Key

  RxList<Qualification> qualifications = <Qualification>[].obs;

  // For Dialog Input Fields
  final degreeNameController = TextEditingController();
  final institutionNameController = TextEditingController();
  final passingYearController = TextEditingController();
  final majorSubject = ''.obs;

  final resultController = TextEditingController(); // Holds the result value
  final resultType =
  RxString('Percentage'); // Holds the result type (Grade, Percentage, CGPA)
  Rx<Qualification?> editingQualification = Rx<Qualification?>(null);

  // Optional school ID
  final schoolIdController = TextEditingController();

  void addQualification() {
    // Validation: Check if resultType and result are both provided
    if (resultType.value.isNotEmpty && resultController.text.isEmpty) {
      Get.snackbar("Error",
          "Please provide a result value when a result type is selected.");
      return;
    }

    final newQualification = Qualification(
      degreeName: degreeNameController.text,
      institutionName: institutionNameController.text,
      passingYear: passingYearController.text,
      majorSubject: majorSubject.value,
      resultType: resultType.value,
      result: resultController.text,
    );

    if (editingQualification.value != null) {
      // Edit existing qualification
      final index = qualifications.indexOf(editingQualification.value!);
      qualifications[index] = newQualification;
    } else {
      // Add new qualification
      qualifications.add(newQualification);
    }

    Get.back(); // Close the dialog
    clearDialogFields();
    editingQualification.value = null; // Reset editing mode
  }

  void editQualification(Qualification qualification) {
    editingQualification.value = qualification;
    fillDialogFields(qualification);
    showAddQualificationDialog(Get.context!); // Show the dialog in edit mode
  }

  void deleteQualification(Qualification qualification) {
    qualifications.remove(qualification);
  }

  void showAddQualificationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Obx(
              () => Text(
            editingQualification.value == null
                ? 'Add Qualification'
                : 'Edit Qualification',
            style: MyTextStyles.headlineSmall,
          ),
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyTextField(
                  labelText: 'Degree Name',
                  controller: degreeNameController,
                ),
                MySearchableDropdown(
                  onSelected: (val) {
                    majorSubject.value = val;
                  },
                  labelText: 'Major Subject',
                  options: MyLists.majorSubjects,
                ),
                const SizedBox(height: MySizes.md),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Institution Name',
                  controller: institutionNameController,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Passing Year',
                  controller: passingYearController,
                ),
                const SizedBox(height: MySizes.md),

                // Result Type Dropdown
                Row(
                  children: [
                    Expanded(
                      child: MyDropdownField(
                        labelText: 'Result Type',
                        selectedValue: resultType,
                        options: const ['Percentage', 'CGPA', 'Grade'],
                        onSelected: (value) {
                          resultType.value = value!;
                          resultController.text = ''; // Reset input field
                        },
                      ),
                    ),
                    const SizedBox(
                      width: MySizes.md,
                    ),
                    Obx(() {
                      if (resultType.value == 'Percentage') {
                        return Expanded(
                          child: MyTextField(
                            labelText: 'Percentage',
                            controller: resultController,
                            keyboardType: TextInputType.number,
                          ),
                        );
                      } else if (resultType.value == 'CGPA') {
                        return Expanded(
                          child: MyTextField(
                            labelText: 'CGPA',
                            controller: resultController,
                            keyboardType: TextInputType.number,
                          ),
                        );
                      } else if (resultType.value == 'Grade') {
                        return Expanded(
                          child: MyDropdownField(
                            labelText: 'Grade',
                            options: MyLists.gradeOptions,
                            selectedValue: resultController.text.isEmpty
                                ? null
                                : resultController.text.obs,
                            onSelected: (value) {
                              resultController.text = value!;
                            },
                          ),
                        );
                      }
                      return const SizedBox(); // Return empty space if no type selected
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
              clearDialogFields();
              editingQualification.value = null; // Reset editing mode
            },
          ),
          Obx(
                () => FilledButton(
              child:
              Text(editingQualification.value == null ? "Add" : "Update"),
              onPressed: () {
                addQualification();
              },
            ),
          ),
        ],
      ),
    );
  }

  void fillDialogFields(Qualification qualification) {
    degreeNameController.text = qualification.degreeName ?? '';
    institutionNameController.text = qualification.institutionName ?? '';
    passingYearController.text = qualification.passingYear ?? '';
    majorSubject.value = qualification.majorSubject ?? '';
    resultType.value = qualification.resultType ?? '';
    resultController.text = qualification.result ?? '';
  }

  void clearDialogFields() {
    degreeNameController.clear();
    institutionNameController.clear();
    passingYearController.clear();
    majorSubject.value = '';
    resultType.value = '';
    resultController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    // You might initialize some data here if needed
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // --- Validation Methods ---
  bool _validatePersonalInformationFields() {
    bool isValid = true;

    if (fullNameController.text.isEmpty) {
      isValid = false;
    }

    if (phoneNoController.text.isEmpty) {
      isValid = false;
    }

    if (dateOfBirth.value == null) {
      // If date is required
      isValid = false;
    }

    if (gender.value.isEmpty) {
      isValid = false;
    }

    // More fields checks...
    personalInfoValid(isValid);
    return isValid;
  }

  bool _validatePhysicalHealthFields() {
    bool isValid = true;

    // Example validations:
    if (heightController.text.isEmpty) {
      isValid = false;
    }
    if (weightController.text.isEmpty) {
      isValid = false;
    }
    if (bloodGroup.value.isEmpty) {
      isValid = false;
    }

    physicalHealthValid(isValid);
    return isValid;
  }

  bool _validateFatherDetailsFields() {
    bool isValid = true;
    //Check if fatherNameController is empty or not
    if (fatherFullNameController.text.isEmpty) {
      isValid = false;
    }
    fatherDetailsValid(isValid);
    return isValid;
  }

  bool _validateMotherDetailsFields() {
    bool isValid = true;
    //Check if motherNameController is empty or not
    if (motherFullNameController.text.isEmpty) {
      isValid = false;
    }
    motherDetailsValid(isValid);
    return isValid;
  }

  bool _validateLoginInformationFields() {
    bool isValid = true;
    //Check if passwordController is empty or not
    if (passwordController.text.isEmpty) {
      isValid = false;
    }
    //Check if emailController is empty or not
    if (emailController.text.isEmpty) {
      isValid = false;
    }
    //Check if usernameController is empty or not
    if (usernameController.text.isEmpty) {
      isValid = false;
    }

    loginInfoValid(isValid);
    return isValid;
  }

  bool _validateStudentDetailsFields() {
    bool isValid = true;

    if (rollNumberController.text.isEmpty) {
      isValid = false;
    }

    if (admissionNoController.text.isEmpty) {
      isValid = false;
    }

    if (className.value.isEmpty) {
      isValid = false;
    }

    if (section.value.isEmpty) {
      isValid = false;
    }

    studentDetailsValid(isValid);
    return isValid;
  }

  bool _validateAddressDetailsFields() {
    bool isValid = true;

    if (permanentHouseAddressController.text.isEmpty) {
      isValid = false;
    }
    if (permanentCityController.text.isEmpty) {
      isValid = false;
    }
    if (permanentDistrict.value.isEmpty) {
      isValid = false;
    }
    if (permanentState.value.isEmpty) {
      isValid = false;
    }
    if (permanentPinCodeController.text.isEmpty) {
      isValid = false;
    }

    if (!isSameAsPermanent.value) {
      // Only validate current address if it is different
      if (currentHouseAddressController.text.isEmpty) {
        isValid = false;
      }
      if (currentCityController.text.isEmpty) {
        isValid = false;
      }
      if (currentDistrict.value.isEmpty) {
        isValid = false;
      }
      if (currentState.value.isEmpty) {
        isValid = false;
      }
      if (currentPinCodeController.text.isEmpty) {
        isValid = false;
      }
    }

    addressDetailsValid(isValid);
    return isValid;
  }

  bool _validateEmergencyContactFields() {
    bool isValid = true;

    if (emergencyFullNameController.text.isEmpty) {
      isValid = false;
    }
    if (emergencyPhoneNumberController.text.isEmpty) {
      isValid = false;
    }
    if (emergencyRelationshipController.text.isEmpty) {
      isValid = false;
    }

    emergencyContactValid(isValid);
    return isValid;
  }

  bool _validateTransportDetailsFields() {
    bool isValid = true;

    // If school transport is selected, all the school transport fields should have values
    if (modeOfTransport.value == "School Transport") {
      if (transportRouteNumberController.text.isEmpty) {
        isValid = false;
      }
      if (transportPickupPointController.text.isEmpty) {
        isValid = false;
      }
      if (transportDropOffPointController.text.isEmpty) {
        isValid = false;
      }
      if (transportVehicleNumberController.text.isEmpty) {
        isValid = false;
      }
      if (transportFareController.text.isEmpty) {
        isValid = false;
      }
    }

    transportDetailsValid(isValid);
    return isValid;
  }

  bool _validateAccountDetailsFields() {
    bool isValid = true;

    if (usernameController.text.isEmpty) {
      isValid = false;
    }
    if (emailController.text.isEmpty) {
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      isValid = false;
    }

    accountDetailsValid(isValid);
    return isValid;
  }

  bool _validateTeacherDetailsFields() {
    bool isValid = true;

    if (subjectsTaught.isEmpty) {
      isValid = false;
    }

    if (joiningDate.value == null) {
      isValid = false;
    }

    teacherDetailsValid(isValid);
    return isValid;
  }

  bool _validateDriverDetailsFields() {
    bool isValid = true;

    if (licenseNumberController.text.isEmpty) {
      isValid = false;
    }

    driverDetailsValid(isValid);
    return isValid;
  }

  bool _validatePersonalInterestsFields() {
    personalInterestsValid(true); // Always valid, no required fields
    return true;
  }

  // Function to add user data to Firestore (replace with your Firestore logic)
  Future<void> addUserToFirestore() async {
    if (validateForm()) {
      try {
        // --- Address ---
        final permanentAddress = Address(
          houseAddress: permanentHouseAddressController.text,
          city: permanentCityController.text,
          district: permanentDistrict.value,
          state: permanentState.value,
          village: permanentVillageController.text,
          pinCode: permanentPinCodeController.text,
        );

        final currentAddress = Address(
          houseAddress: currentHouseAddressController.text,
          city: currentCityController.text,
          district: currentDistrict.value,
          state: currentState.value,
          village: currentVillageController.text,
          pinCode: currentPinCodeController.text,
        );

        // --- Transport Details ---
        final transportDetails = TransportDetails(
          routeNumber: transportRouteNumberController.text,
          pickupPoint: transportPickupPointController.text,
          dropOffPoint: transportDropOffPointController.text,
          vehicleNumber: transportVehicleNumberController.text,
          fare: double.tryParse(transportFareController.text),
        );

        // --- Emergency Contact ---
        final emergencyContact = EmergencyContact(
          fullName: emergencyFullNameController.text,
          relationship: emergencyRelationshipController.text,
          phoneNumber: emergencyPhoneNumberController.text,
          emailAddress: emergencyEmailAddressController.text,
        );

        // --- Parent Details ---
        final fatherDetails = GuardianDetails(
          fullName: fatherFullNameController.text,
          relationshipToStudent: fatherRelationshipToStudent.value,
          occupation: fatherOccupation.value,
          phoneNumber: fatherPhoneNumberController.text,
          emailAddress: fatherEmailAddressController.text,
          highestEducationLevel: fatherHighestEducationLevel.value,
          annualIncome: fatherAnnualIncomeController.text,
        );

        final motherDetails = GuardianDetails(
          fullName: motherFullNameController.text,
          relationshipToStudent: motherRelationshipToStudent.value,
          occupation: motherOccupation.value,
          phoneNumber: motherPhoneNumberController.text,
          emailAddress: motherEmailAddressController.text,
          highestEducationLevel: motherHighestEducationLevel.value,
          annualIncome: motherAnnualIncomeController.text,
        );

        // --- Favorites ---
        final favorites = Favorite(
          dish: favoriteDish.value,
          subject: favoriteSubject.value,
          teacher: favoriteTeacher.value,
          book: favoriteBook.value,
          sport: favoriteSport.value,
          athlete: favoriteAthlete.value,
          movie: favoriteMovie.value,
          cuisine: favoriteCuisine.value,
          singer: favoriteSinger.value,
          favoritePlaceToVisit: favoritePlaceToVisit.value,
          festival: favoriteFestival.value,
          personality: favoritePersonality.value,
          season: favoriteSeason.value,
          animal: favoriteAnimal.value,
          quote: favoriteQuote.value,
        );

        // --- Role-Based Details ---
        final studentDetails =
        selectedRoles.contains(UserRole.student.name)
            ? StudentDetails(
          studentId: studentIdController.text,
          rollNumber: rollNumberController.text,
          admissionNo: admissionNoController.text,
          className: className.value,
          section: section.value,
          house: house.value,
          admissionDate: admissionDate.value,
          previousSchoolName: previousSchoolNameController.text,
          averageMarks: 0,
          ambition: ambitionController.text,
        )
            : null;

        final teacherDetails =
        selectedRoles.contains(UserRole.teacher.name)
            ? TeacherDetails(
          teacherId: teacherIdController.text,
          subjectsTaught: subjectsTaught.toList(),
          experience: experienceController.text,
        )
            : null;

        final securityGuardDetails = selectedRoles
            .contains(UserRole.securityGuard.name)
            ? SecurityGuardDetails(
          assignedArea: assignedAreaController.text,
        )
            : null;

        final maintenanceStaffDetails = selectedRoles
            .contains(UserRole.maintenanceStaff.name)
            ? MaintenanceStaffDetails(
          responsibilities: maintenanceResponsibilities.toList(),
        )
            : null;

        final driverDetails = selectedRoles.contains(UserRole.driver.name)
            ? DriverDetails(
          licenseNumber: licenseNumberController.text,
          routesAssigned: routesAssigned.toList(),
        )
            : null;

        final adminDetails = selectedRoles.contains(UserRole.admin.name)
            ? AdminDetails(
          permissions: adminPermissions.toList(),
          assignedModules: assignedModules.toList(),
          manageableSchools: manageableSchools.toList(),
        )
            : null;

        final schoolAdminDetails = selectedRoles
            .contains(UserRole.schoolAdmin.name)
            ? SchoolAdminDetails(
          permissions: schoolAdminPermissions.toList(),
          assignedModules: schoolAdminAssignedModules.toList(),
        )
            : null;

        final directorDetails = selectedRoles.contains(UserRole.director.name)
            ? DirectorDetails(
          schools: directorSchools.toList(),
          yearsInManagement:
          int.tryParse(yearsInManagementController.text),
          permissions: directorPermissions.toList(),
        )
            : null;

        final departmentHeadDetails = selectedRoles
            .contains(UserRole.departmentHead.name)
            ? DepartmentHeadDetails(
          department: departmentController.text,
          yearsAsHead: int.tryParse(yearsAsHeadController.text),
          responsibilities: departmentResponsibilities.toList(),
        )
            : null;

        // --- Create UserModelMain instance ---
        final user = UserModelMain(
          userId: userId,
          username: usernameController.text,
          email: emailController.text,
          accountStatus: 'pending',
          fullName: fullNameController.text,
          profileImageUrl: profileImageUrl,
          dob: dateOfBirth.value,
          gender: gender.value,
          religion: religion.value,
          category: category.value,
          phoneNo: phoneNoController.text,
          profileDescription: profileDescriptionController.text,
          languagesSpoken: languagesSpoken.toList(),
          hobbies: hobbies.toList(),
          nationality: nationality.value,
          height: double.tryParse(heightController.text),
          weight: double.tryParse(weightController.text),
          bloodGroup: bloodGroup.value,
          isPhysicalDisability: isPhysicalDisability.value,
          maritalStatus: maritalStatus.value,
          permanentAddress: permanentAddress,
          currentAddress: currentAddress,
          modeOfTransport: modeOfTransport.value,
          transportDetails: transportDetails,
          createdAt: DateTime.now(),
          roles: selectedRoles
              .map((roleName) =>
              UserRole.values.firstWhere((role) => role.name == roleName))
              .toList(),
          studentDetails:
          selectedRoles.contains(UserRole.student.name)
              ? studentDetails
              : null,
          teacherDetails:
          selectedRoles.contains(UserRole.teacher.name)
              ? teacherDetails
              : null,
          directorDetails:
          selectedRoles.contains(UserRole.director.name)
              ? directorDetails
              : null,
          adminDetails: selectedRoles.contains(UserRole.admin.name)
              ? adminDetails
              : null,
          securityGuardDetails: selectedRoles
              .contains(UserRole.securityGuard.name)
              ? securityGuardDetails
              : null,
          maintenanceStaffDetails: selectedRoles
              .contains(UserRole.maintenanceStaff.name)
              ? maintenanceStaffDetails
              : null,
          driverDetails: selectedRoles.contains(UserRole.driver.name)
              ? driverDetails
              : null,
          schoolAdminDetails: selectedRoles
              .contains(UserRole.schoolAdmin.name)
              ? schoolAdminDetails
              : null,
          departmentHeadDetails: selectedRoles
              .contains(UserRole.departmentHead.name)
              ? departmentHeadDetails
              : null,
          emergencyContact: emergencyContact,
          fatherDetails: fatherDetails,
          motherDetails: motherDetails,
          favorites: favorites,
          points: 0,
          performanceRating: 0,
          qualifications: qualifications.toList(),
          joiningDate: joiningDate.value,
          schoolId: schoolIdController.text.isNotEmpty
              ? schoolIdController.text
              : null,
          userAttendance: null,
        );

        // Replace with your actual Firestore write operation
        print("User data: ${user.toMap()}");
        Get.snackbar("Success", "User data added to Firestore successfully!",
            backgroundColor: Colors.green);
      } catch (e) {
        print("Error adding user to Firestore: $e");
        Get.snackbar("Error", "Failed to add user data: $e",
            backgroundColor: Colors.red);
      }
    } else {
      Get.snackbar("Error", "Please fill all required fields correctly.",
          backgroundColor: Colors.orange);
    }
  }

  @override
  void onClose() {
    // Dispose of all controllers to prevent memory leaks
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneNoController.dispose();
    profileDescriptionController.dispose();
    heightController.dispose();
    weightController.dispose();
    permanentHouseAddressController.dispose();
    permanentCityController.dispose();
    permanentVillageController.dispose();
    permanentPinCodeController.dispose();
    currentHouseAddressController.dispose();
    currentCityController.dispose();
    currentVillageController.dispose();
    currentPinCodeController.dispose();
    transportRouteNumberController.dispose();
    transportPickupPointController.dispose();
    transportDropOffPointController.dispose();
    transportVehicleNumberController.dispose();
    transportFareController.dispose();
    studentIdController.dispose();
    rollNumberController.dispose();
    admissionNoController.dispose();
    previousSchoolNameController.dispose();
    ambitionController.dispose();
    teacherIdController.dispose();
    experienceController.dispose();
    assignedAreaController.dispose();
    licenseNumberController.dispose();
    yearsInManagementController.dispose();
    departmentController.dispose();
    yearsAsHeadController.dispose();
    emergencyFullNameController.dispose();
    emergencyRelationshipController.dispose();
    emergencyPhoneNumberController.dispose();
    emergencyEmailAddressController.dispose();
    fatherFullNameController.dispose();
    fatherPhoneNumberController.dispose();
    fatherEmailAddressController.dispose();
    fatherAnnualIncomeController.dispose();
    motherFullNameController.dispose();
    motherPhoneNumberController.dispose();
    motherEmailAddressController.dispose();
    motherAnnualIncomeController.dispose();
    guardianFullNameController.dispose(); //Added Guardian name Controller
    guardianPhoneNumberController.dispose(); //Added Guardian Number Controller
    guardianEmailAddressController.dispose(); //Added Guardian email Controller
    guardianAnnualIncomeController.dispose(); //Added Guardian Income Controller
    schoolIdController.dispose();
    degreeNameController.dispose();
    institutionNameController.dispose();
    passingYearController.dispose();
    resultController.dispose();

    super.onClose();
  }
}