import 'dart:async';
import 'dart:io';
import 'package:cambridge_school/app/modules/user_management/create_user/repositories/user_repository.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/searchable_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/services/firebase/auth_service.dart';
import '../../../../../core/widgets/text_field.dart';
import '../models/roles.dart';
import '../models/user_model.dart';
import '../screens/success_screen.dart';
import '../screens/otp_screen.dart';

class CreateUserController extends GetxController {
  //----------------------------------------------------------------------------
  // Constants

  final requiredValidator =
  RequiredValidator(errorText: 'This field is required');

  //----------------------------------------------------------------------------
  // Observables (Reactive Variables) for Form Validation

  Rx<bool?> personalInfoValid = Rx<bool?>(null);
  Rx<bool?> loginInfoValid = Rx<bool?>(null);
  Rx<bool?> studentDetailsValid = Rx<bool?>(null);
  Rx<bool?> teacherDetailsValid = Rx<bool?>(null);
  Rx<bool?> driverDetailsValid = Rx<bool?>(null);
  Rx<bool?> fatherDetailsValid = Rx<bool?>(null);
  Rx<bool?> motherDetailsValid = Rx<bool?>(null);
  Rx<bool?> addressDetailsValid = Rx<bool?>(null);
  Rx<bool?> emergencyContactValid = Rx<bool?>(null);
  Rx<bool?> physicalHealthValid = Rx<bool?>(null);
  Rx<bool?> transportDetailsValid = Rx<bool?>(null);
  Rx<bool?> accountDetailsValid = Rx<bool?>(null);
  Rx<bool?> personalInterestsValid = Rx<bool?>(null);

  //----------------------------------------------------------------------------
  // Form Controllers

  // --- Core Identity ---
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxString verificationId = "".obs;
  final fullNameController = TextEditingController();

  // --- Profile Information ---
  Rx<File?> profileImage = Rx<File?>(null);
  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final Rx<DateTime?> joiningDate = Rx<DateTime?>(null);
  Rx<String?> gender = Rx<String?>(null);
  Rx<String?> religion = Rx<String?>(null);
  Rx<String?> category = Rx<String?>(null);
  final phoneNoController = TextEditingController();
  final profileDescriptionController = TextEditingController();
  RxList<String> languagesSpoken = <String>[].obs;
  RxList<String> hobbies = <String>[].obs;
  Rx<String?> nationality = Rx<String?>(null);

  // --- Physical Attributes ---
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  Rx<String?> bloodGroup = Rx<String?>(null);
  RxBool isPhysicalDisability = false.obs;

  // --- Relationship ---
  Rx<String?> maritalStatus = Rx<String?>(null);

  // --- Address ---
  final isSameAsPermanent = RxBool(false);

  final permanentHouseAddressController = TextEditingController();
  final permanentCityController = TextEditingController();
  Rx<String?> permanentDistrict = Rx<String?>(null);
  Rx<String?> permanentState = Rx<String?>(null);
  final permanentVillageController = TextEditingController();
  final permanentPinCodeController = TextEditingController();

  final currentHouseAddressController = TextEditingController();
  final currentCityController = TextEditingController();
  Rx<String?> currentDistrict = Rx<String?>(null);
  Rx<String?> currentState = Rx<String?>(null);
  final currentVillageController = TextEditingController();
  final currentPinCodeController = TextEditingController();

  Rx<String?> modeOfTransport = Rx<String?>(null);
  final transportRouteNumberController = TextEditingController();
  final transportPickupPointController = TextEditingController();
  final transportDropOffPointController = TextEditingController();
  final transportVehicleNumberController = TextEditingController();
  final transportFareController = TextEditingController();

  // --- Roles ---
  RxList<String> selectedRoles = <String>[].obs;
  RxList<UserRole> selectedRoles1 = <UserRole>[].obs;

