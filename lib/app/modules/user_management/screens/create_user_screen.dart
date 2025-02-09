import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/dialog_dropdown.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../controllers/create_user_controller.dart';
import '../models/user_model.dart';
import '../widgets/qualification_widget.dart';
import 'dart:io';

final CreateUserController controller = Get.put(CreateUserController());

class CreateUserScreen extends GetView<CreateUserController> {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Main layout for the Create User Screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MySizes.md),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRolesSection(),
              Obx(() => _buildExpansionTileCustom(
                    // Wrap with Obx
                    title: 'Personal Information',
                    leadingIsFilled:
                        controller.personalInfoValid.value, // Use RxBool
                    isValid: controller.personalInfoValid.value,
                    children: _buildPersonalInformationFields(),
                    onValidationChanged: (isValid) =>
                        controller.personalInfoValid.value = isValid,
                  )),
              _buildExpansionTileCustom(
                title: 'Health & Medical Information',
                children: _buildPhysicalHealthInformationFields(),
              ),
              _buildExpansionTileCustom(
                title: 'Father’s Details',
                children: _buildFatherDetailsFields(),
              ),
              _buildExpansionTileCustom(
                title: 'Mother’s Details',
                children: _buildMotherDetailsFields(),
              ),
              _buildExpansionTileCustom(
                title: 'Residential Address',
                children: _buildAddressDetailsFields(),
              ),
              _buildExpansionTileCustom(
                title: 'Emergency Contact Details',
                children: _buildEmergencyContactFields(),
              ),
              Obx(() {
                if (!controller.selectedRoles.contains('Student') &&
                    controller.selectedRoles.isNotEmpty) {
                  return _buildExpansionTileCustom(
                    title: 'Educational Qualifications',
                    children: _buildQualificationDetails(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              _buildRoleSpecificDetails(),
              _buildExpansionTileCustom(
                title: 'Transport Details',
                children: _buildTransportationDetailsFields(),
              ),
              _buildExpansionTileCustom(
                title: 'Personal Interests',
                children: _buildFavoritesFields(),
              ),
              Obx(() => _buildExpansionTileCustom(
                  title: 'Login & Account Information',
                  leadingIsFilled: controller.loginInfoValid.value,
                  isValid: controller.loginInfoValid.value,
                  children: _buildAccountDetailsFields(),
                  onValidationChanged: (isValid) =>
                      controller.loginInfoValid.value = isValid)),
              const SizedBox(height: MySizes.md),
              MyButton(
                text: 'Create User',
                onPressed: () {
                  // Validate all forms
                  controller.personalInfoValid.value =
                      _validatePersonalInformationFields();
                  controller.loginInfoValid.value =
                      _validateLoginInformationFields();

                  // Check if form is valid
                  if (controller.personalInfoValid.value &&
                      controller.loginInfoValid.value) {
                    controller.addUserToFirestore();
                  } else {
                    // Show error message
                    Get.snackbar('Error', 'Please fill all required fields');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Building Methods ---

  Widget _buildRolesSection() {
    // Section for selecting user roles
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.dividerColor),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Roles',
                style: TextStyle(
                    color: MyColors.headlineTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  _showAddRoleDialog();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: MyColors.activeBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+ Add Roles',
                    style: TextStyle(
                        color: MyColors.activeBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MySizes.sm + 4),
          Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...controller.selectedRoles.map((role) => Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                            color: MyColors.activeBlue,
                            borderRadius: BorderRadius.circular(24)),
                        child: Text(
                          role,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _showAddRoleDialog() async {
    // Shows a dialog to add more roles
    return showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Select Roles', style: MyTextStyles.headlineSmall),
          content: Obx(() => _buildRoleChips()),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Get.back(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoleChips() {
    // Builds the chips for each role, divided by category.

    // Define your categories and the roles that belong to them.  Replace with your actual categories and roles.
    final Map<String, List<UserRole>> roleCategories = {
      'Main Roles': [
        UserRole.student,
        UserRole.teacher,
        UserRole.departmentHead,
        UserRole.principal,
        UserRole.director,
        UserRole.schoolAdmin,
        UserRole.securityGuard,
        UserRole.maintenanceStaff,
        UserRole.driver,
      ],
      'Administrative': [
        UserRole.superAdmin,
        UserRole.admin,
        UserRole.schoolAdmin,
        UserRole.director,
        UserRole.schoolSecretary,
        UserRole.principal,
        UserRole.vicePrincipal,
        UserRole.departmentHead,
      ],
      'Teaching': [
        UserRole.teacher,
        UserRole.sportsCoach,
        UserRole.musicInstructor,
        UserRole.danceInstructor,
        UserRole.specialEducationTeacher,
      ],
      'Non-Teaching': [
        UserRole.guidanceCounselor,
        UserRole.librarian,
        UserRole.schoolNurse,
        UserRole.itSupport,
      ],
      'Support': [
        UserRole.maintenanceStaff,
        UserRole.driver,
        UserRole.securityGuard,
      ]
    };

    return SingleChildScrollView(
      // Important for handling long lists of categories and chips.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: roleCategories.entries.map((entry) {
          final category = entry.key;
          final rolesInCategory = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  category,
                  style: MyTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: rolesInCategory.map((role) {
                  final isSelected =
                      controller.selectedRoles.contains(role.name);
                  return FilterChip(
                    side: BorderSide(
                      width: 1,
                      color: isSelected
                          ? MyColors.activeBlue
                          : Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    label: Text(
                      role.name,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : MyColors.subtitleTextColor,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                        horizontal: MySizes.sm,
                        vertical: MySizes.sm - 4),
                    selectedColor: MyColors.activeBlue,
                    backgroundColor:
                        isSelected ? MyColors.activeBlue : Colors.grey[200],
                    selected: isSelected,
                    onSelected: (bool selected) {
                      List<String> newValues =
                          List.from(controller.selectedRoles);
                      if (selected) {
                        newValues.add(role.name);
                      } else {
                        newValues.remove(role.name);
                      }
                      controller.selectedRoles(newValues);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0), // Add spacing between categories
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpansionTileCustom({
    required String title,
    required List<Widget> children,
    bool leadingIsFilled = false,
    bool isValid = true, // New parameter to track validation state
    ValueChanged<bool>? onValidationChanged,
  }) {
    // Custom ExpansionTile with consistent styling
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(
          left: MySizes.md + 4,
          right: MySizes.md + 4,
          top: MySizes.sm,
          bottom: MySizes.lg),
      expansionAnimationStyle: AnimationStyle.noAnimation,
      shape: Border.all(
          color: isValid
              ? MyColors.activeBlue
              : Colors.red), // Change border color based on isValid
      leading: LabelChip(isFilled: leadingIsFilled),
      title: Text(title),
      children: children,
    );
  }

  List<Widget> _buildPersonalInformationFields() {
    // Personal Information Fields
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.fullNameController,
        validator: controller.requiredValidator.call,
      ),
      const SizedBox(height: MySizes.md),
      MyDatePickerField(
        labelText: 'Date of Birth',
        selectedDate: controller.dateOfBirth,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        onDateChanged: (DateTime? date) {
          if (date != null) {
            controller.dateOfBirth.value = date;
          }
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.genderOptions,
        labelText: 'Gender',
        onSelected: (value) {
          controller.gender.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.religionOptions,
        labelText: 'Religion',
        onSelected: (value) {
          controller.religion.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.categoryOptions,
        labelText: 'Category',
        onSelected: (value) {
          controller.category.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.phoneNoController,
        keyboardType: TextInputType.phone,
        validator: controller.requiredValidator.call,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Languages Spoken',
        options: const ['English', 'Spanish', 'French', 'Hindi'],
        onMultipleChanged: (values) {
          controller.languagesSpoken.value = values ?? [];
        },
        isMultipleSelection: true,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Hobbies',
        options: MyLists.hobbyOptions,
        onMultipleChanged: (values) {
          controller.hobbies.value = values ?? [];
        },
        isMultipleSelection: true,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Nationality',
        options: MyLists.nationalityOptions,
        onSingleChanged: (value) {
          controller.nationality.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.maritalStatusOptions,
        labelText: 'Martial Status',
        onSelected: (value) {
          controller.maritalStatus.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Profile Description',
        controller: controller.profileDescriptionController,
        maxLines: 3,
      ),
    ];
  }

  List<Widget> _buildPhysicalHealthInformationFields() {
    // Physical & Health Information Fields
    return [
      MyTextField(
        labelText: 'Height (cm)',
        controller: controller.heightController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Weight (kg)',
        controller: controller.weightController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.bloodGroupOptions,
        labelText: 'Blood group',
        onSelected: (value) {
          controller.bloodGroup.value = value ?? '';
        },
      ),

      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'Physical Disability',
        options: const ['Yes', 'No'],
        onSelected: (value) {
          controller.isPhysicalDisability.value = value == 'Yes';
        },
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildTransportationDetailsFields() {
    // Transportation Details Fields
    return [
      Obx(() => Column(
            children: [
              MyDropdownField(
                labelText: 'Mode of Transport',
                options: MyLists.modeOfTransportOptions,
                onSelected: (value) {
                  controller.modeOfTransport.value = value ?? '';
                },
              ),
              const SizedBox(height: MySizes.md),
              if (controller.modeOfTransport.value == 'School Transport') ...[
                MyTextField(
                  labelText: 'Transport Route Number',
                  controller: controller.transportRouteNumberController,
                  validator: controller.requiredValidator.call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Pickup Point',
                  controller: controller.transportPickupPointController,
                  validator: controller.requiredValidator.call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Drop Off Point',
                  controller: controller.transportDropOffPointController,
                  validator: controller.requiredValidator.call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Vehicle Number',
                  controller: controller.transportVehicleNumberController,
                  validator: controller.requiredValidator.call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Fare',
                  controller: controller.transportFareController,
                  keyboardType: TextInputType.number,
                  validator: MultiValidator([
                    controller.requiredValidator,
                    PatternValidator(r'^[0-9]*\.?[0-9]*$',
                        errorText: 'Enter a valid number'),
                  ]).call,
                ),
                const SizedBox(height: MySizes.md),
              ],
            ],
          ))
    ];
  }

  List<Widget> _buildAccountDetailsFields() {
    // Account Details Fields
    return [
      MyTextField(
        labelText: 'Username',
        controller: controller.usernameController,
        validator: controller.requiredValidator.call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email',
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: MultiValidator([
          controller.requiredValidator,
          EmailValidator(errorText: 'Enter a valid email address')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Password',
        controller: controller.passwordController,
        keyboardType: TextInputType.visiblePassword,
        validator: controller.requiredValidator.call,
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildFatherDetailsFields() {
    // Father's Details Fields
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.fatherFullNameController,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Relationship to Student',
        options: MyLists.relationshipOptions,
        onSingleChanged: (value) {
          controller.fatherRelationshipToStudent.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Occupation',
        onSelected:(value){ controller.fatherOccupation.value=value;},
        options: MyLists.occupations,

      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.fatherPhoneNumberController,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email Address',
        controller: controller.fatherEmailAddressController,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Highest Education Level',
        onSelected:(value){ controller.fatherHighestEducationLevel.value=value;},
        options: MyLists.educationDegreeOptions,
      ),

      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Annual Income',
        controller: controller.fatherAnnualIncomeController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildMotherDetailsFields() {
    // Mother's Details Fields
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.motherFullNameController,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'Relationship to Student',
        options: MyLists.relationshipOptions,
        onSelected: (value) {
          controller.motherRelationshipToStudent.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Occupation',
        onSelected:(value){ controller.motherOccupation.value=value;},
        options: MyLists.occupations,
      ),


      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.motherPhoneNumberController,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email Address',
        controller: controller.motherEmailAddressController,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Highest Education Level',
        onSelected:(value){ controller.motherHighestEducationLevel.value=value;},
        options: MyLists.educationDegreeOptions,
      ),

      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Annual Income',
        controller: controller.motherAnnualIncomeController,
        keyboardType: TextInputType.number,
      ),
    ];
  }

  List<Widget> _buildAddressDetailsFields() {
    return [
      const Text(
        "Permanent Address",
        style: TextStyle(
            color: MyColors.headlineTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: MySizes.sm + 4),
      MyTextField(
        labelText: 'House Address',
        controller: controller.permanentHouseAddressController,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'City',
        controller: controller.permanentCityController,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'District',
        onSelected:(value){ controller.permanentDistrict.value=value;},
        options: MyLists.educationDegreeOptions,
      ),

      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'State',
        onSelected:(value){ controller.permanentState.value=value!;},
        options: MyLists.indianStateOptions,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Village',
        controller: controller.permanentVillageController,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Pin Code',
        controller: controller.permanentPinCodeController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: MySizes.md + 4),
      Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Address",
                style: TextStyle(
                    color: MyColors.headlineTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [

                  Checkbox(
                    value: controller.isSameAsPermanent.value,
                    onChanged: (value) {
                      controller.isSameAsPermanent.value = value!;
                      if (value) {
                        controller.currentHouseAddressController.text =
                            controller.permanentHouseAddressController.text;
                        controller.currentCityController.text =
                            controller.permanentCityController.text;
                        controller.currentDistrict.value=
                            controller.permanentDistrict.value;
                        controller.currentState.value =
                            controller.permanentState.value;
                        controller.currentVillageController.text =
                            controller.permanentVillageController.text;
                        controller.currentPinCodeController.text =
                            controller.permanentPinCodeController.text;
                      } else {
                        controller.currentHouseAddressController.clear();
                        controller.currentCityController.clear();
                        controller.currentDistrict.value='';
                        controller.currentState.value='';
                        controller.currentVillageController.clear();
                        controller.currentPinCodeController.clear();
                      }
                    },
                  ),
                  const Text(
                    "Same as Permanent Address",
                    style: TextStyle(
                        color: MyColors.headlineTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              if (!controller.isSameAsPermanent.value)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    MyTextField(
                      labelText: 'House Address',
                      controller: controller.currentHouseAddressController,
                    ),
                    const SizedBox(height: MySizes.md),
                    MyTextField(
                      labelText: 'City',
                      controller: controller.currentCityController,
                    ),
                    const SizedBox(height: MySizes.md),
                    MySearchableDropdown(
                      labelText: 'District',
                      onSelected:(value){ controller.currentDistrict.value=value;},
                      options: MyLists.indianStateOptions,
                    ),

                    const SizedBox(height: MySizes.md),
                    MyDropdownField(
                      labelText: 'State',
                      onSelected:(value){ controller.currentState.value=value!;},
                      options: MyLists.indianStateOptions,
                    ),
                    const SizedBox(height: MySizes.md),
                    MyTextField(
                      labelText: 'Village',
                      controller: controller.currentVillageController,
                    ),
                    const SizedBox(height: MySizes.md),
                    MyTextField(
                      labelText: 'Pin Code',
                      controller: controller.currentPinCodeController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
            ],
          )),
    ];
  }

  List<Widget> _buildEmergencyContactFields() {
    // Emergency Contact Fields
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.emergencyFullNameController,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'Relationship',
        options: MyLists.relationshipOptions,
        onSelected: (value) {
          controller.emergencyRelationshipController.text = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.emergencyPhoneNumberController,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email Address',
        controller: controller.emergencyEmailAddressController,
        keyboardType: TextInputType.emailAddress,
      ),
    ];
  }

  List<Widget> _buildFavoritesFields() {
    return [
      MyDialogDropdown(
        labelText: 'Favorite Dish',
        options: MyLists.dishOptions, // Use SchoolList
        onSingleChanged: (value) => controller.favoriteDish.value = value!,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Favorite Subject',
        options: MyLists.subjectOptions,
        onSingleChanged: (value) =>
            controller.favoriteSubject.value = value ?? '',
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Teacher',
        options: MyLists.teacherOptions,
        onSelected: (value) => controller.favoriteTeacher.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Book',
        options: MyLists.bookOptions,
        onSelected: (value) => controller.favoriteBook.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Favorite Sport',
        options: MyLists.favoriteSportOptions,
        onSingleChanged: (value) =>
            controller.favoriteSport.value = value ?? '',
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Athlete',
        options: MyLists.athleteOptions,
        onSelected: (value) => controller.favoriteAthlete.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Movie',
        options: MyLists.movieOptions,
        onSelected: (value) => controller.favoriteMovie.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Cuisine',
        options: MyLists.cuisineOptions,
        onSelected: (value) => controller.favoriteCuisine.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Singer',
        options: MyLists.singerOptions,
        onSelected: (value) => controller.favoriteSinger.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Place to Visit',
        options: MyLists.placeToVisitOptions,
        onSelected: (value) => controller.favoritePlaceToVisit.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Festival',
        options: MyLists.festivalOptions,
        onSelected: (value) => controller.favoriteFestival.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Personality',
        options: MyLists.personalityOptions,
        onSelected: (value) => controller.favoritePersonality.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Favorite Season',
        options: MyLists.seasonOptions,
        onSingleChanged: (value) =>
            controller.favoriteSeason.value = value ?? '',
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Animal',
        options: MyLists.animalOptions,
        onSelected: (value) => controller.favoriteAnimal.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Favorite Quote',
        onChanged: (value) => controller.favoriteQuote.value = value,
      ),
    ];
  }

  Widget _buildRoleSpecificDetails() {
    // Builds role-specific sections based on selected roles
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.selectedRoles.contains(UserRole.student.name))
              _buildExpansionTileCustom(
                  title: 'Student Details', children: _buildStudentDetails()),
            if (controller.selectedRoles.contains(UserRole.teacher.name))
              _buildExpansionTileCustom(
                  title: 'Teacher Details', children: _buildTeacherDetails()),
            if (controller.selectedRoles.contains(UserRole.driver.name))
              _buildExpansionTileCustom(
                  title: 'Driver Details', children: _buildDriverDetails()),
            if (controller.selectedRoles.contains(UserRole.securityGuard.name))
              _buildExpansionTileCustom(
                  title: 'Security Guard Details',
                  children: _buildSecurityGuardDetails()),
            if (controller.selectedRoles
                .contains(UserRole.maintenanceStaff.name))
              _buildExpansionTileCustom(
                  title: 'Maintenance Staff Details',
                  children: _buildMaintenanceStaffDetails()),
            if (controller.selectedRoles.contains(UserRole.admin.name))
              _buildExpansionTileCustom(
                  title: 'Admin Details', children: _buildAdminDetails()),
            if (controller.selectedRoles.contains(UserRole.schoolAdmin.name))
              _buildExpansionTileCustom(
                  title: 'School Admin Details',
                  children: _buildSchoolAdminDetails()),
            if (controller.selectedRoles.contains(UserRole.director.name))
              _buildExpansionTileCustom(
                  title: 'Director Details', children: _buildDirectorDetails()),
            if (controller.selectedRoles.contains(UserRole.departmentHead.name))
              _buildExpansionTileCustom(
                  title: 'Department Head Details',
                  children: _buildDepartmentHeadDetails())
          ],
        ));
  }

  List<Widget> _buildStudentDetails() {
    return [
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Roll Number',
        controller: controller.rollNumberController,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Admission Number',
        controller: controller.admissionNoController,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Class',
        options: MyLists.classOptions,
        onSingleChanged: (value) {
          controller.className.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'Section',
        options: MyLists.sectionOptions,
        onSingleChanged: (value) {
          controller.section.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
        labelText: 'House',
        options: MyLists.schoolHouseOptions,
        onSingleChanged: (value) {
          controller.house.value = value ?? '';
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDatePickerField(
        labelText: 'Admission Date',
        selectedDate: controller.admissionDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        onDateChanged: (DateTime? date) {
          if (date != null) {
            controller.admissionDate.value = date;
          }
        },
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Previous School Name',
        controller: controller.previousSchoolNameController,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Ambition',
        controller: controller.ambitionController,
      ),
      const SizedBox(height: MySizes.lg),
      Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Guardian',
                style: MyTextStyles.titleLarge,
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "Father",
                    groupValue: controller.selectedGuardian.value,
                    onChanged: (value) {
                      controller.selectedGuardian.value = value;
                    },
                  ),
                  const Text(
                    "Father",
                    style: TextStyle(
                        color: MyColors.subtitleTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "Mother",
                    groupValue: controller.selectedGuardian.value,
                    onChanged: (value) {
                      controller.selectedGuardian.value = value;
                    },
                  ),
                  const Text(
                    "Mother",
                    style: TextStyle(
                        color: MyColors.subtitleTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "Other",
                    groupValue: controller.selectedGuardian.value,
                    onChanged: (value) {
                      controller.selectedGuardian.value = value;
                    },
                  ),
                  const Text(
                    "Other Guardian (Relative/Legal Guardian)",
                    style: TextStyle(
                        color: MyColors.subtitleTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          )),
      const SizedBox(height: MySizes.md),
      Obx(() {
        if (controller.selectedGuardian.value == "Other") {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Guardian Details',
                style: MyTextStyles.titleLarge,
              ),
              const SizedBox(
                height: MySizes.md,
              ),
              MyTextField(
                labelText: 'Full Name',
                controller: controller.guardianFullNameController,
              ),
              const SizedBox(height: MySizes.md),
              MyDialogDropdown(
                labelText: 'Relationship to Student',
                options: MyLists.relationshipOptions,
                onSingleChanged: (value) {
                  controller.guardianRelationshipToStudent.value = value ?? '';
                },
              ),
              const SizedBox(height: MySizes.md),
              MyDialogDropdown(
                labelText: 'Occupation',
                options: MyLists.occupations,
                onSingleChanged: (value) {
                  controller.guardianOccupation.value = value ?? '';
                },
              ),
              const SizedBox(height: MySizes.md),
              MyTextField(
                labelText: 'Phone Number',
                controller: controller.motherPhoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: MySizes.md),
              MyTextField(
                labelText: 'Email Address',
                controller: controller.motherEmailAddressController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: MySizes.md),
              MyDropdownField(
                labelText: 'Highest Education Level',
                selectedValue: controller.guardianHighestEducationLevel,
                options: MyLists.educationDegreeOptions,
                onSelected: (value) {
                  controller.guardianHighestEducationLevel.value = value!;
                },
              ),
              const SizedBox(height: MySizes.md),
              MyTextField(
                labelText: 'Annual Income',
                controller: controller.motherAnnualIncomeController,
                keyboardType: TextInputType.number,
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    ];
  }

  List<Widget> _buildTeacherDetails() {
    return [
      MyDialogDropdown(
          labelText: 'Subjects Taught',
          options: const ['Mathematics', 'Science', 'English', 'History'],
          onMultipleChanged: (values) {
            controller.subjectsTaught.value = values ?? [];
          },
          isMultipleSelection: true),
      const SizedBox(height: MySizes.md),
      MyDatePickerField(
        labelText: 'Joining Date',
        selectedDate: controller.joiningDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        onDateChanged: (DateTime? date) {
          if (date != null) {
            controller.joiningDate.value = date;
          }
        },
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Experience',
        controller: controller.experienceController,
      ),
    ];
  }

  List<Widget> _buildDriverDetails() {
    return [
      MyTextField(
        labelText: 'License Number',
        controller: controller.licenseNumberController,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
          labelText: 'Routes Assigned',
          options: const ['Route A', 'Route B', 'Route C', 'Route D'],
          onMultipleChanged: (values) {
            controller.routesAssigned.value = values ?? [];
          },
          isMultipleSelection: true),
    ];
  }

  List<Widget> _buildQualificationDetails() {
    return [
      ...controller.qualifications.map((qualification) => QualificationWidget(
            qualification: qualification,
            onEdit: () => controller.editQualification(qualification),
            onDelete: () => controller.deleteQualification(qualification),
          )),
      TextButton(
        onPressed: () {
          controller.showAddQualificationDialog(Get.context!);
        },
        child: const Text('+ Add Qualification'),
      )
    ];
  }

  List<Widget> _buildSecurityGuardDetails() {
    return [
      MyTextField(
        labelText: 'Assigned Area',
        controller: controller.assignedAreaController,
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildMaintenanceStaffDetails() {
    return [
      MyDialogDropdown(
          labelText: 'Responsibilities',
          options: const ['Cleaning', 'Repairing', 'Gardening', 'Plumbing'],
          onMultipleChanged: (values) {
            controller.maintenanceResponsibilities.value = values ?? [];
          },
          isMultipleSelection: true),
    ];
  }

  List<Widget> _buildAdminDetails() {
    return [
      MyDialogDropdown(
          labelText: 'Permissions',
          options: const [
            'Create Users',
            'Edit Users',
            'Delete Users',
            'View Users'
          ],
          onMultipleChanged: (values) {
            controller.adminPermissions.value = values ?? [];
          },
          isMultipleSelection: true),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
          labelText: 'Assigned Modules',
          options: const [
            'User Management',
            'School Management',
            'Finance Management',
            'Attendance Management'
          ],
          onMultipleChanged: (values) {
            controller.assignedModules.value = values ?? [];
          },
          isMultipleSelection: true),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
          labelText: 'Manageable Schools',
          options: const ['School A', 'School B', 'School C', 'School D'],
          onMultipleChanged: (values) {
            controller.manageableSchools.value = values ?? [];
          },
          isMultipleSelection: true),
    ];
  }

  List<Widget> _buildSchoolAdminDetails() {
    return [
      MyDialogDropdown(
          labelText: 'Permissions',
          options: const ['Create Users', 'Edit Users', 'View Users'],
          onMultipleChanged: (values) {
            controller.schoolAdminPermissions.value = values ?? [];
          },
          isMultipleSelection: true),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
          labelText: 'Assigned Modules',
          options: const ['User Management', 'Attendance Management'],
          onMultipleChanged: (values) {
            controller.schoolAdminAssignedModules.value = values ?? [];
          },
          isMultipleSelection: true),
    ];
  }

  List<Widget> _buildDirectorDetails() {
    return [
      MyDialogDropdown(
          labelText: 'Schools',
          options: const ['School A', 'School B', 'School C'],
          onMultipleChanged: (values) {
            controller.directorSchools.value = values ?? [];
          },
          isMultipleSelection: true),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Years In Management',
        controller: controller.yearsInManagementController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
          labelText: 'Permissions',
          options: const [
            'Create Schools',
            'Edit Schools',
            'Delete Schools',
            'View Schools'
          ],
          onMultipleChanged: (values) {
            controller.directorPermissions.value = values ?? [];
          },
          isMultipleSelection: true),
    ];
  }

  List<Widget> _buildDepartmentHeadDetails() {
    return [
      MyTextField(
        labelText: 'Department',
        controller: controller.departmentController,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Years As Head',
        controller: controller.yearsAsHeadController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: MySizes.md),
      MyDialogDropdown(
          labelText: 'Responsibilities',
          options: const [
            'Curriculum Design',
            'Teacher Evaluation',
            'Student Mentoring'
          ],
          onMultipleChanged: (values) {
            controller.departmentResponsibilities.value = values ?? [];
          },
          isMultipleSelection: true),
    ];
  }

  // Validation methods
  bool _validatePersonalInformationFields() {
    return controller.fullNameController.text.isNotEmpty &&
        controller.phoneNoController.text
            .isNotEmpty; // Add more validations as needed
  }

  bool _validateLoginInformationFields() {
    return controller.usernameController.text.isNotEmpty &&
        controller
            .emailController.text.isNotEmpty; // Add more validations as needed
  }
}

class LabelChip extends StatelessWidget {
  final bool isFilled;
  const LabelChip({super.key, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFilled ? Icons.check : Icons.error,
      color: isFilled ? MyColors.activeGreen : MyColors.activeOrange,
      size: 24,
    );
  }
}