  // --- Role-Based Details ---
  // Student Details
  final studentIdController = TextEditingController();
  final rollNumberController = TextEditingController();
  final admissionNoController = TextEditingController();
  Rx<String?> className = Rx<String?>(null);
  Rx<String?> section = Rx<String?>(null);
  Rx<String?> house = Rx<String?>(null);
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
  Rx<String?> emergencyRelationship = Rx<String?>(null);
  final emergencyPhoneNumberController = TextEditingController();
  final emergencyEmailAddressController = TextEditingController();

  // --- Parent Details ---
  final fatherFullNameController = TextEditingController();
  Rx<String?> fatherRelationshipToStudent = Rx<String?>(null);
  Rx<String?> fatherOccupation = Rx<String?>(null);
  final fatherPhoneNumberController = TextEditingController();
  final fatherEmailAddressController = TextEditingController();
  Rx<String?> fatherHighestEducationLevel = Rx<String?>(null);
  final fatherAnnualIncomeController = TextEditingController();

  final motherFullNameController = TextEditingController();
  Rx<String?> motherRelationshipToStudent = Rx<String?>(null);
  Rx<String?> motherOccupation = Rx<String?>(null);
  final motherPhoneNumberController = TextEditingController();
  final motherEmailAddressController = TextEditingController();
  Rx<String?> motherHighestEducationLevel = Rx<String?>(null);
  final motherAnnualIncomeController = TextEditingController();

  final guardianFullNameController = TextEditingController();
  Rx<String?> guardianRelationshipToStudent = Rx<String?>(null);
  Rx<String?> guardianOccupation = Rx<String?>(null);
  final guardianPhoneNumberController = TextEditingController();
  final guardianEmailAddressController = TextEditingController();
  Rx<String?> guardianHighestEducationLevel = Rx<String?>(null);
  final guardianAnnualIncomeController = TextEditingController();

  // --- Favorites ---
  Rx<String?> favoriteDish = Rx<String?>(null);
  Rx<String?> favoriteSubject = Rx<String?>(null);
  Rx<String?> favoriteTeacher = Rx<String?>(null);
  Rx<String?> favoriteBook = Rx<String?>(null);
  Rx<String?> favoriteSport = Rx<String?>(null);
  Rx<String?> favoriteAthlete = Rx<String?>(null);
  Rx<String?> favoriteMovie = Rx<String?>(null);
  Rx<String?> favoriteCuisine = Rx<String?>(null);
  Rx<String?> favoriteSinger = Rx<String?>(null);
  Rx<String?> favoritePlaceToVisit = Rx<String?>(null);
  Rx<String?> favoriteFestival = Rx<String?>(null);
  Rx<String?> favoritePersonality = Rx<String?>(null);
  Rx<String?> favoriteSeason = Rx<String?>(null);
  Rx<String?> favoriteAnimal = Rx<String?>(null);
  Rx<String?> favoriteQuote = Rx<String?>(null);

  //----------------------------------------------------------------------------
  // Form Management

  final formKey = GlobalKey<FormState>(); // Form Key

  //----------------------------------------------------------------------------
  // Qualification Details

  RxList<Qualification> qualifications = <Qualification>[].obs;

  // For Dialog Input Fields
  final degreeNameController = TextEditingController();
  final institutionNameController = TextEditingController();
  final passingYearController = TextEditingController();
  Rx<String?> majorSubject = Rx<String?>(null);
  final resultController = TextEditingController();
  final resultType = RxString('Percentage');
  Rx<Qualification?> editingQualification = Rx<Qualification?>(null);

  // Optional school ID
  final schoolIdController = TextEditingController();

  //----------------------------------------------------------------------------
  // Initialization

  @override
  void onInit() {
    super.onInit();
    // You might initialize some data here if needed
  }

  //----------------------------------------------------------------------------
  // Dialog Related Methods (Add/Edit Qualification)

  /// Adds a new qualification or edits an existing one.
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

  /// Edits an existing qualification.
  void editQualification(Qualification qualification) {
    editingQualification.value = qualification;
    fillDialogFields(qualification);
    showAddQualificationDialog(Get.context!); // Show the dialog in edit mode
  }

  /// Deletes a qualification.
  void deleteQualification(Qualification qualification) {
    qualifications.remove(qualification);
  }

  /// Shows the Add Qualification dialog.
  void showAddQualificationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Obx(
              () => Text(
            editingQualification.value == null
                ? 'Add Qualification'
                : 'Edit Qualification',
            style: MyTextStyle.headlineSmall,
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
                            selectedValue: resultController.text.obs,
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

  /// Fills the dialog fields with data from a `Qualification` object for editing.
  void fillDialogFields(Qualification qualification) {
    degreeNameController.text = qualification.degreeName ?? '';
    institutionNameController.text = qualification.institutionName ?? '';
    passingYearController.text = qualification.passingYear ?? '';
    majorSubject.value = qualification.majorSubject ?? '';
    resultType.value = qualification.resultType ?? '';
    resultController.text = qualification.result ?? '';
  }

  /// Clears all the fields in the Add Qualification dialog.
  void clearDialogFields() {
    degreeNameController.clear();
    institutionNameController.clear();
    passingYearController.clear();
    majorSubject.value = null;
    resultType.value = '';
    resultController.clear();
  }

  //----------------------------------------------------------------------------
  // Validation Related Methods

  /// Validates all form fields at once.
  bool validateAllFields() {
    bool personalInfo = _validatePersonalInformationFields();
    bool loginInfo = _validateLoginInformationFields();
    bool fatherDetails = _validateFatherDetailsFields();
    bool motherDetails = _validateMotherDetailsFields();
    bool addressDetails = _validateAddressDetailsFields();
    bool emergencyContact = _validateEmergencyContactFields();
    bool transportDetails = _validateTransportationDetailsFields();
    bool physicalHealth = _validatePhysicalHealthInformationFields();
    bool studentDetails = _validateStudentDetailsFields();
    bool teacherDetails = _validateTeacherDetailsFields();
    bool driverDetails = _validateDriverDetailsFields();
    bool securityGuardDetails = _validateSecurityGuardDetailsFields();
    bool maintenanceStaffDetails = _validateMaintenanceStaffDetailsFields();
    bool adminDetails = _validateAdminDetailsFields();
    bool schoolAdminDetails = _validateSchoolAdminDetailsFields();
    bool directorDetails = _validateDirectorDetailsFields();
    bool departmentHeadDetails = _validateDepartmentHeadDetailsFields();

    personalInfoValid.value = personalInfo;
    loginInfoValid.value = loginInfo;
    fatherDetailsValid.value = fatherDetails;
    motherDetailsValid.value = motherDetails;
    addressDetailsValid.value = addressDetails;
    emergencyContactValid.value = emergencyContact;
    transportDetailsValid.value = transportDetails;
    physicalHealthValid.value = physicalHealth;

    return formKey.currentState!.validate() &&
        personalInfo &&
        loginInfo &&
        fatherDetails &&
        motherDetails &&
        addressDetails &&
        emergencyContact &&
        transportDetails &&
        physicalHealth &&
        studentDetails &&
        teacherDetails &&
        driverDetails &&
        securityGuardDetails &&
        maintenanceStaffDetails &&
        adminDetails &&
        schoolAdminDetails &&
        directorDetails &&
        departmentHeadDetails;
  }

  /// Validates personal information fields.
  bool _validatePersonalInformationFields() {
    return gender.value != null &&
        gender.value!.isNotEmpty &&
        religion.value != null &&
        religion.value!.isNotEmpty &&
        category.value != null &&
        category.value!.isNotEmpty &&
        nationality.value != null &&
        nationality.value!.isNotEmpty &&
        maritalStatus.value != null &&
        maritalStatus.value!.isNotEmpty;
  }

  /// Validates physical health information fields.
  bool _validatePhysicalHealthInformationFields() {
    return heightController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        bloodGroup.value != null &&
        bloodGroup.value!.isNotEmpty;
  }

  /// Validates father details fields.
  bool _validateFatherDetailsFields() {
    return fatherRelationshipToStudent.value != null &&
        fatherRelationshipToStudent.value!.isNotEmpty &&
        fatherOccupation.value != null &&
        fatherOccupation.value!.isNotEmpty &&
        fatherHighestEducationLevel.value != null &&
        fatherHighestEducationLevel.value!.isNotEmpty;
  }

  /// Validates mother details fields.
  bool _validateMotherDetailsFields() {
    return motherRelationshipToStudent.value != null &&
        motherRelationshipToStudent.value!.isNotEmpty &&
        motherOccupation.value != null &&
        motherOccupation.value!.isNotEmpty &&
        motherHighestEducationLevel.value != null &&
        motherHighestEducationLevel.value!.isNotEmpty;
  }

  /// Validates address details fields.
  bool _validateAddressDetailsFields() {
    return permanentDistrict.value != null &&
        permanentDistrict.value!.isNotEmpty &&
        permanentState.value != null &&
        permanentState.value!.isNotEmpty;
  }

  /// Validates emergency contact fields.
  bool _validateEmergencyContactFields() {
    return emergencyRelationship.value != null &&
        emergencyRelationship.value!.isNotEmpty;
  }

  /// Validates transportation details fields.
  bool _validateTransportationDetailsFields() {
    if (modeOfTransport.value == null) {
      return false;
    } else {
      if (modeOfTransport.value == 'School Transport') {
        return transportRouteNumberController.text.isNotEmpty &&
            transportPickupPointController.text.isNotEmpty &&
            transportDropOffPointController.text.isNotEmpty &&
            transportVehicleNumberController.text.isNotEmpty &&
            transportFareController.text.isNotEmpty;
      } else {
        return true;
      }
    }
  }

  /// Validates login information fields.
  bool _validateLoginInformationFields() {
    return usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  /// Validates student details fields.
  bool _validateStudentDetailsFields() {
    return !selectedRoles.contains(UserRole.Student.name) ||
        (rollNumberController.text.isNotEmpty &&
            admissionNoController.text.isNotEmpty &&
            className.value != null &&
            className.value!.isNotEmpty &&
            section.value != null &&
            section.value!.isNotEmpty);
  }

  /// Validates teacher details fields.
  bool _validateTeacherDetailsFields() {
    return !selectedRoles.contains(UserRole.Teacher.name) ||
        subjectsTaught.isNotEmpty;
  }

  /// Validates driver details fields.
  bool _validateDriverDetailsFields() {
    return !selectedRoles.contains(UserRole.BusDriver.name) ||
        licenseNumberController.text.isNotEmpty;
  }

  /// Validates security guard details fields.
  bool _validateSecurityGuardDetailsFields() {
    return !selectedRoles.contains(UserRole.SecurityGuard.name) ||
        assignedAreaController.text.isNotEmpty;
  }

  /// Validates maintenance staff details fields.
  bool _validateMaintenanceStaffDetailsFields() {
    return !selectedRoles.contains(UserRole.Janitor.name) ||
        maintenanceResponsibilities.isNotEmpty;
  }

  /// Validates admin details fields.
  bool _validateAdminDetailsFields() {
    return !selectedRoles.contains(UserRole.Admin.name) ||
        (adminPermissions.isNotEmpty &&
            assignedModules.isNotEmpty &&
            manageableSchools.isNotEmpty);
  }

  /// Validates school admin details fields.
  bool _validateSchoolAdminDetailsFields() {
    return !selectedRoles.contains(UserRole.SchoolAdmin.name) ||
        (schoolAdminPermissions.isNotEmpty &&
            schoolAdminAssignedModules.isNotEmpty);
  }

  /// Validates director details fields.
  bool _validateDirectorDetailsFields() {
    return !selectedRoles.contains(UserRole.Director.name) ||
        (directorSchools.isNotEmpty &&
            yearsInManagementController.text.isNotEmpty &&
            directorPermissions.isNotEmpty);
  }

  /// Validates department head details fields.
  bool _validateDepartmentHeadDetailsFields() {
    return !selectedRoles.contains(UserRole.DepartmentHead.name) ||
        (departmentController.text.isNotEmpty &&
            yearsAsHeadController.text.isNotEmpty &&
            departmentResponsibilities.isNotEmpty);
  }

  //----------------------------------------------------------------------------
  // Firebase Authentication and Firestore Interaction

  /// Sends an OTP to the user's phone number and navigates to the OTP screen.
  Future<void> _sendOtpAndNavigate(String phoneNumber) async {
    FirebaseAuthService firebaseAuth = FirebaseAuthService();
    UserRepository userRepository = UserRepository();

    firebaseAuth.sendOtp("+91${phoneNoController.text.trim()}",
            (newVerificationId, resendToken) {
          verificationId.value = newVerificationId;
          print("OTP Sent! Verification ID: ${verificationId.value}");

          Get.to(
                () => OtpScreen(
              mobileNo: phoneNoController.text.trim(),
              verificationId: verificationId.value,
              onOtpEntered: (otp) async {
                try {
                  // Attempt Login First
                  final phoneNumberLogin = await firebaseAuth.verifyOtpAndLogin(
                    verificationId: verificationId.value,
                    otp: otp,
                  );

                  if (phoneNumberLogin != null) {
                    //Login Succesfull
                    //Get the users with the logged in phonenumber

                    String userId = const Uuid().v4();
                    UserModel newUser = buildUserModel(userId);

                    await userRepository.createUser(newUser);
                    Get.offAll(() => SuccessScreen(user: newUser));

                    print(
                        "User did exist in FireAuth: ${phoneNumberLogin} creating him in firestore");
                  } else {
                    //  PHONE NUMBER LOGIN FAILED - Try to Register then

                    final phoneNumberRegistration =
                    await firebaseAuth.verifyOtpAndRegister(
                      verificationId: verificationId.value,
                      otp: otp,
                    );

                    if (phoneNumberRegistration != null) {
                      // Registration was successful in Firebase Authentication.
                      // Now create a new user in Firestore.

                      String userId = const Uuid().v4();
                      UserModel newUser = buildUserModel(userId);

                      await userRepository.createUser(newUser);
                      Get.offAll(() => SuccessScreen(user: newUser));
                      print(
                          "NEW user created in Firebase Authenthication and Firestore");
                    } else {
                      // Both login and registration with phone number failed. Something is very wrong.
                      Get.snackbar("Error", "Authentication failed.",
                          backgroundColor: Colors.red);
                    }
                  }
                } catch (authError) {
                  print("Authentication error: $authError");
                  Get.snackbar("Error", "Authentication failed: $authError",
                      backgroundColor: Colors.red);
                }
              },
            ),
          );
        });
  }

  /// Builds a `UserModel` object from the form data.
  UserModel buildUserModel(String userId) {
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
      relationship: emergencyRelationship.value,
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
    final studentDetails = selectedRoles.contains(UserRole.Student.name)
        ? StudentDetails(
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

    final teacherDetails = selectedRoles.contains(UserRole.Teacher.name)
        ? TeacherDetails(
      subjectsTaught: subjectsTaught.toList(),
      experience: experienceController.text,
    )
        : null;

    final securityGuardDetails =
    selectedRoles.contains(UserRole.SecurityGuard.name)
        ? SecurityGuardDetails(
      assignedArea: assignedAreaController.text,
    )
        : null;

    final maintenanceStaffDetails =
    selectedRoles.contains(UserRole.Janitor.name)
        ? MaintenanceStaffDetails(
      responsibilities: maintenanceResponsibilities.toList(),
    )
        : null;

    final driverDetails = selectedRoles.contains(UserRole.BusDriver.name)
        ? DriverDetails(
      licenseNumber: licenseNumberController.text,
      routesAssigned: routesAssigned.toList(),
    )
        : null;

    final adminDetails = selectedRoles.contains(UserRole.Admin.name)
        ? AdminDetails(
      permissions: adminPermissions.toList(),
      assignedModules: assignedModules.toList(),
      manageableSchools: manageableSchools.toList(),
    )
        : null;

    final schoolAdminDetails = selectedRoles.contains(UserRole.SchoolAdmin.name)
        ? SchoolAdminDetails(
      permissions: schoolAdminPermissions.toList(),
      assignedModules: schoolAdminAssignedModules.toList(),
    )
        : null;

    final directorDetails = selectedRoles.contains(UserRole.Director.name)
        ? DirectorDetails(
      schools: directorSchools.toList(),
      yearsInManagement: int.tryParse(yearsInManagementController.text),
      permissions: directorPermissions.toList(),
    )
        : null;

    final departmentHeadDetails =
    selectedRoles.contains(UserRole.DepartmentHead.name)
        ? DepartmentHeadDetails(
      department: departmentController.text,
      yearsAsHead: int.tryParse(yearsAsHeadController.text),
      responsibilities: departmentResponsibilities.toList(),
    )
        : null;

    // --- Create UserModelMain instance ---
    final user = UserModel(
      userId: userId,
      username: usernameController.text,
      email: emailController.text,
      accountStatus: 'pending',
      fullName: fullNameController.text,
      profileImageUrl: "", //profileImageUrl removed to prevent confusion
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
      selectedRoles.contains(UserRole.Student.name) ? studentDetails : null,
      teacherDetails:
      selectedRoles.contains(UserRole.Teacher.name) ? teacherDetails : null,
      directorDetails: selectedRoles.contains(UserRole.Director.name)
          ? directorDetails
          : null,
      adminDetails:
      selectedRoles.contains(UserRole.Admin.name) ? adminDetails : null,
      securityGuardDetails: selectedRoles.contains(UserRole.SecurityGuard.name)
          ? securityGuardDetails
          : null,
      maintenanceStaffDetails:
      selectedRoles.contains(UserRole.Janitor.name)
          ? maintenanceStaffDetails
          : null,
      driverDetails:
      selectedRoles.contains(UserRole.BusDriver.name) ? driverDetails : null,
      schoolAdminDetails: selectedRoles.contains(UserRole.SchoolAdmin.name)
          ? schoolAdminDetails
          : null,
      departmentHeadDetails:
      selectedRoles.contains(UserRole.DepartmentHead.name)
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
      schoolId:
      schoolIdController.text.isNotEmpty ? schoolIdController.text : null,
      userAttendance: null,
    );
    return user;
  }

  /// Combines the steps to add a new user to Firestore.
  Future<void> addUserToFirestore() async {
    if (true) {
      try {
        await _sendOtpAndNavigate(phoneNoController.text.trim());
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

  //----------------------------------------------------------------------------
  // Utility Methods (Role Selection)

  /// Checks if a role is selected.
  bool isRoleSelected(UserRole role) {
    return selectedRoles1.contains(role);
  }

  /// Toggles the selection of a role.
  void toggleRoleSelection(UserRole role) {
    if (isRoleSelected(role)) {
      selectedRoles1.remove(role);
    } else {
      selectedRoles1.add(role);
    }
  }

  /// Gets the asset path for a given `UserRole`.
  String getAssetPath(UserRole role) {
    switch (role) {
      case UserRole.SuperAdmin:
        return 'assets/icons/super_admin.svg'; // Replace with your actual path
      case UserRole.Admin:
        return 'assets/icons/admin.svg'; // Replace with your actual path
      case UserRole.Teacher:
        return 'assets/icons/teacher.svg'; // Replace with your actual path
    // Add cases for all other roles
      default:
        return 'assets/icons/default.svg'; // Default icon
    }
  }

  //----------------------------------------------------------------------------
  // Cleanup

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
    guardianFullNameController.dispose();
    guardianPhoneNumberController.dispose();
    guardianEmailAddressController.dispose();
    guardianAnnualIncomeController.dispose();
    schoolIdController.dispose();
    degreeNameController.dispose();
    institutionNameController.dispose();
    passingYearController.dispose();
    resultController.dispose();

    super.onClose();
  }
}