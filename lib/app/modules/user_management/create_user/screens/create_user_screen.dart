import 'package:cambridge_school/app/modules/user_management/create_user/controllers/create_user_controller.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/gender.dart';
import 'package:cambridge_school/core/utils/constants/enums/subject.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/searchable_dropdown.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/enums/class_name.dart';
import '../../../../../core/utils/constants/enums/martial_status.dart';
import '../../../../../core/utils/constants/text_styles.dart';
import '../../../../../roles_manager.dart';
import '../widgets/qualification_widget.dart';

final CreateUserController controller = Get.find<CreateUserController>();

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  String? _currentExpandedTile;

  final ExpansionTileController _personalInfoController =
      ExpansionTileController();
  final ExpansionTileController _healthInfoController =
      ExpansionTileController();
  final ExpansionTileController _fatherDetailsController =
      ExpansionTileController();
  final ExpansionTileController _motherDetailsController =
      ExpansionTileController();
  final ExpansionTileController _addressDetailsController =
      ExpansionTileController();
  final ExpansionTileController _emergencyContactController =
      ExpansionTileController();
  final ExpansionTileController _qualificationDetailsController =
      ExpansionTileController();
  final ExpansionTileController _transportDetailsController =
      ExpansionTileController();
  final ExpansionTileController _accountDetailsController =
      ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MySizes.md),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRolesSection(context),
              Obx(() => _buildExpansionTileCustom(
                    controller: _personalInfoController,
                    title: 'Personal Information',
                    isValid: controller.personalInfoValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Personal Information');
                    },
                    children: _buildPersonalInformationFields(),
                  )),
              Obx(() => _buildExpansionTileCustom(
                    controller: _healthInfoController,
                    title: 'Health & Medical Information',
                    isValid: controller.physicalHealthValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(
                          expanded, 'Health & Medical Information');
                    },
                    children: _buildPhysicalHealthInformationFields(),
                  )),
              Obx(() => _buildExpansionTileCustom(
                    controller: _fatherDetailsController,
                    title: 'Father’s Details',
                    isValid: controller.fatherDetailsValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Father’s Details');
                    },
                    children: _buildFatherDetailsFields(),
                  )),
              Obx(() => _buildExpansionTileCustom(
                    controller: _motherDetailsController,
                    title: 'Mother’s Details',
                    isValid: controller.motherDetailsValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Mother’s Details');
                    },
                    children: _buildMotherDetailsFields(),
                  )),
              Obx(() => _buildExpansionTileCustom(
                    controller: _addressDetailsController,
                    title: 'Residential Address',
                    isValid: controller.addressDetailsValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Residential Address');
                    },
                    children: _buildAddressDetailsFields(),
                  )),
              Obx(() => _buildExpansionTileCustom(
                    controller: _emergencyContactController,
                    title: 'Emergency Contact Details',
                    isValid: controller.emergencyContactValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Emergency Contact Details');
                    },
                    children: _buildEmergencyContactFields(),
                  )),
              Obx(() {
                if (!controller.selectedRoles.contains(UserRole.student) &&
                    controller.selectedRoles.isNotEmpty) {
                  return _buildExpansionTileCustom(
                    controller: _qualificationDetailsController,
                    title: 'Educational Qualifications',
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Educational Qualifications');
                    },
                    children: _buildQualificationDetails(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              _buildRoleSpecificDetails(),
              Obx(() => _buildExpansionTileCustom(
                    controller: _transportDetailsController,
                    title: 'Transport Details',
                    isValid: controller.transportDetailsValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Transport Details');
                    },
                    children: _buildTransportationDetailsFields(),
                  )),
              _buildExpansionTileCustom(
                title: 'Personal Interests',
                children: _buildFavoritesFields(),
              ),
              Obx(() => _buildExpansionTileCustom(
                    controller: _accountDetailsController,
                    title: 'Login & Account Information',
                    isValid: controller.loginInfoValid.value,
                    onExpansionChanged: (expanded) {
                      _handleExpansion(expanded, 'Login & Account Information');
                    },
                    children: _buildAccountDetailsFields(),
                  )),
              const SizedBox(height: MySizes.md),
              MyButton(
                text: 'Create User',
                onPressed: () {
                  controller.addUserToFirestore();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleExpansion(bool expanded, String tileId) {
    setState(() {
      if (expanded) {
        _currentExpandedTile = tileId;
        if (tileId != 'Personal Information') {
          _personalInfoController.collapse();
        }
        if (tileId != 'Health & Medical Information') {
          _healthInfoController.collapse();
        }
        if (tileId != 'Father’s Details') {
          _fatherDetailsController.collapse();
        }
        if (tileId != 'Mother’s Details') {
          _motherDetailsController.collapse();
        }
        if (tileId != 'Residential Address') {
          _addressDetailsController.collapse();
        }
        if (tileId != 'Emergency Contact Details') {
          _emergencyContactController.collapse();
        }
        if (tileId != 'Educational Qualifications' &&
            !controller.selectedRoles.contains(UserRole.student) &&
            controller.selectedRoles.isNotEmpty) {
          _qualificationDetailsController.collapse();
        }
        if (tileId != 'Transport Details') {
          _transportDetailsController.collapse();
        }
        if (tileId != 'Login & Account Information') {
          _accountDetailsController.collapse();
        }
      } else {
        if (_currentExpandedTile == tileId) {
          _currentExpandedTile = null;
        }
      }
    });
  }

  Widget _buildRolesSection(BuildContext context) {
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
                  showSelectRolesDialog(
                      context); //Use controller.selectedRoles here
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
                  ...controller.selectedRoles.map((role) => Chip(
                        label: Text(
                          role.value, // Change here
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                        backgroundColor: MyColors.activeBlue,
                        onDeleted: () {
                          controller.selectedRoles.remove(role);
                        },
                        deleteIconColor: Colors.white,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        padding: EdgeInsets.zero,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        deleteButtonTooltipMessage: 'Remove this role',
                        side: BorderSide.none,
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> showSelectRolesDialog(BuildContext context) async {
    List<String> roleCategories = UserRole.values
        .map((role) => role.category)
        .toSet()
        .toList(); // Convert back to a list
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Roles', style: MyTextStyle.headlineSmall),
          content: SizedBox(
            width: double.maxFinite,
            height: Get.height * .75,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: roleCategories.length,
              itemBuilder: (context, categoryIndex) {
                final category = roleCategories[categoryIndex];
                final rolesInCategory = UserRole.values
                    .where((role) => role.category == category)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: MySizes.md), // Add some padding
                      child: Text(
                        category,
                        style: MyTextStyle.headlineSmall.copyWith(fontSize: 18),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rolesInCategory.length,
                      itemBuilder: (context, index) {
                        final role = rolesInCategory[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: MySizes.md,
                          ),
                          child: Obx(() => _buildRoleCard(
                                role: role.value,
                                description: role.description,
                                isSelected: controller.isRoleSelected(role),
                                assetPath: controller.getAssetPath(role),
                                onTap: () =>
                                    controller.toggleRoleSelection(role),
                              )),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpansionTileCustom({
    required String title,
    required List<Widget> children,
    bool? isValid,
    ExpansionTileController? controller,
    ValueChanged<bool>? onExpansionChanged,
  }) {
    Color color;
    if (isValid == null) {
      color = MyColors.activeOrange;
    } else if (isValid) {
      color = MyColors.activeGreen;
    } else {
      color = MyColors.activeRed;
    }

    return ExpansionTile(
      controller: controller,
      onExpansionChanged: onExpansionChanged,
      childrenPadding: const EdgeInsets.only(
          left: MySizes.md + 4,
          right: MySizes.md + 4,
          top: MySizes.sm,
          bottom: MySizes.lg),
      expansionAnimationStyle: AnimationStyle.noAnimation,
      shape: Border.all(color: color),
      leading: Icon(
        isValid == null
            ? Icons.error
            : isValid
                ? Icons.check_circle
                : Icons.close_rounded,
        color: isValid == null
            ? MyColors.activeOrange
            : isValid
                ? MyColors.activeGreen
                : MyColors.activeRed,
        size: 24,
      ),
      title: Text(title),
      children: children,
    );
  }

  List<Widget> _buildPersonalInformationFields() {
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.fullNameController,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Full Name is required'),
          MinLengthValidator(3,
              errorText: 'Full Name must be at least 3 characters long')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyDatePickerField(
        labelText: 'Date of Birth',
        selectedDate: controller.dateOfBirth,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        onDateChanged: (DateTime? date) {
          if (date != null) {
            controller.dateOfBirth.value = date;
          }
        },
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: Gender.labels,
        labelText: 'Gender',
        selectedValue: controller.gender,
        onSelected: (value) {
          controller.gender.value = value ?? '';
        },
        isValidate: true,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.religionOptions,
        labelText: 'Religion',
        selectedValue: controller.religion,
        onSelected: (value) {
          controller.religion.value = value ?? '';
        },
        isValidate: true,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.categoryOptions,
        labelText: 'Category',
        selectedValue: controller.category,
        onSelected: (value) {
          controller.category.value = value ?? '';
        },
        hintText: 'Ass',
        isValidate: true,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.phoneNoController,
        keyboardType: TextInputType.phone,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Phone Number is required'),
          PatternValidator(r'^[0-9]+$',
              errorText: 'Phone Number must contain only digits'),
          MinLengthValidator(10,
              errorText: 'Phone Number must be at least 10 digits long'),
          MaxLengthValidator(15,
              errorText: 'Phone Number cannot exceed 15 digits')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Languages Spoken',
        optionsForChips: const ['English', 'Spanish', 'French', 'Hindi'],
        onMultipleChanged: (values) {
          controller.languagesSpoken.value = values ?? [];
        },
        isValid: controller.languagesSpoken.isNotEmpty,
        isMultipleSelection: true,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Hobbies',
        optionsForChips: MyLists.hobbyOptions,
        onMultipleChanged: (values) {
          controller.hobbies.value = values ?? [];
        },
        isMultipleSelection: true,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Nationality',
        optionsForChips: MyLists.nationalityOptions,
        onSingleChanged: (value) {
          controller.nationality.value = value;
        },
        isValid: true,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MaritalStatus.labels,
        labelText: 'Marital Status',
        selectedValue: controller.maritalStatus,
        onSelected: (value) {
          controller.maritalStatus.value = value ?? '';
        },
        isValidate: true,
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
    return [
      MyTextField(
        labelText: 'Height (cm)',
        controller: controller.heightController,
        keyboardType: TextInputType.number,
        validator: PatternValidator(r'^[0-9.]*$',
                errorText: 'Height must be a valid number')
            .call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Weight (kg)',
        controller: controller.weightController,
        keyboardType: TextInputType.number,
        validator: PatternValidator(r'^[0-9.]*$',
                errorText: 'Weight must be a valid number')
            .call,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        options: MyLists.bloodGroupOptions,
        labelText: 'Blood group',
        selectedValue: controller.bloodGroup,
        onSelected: (value) {
          controller.bloodGroup.value = value ?? '';
        },
        isValidate: false, // Make it optional
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'Physical Disability',
        options: const ['Yes', 'No'],
        onSelected: (value) {
          controller.isPhysicalDisability.value = value == 'Yes';
        },
        selectedValue:
            controller.isPhysicalDisability.value ? 'Yes'.obs : 'No'.obs,
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildTransportationDetailsFields() {
    return [
      Obx(() => Column(
            children: [
              MyDropdownField(
                labelText: 'Mode of Transport',
                options: MyLists.modeOfTransportOptions,
                selectedValue: controller.modeOfTransport,
                onSelected: (value) {
                  controller.modeOfTransport.value = value ?? '';
                },
                isValidate: true,
              ),
              const SizedBox(height: MySizes.md),
              if (controller.modeOfTransport.value == 'School Transport') ...[
                MyTextField(
                  labelText: 'Transport Route Number',
                  controller: controller.transportRouteNumberController,
                  validator: RequiredValidator(
                          errorText: 'Transport Route Number is required')
                      .call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Pickup Point',
                  controller: controller.transportPickupPointController,
                  validator: RequiredValidator(
                          errorText: 'Transport Pickup Point is required')
                      .call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Drop Off Point',
                  controller: controller.transportDropOffPointController,
                  validator: RequiredValidator(
                          errorText: 'Transport Drop Off Point is required')
                      .call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Vehicle Number',
                  controller: controller.transportVehicleNumberController,
                  validator: RequiredValidator(
                          errorText: 'Transport Vehicle Number is required')
                      .call,
                ),
                const SizedBox(height: MySizes.md),
                MyTextField(
                  labelText: 'Transport Fare',
                  controller: controller.transportFareController,
                  keyboardType: TextInputType.number,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Transport Fare is required'),
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
    return [
      MyTextField(
        labelText: 'Username',
        controller: controller.usernameController,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Username is required'),
          MinLengthValidator(6,
              errorText: 'Username must be at least 6 characters long')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email',
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Email is required'),
          EmailValidator(errorText: 'Enter a valid email address')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Password',
        controller: controller.passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Password is required'),
          MinLengthValidator(8,
              errorText: 'Password must be at least 8 characters long'),
          PatternValidator(r'^(?=.*[A-Z])(?=.*[!@#\$&*~])(?=.*[0-9]).*$',
              errorText:
                  'Password must contain at least one uppercase letter, one number, and one special character')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildFatherDetailsFields() {
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.fatherFullNameController,
        validator:
            RequiredValidator(errorText: 'Father\'s Full Name is required')
                .call,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Relationship to Student',
        optionsForChips: MyLists.relationshipOptions,
        onSingleChanged: (value) {
          controller.fatherRelationshipToStudent.value = value;
        },
        isValid: true,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Occupation',
        options: MyLists.occupations,
        onSelected: (value) {
          controller.fatherOccupation.value = value;
        },
        isValidate: true,
        hintText: "Please select Occupation",
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.fatherPhoneNumberController,
        keyboardType: TextInputType.phone,
        validator: PatternValidator(r'^[0-9]+$',
                errorText: 'Phone Number must contain only digits')
            .call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email Address',
        controller: controller.fatherEmailAddressController,
        keyboardType: TextInputType.emailAddress,
        validator:
            EmailValidator(errorText: 'Enter a valid email address').call,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Highest Education Level',
        options: MyLists.educationDegreeOptions,
        onSelected: (value) {
          controller.fatherHighestEducationLevel.value = value;
        },
        isValidate: true,
        hintText: "Please select Highest Education Level",
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Annual Income',
        controller: controller.fatherAnnualIncomeController,
        keyboardType: TextInputType.number,
        validator: PatternValidator(r'^[0-9.]*$',
                errorText: 'Annual Income must be a valid number')
            .call,
      ),
    ];
  }

  List<Widget> _buildMotherDetailsFields() {
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.motherFullNameController,
        validator:
            RequiredValidator(errorText: 'Mother\'s Full Name is required')
                .call,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'Relationship to Student',
        options: MyLists.relationshipOptions,
        selectedValue: controller.motherRelationshipToStudent,
        onSelected: (value) {
          controller.motherRelationshipToStudent.value = value ?? '';
        },
        isValidate: true,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Occupation',
        options: MyLists.occupations,
        onSelected: (value) {
          controller.motherOccupation.value = value;
        },
        isValidate: true,
        hintText: "Please select Occupation",
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.motherPhoneNumberController,
        keyboardType: TextInputType.phone,
        validator: PatternValidator(r'^[0-9]+$',
                errorText: 'Phone Number must contain only digits')
            .call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email Address',
        controller: controller.motherEmailAddressController,
        keyboardType: TextInputType.emailAddress,
        validator:
            EmailValidator(errorText: 'Enter a valid email address').call,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Highest Education Level',
        options: MyLists.educationDegreeOptions,
        onSelected: (value) {
          controller.motherHighestEducationLevel.value = value;
        },
        isValidate: true,
        hintText: "Please select Highest Education Level",
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Annual Income',
        controller: controller.motherAnnualIncomeController,
        keyboardType: TextInputType.number,
        validator: PatternValidator(r'^[0-9.]*$',
                errorText: 'Annual Income must be a valid number')
            .call,
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
        validator:
            RequiredValidator(errorText: 'House Address is required').call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'City',
        controller: controller.permanentCityController,
        validator: RequiredValidator(errorText: 'City is required').call,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'District',
        options: MyLists.indianStateOptions,
        onSelected: (value) {
          controller.permanentDistrict.value = value;
        },
        isValidate: true,
        hintText: "Please select District",
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
        labelText: 'State',
        selectedValue: controller.permanentState,
        onSelected: (value) {
          controller.permanentState.value = value ?? '';
        },
        options: MyLists.indianStateOptions,
        isValidate: true,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Village',
        controller: controller.permanentVillageController,
        validator: RequiredValidator(errorText: 'Village is required').call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Pin Code',
        controller: controller.permanentPinCodeController,
        keyboardType: TextInputType.number,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Pin Code is required'),
          PatternValidator(r'^[0-9]+$',
              errorText: 'Pin Code must contain only digits'),
          LengthRangeValidator(
              errorText: 'Pin Code must be 6 digits long', min: 6, max: 6)
        ]).call,
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
                        controller.currentDistrict.value =
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
                        controller.currentDistrict.value = '';
                        controller.currentState.value = '';
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
                      validator: RequiredValidator(
                              errorText: 'House Address is required')
                          .call,
                    ),
                    const SizedBox(height: MySizes.md),
                    MyTextField(
                      labelText: 'City',
                      controller: controller.currentCityController,
                      validator:
                          RequiredValidator(errorText: 'City is required').call,
                    ),
                    const SizedBox(height: MySizes.md),
                    MySearchableDropdown(
                      labelText: 'District',
                      options: MyLists.indianStateOptions,
                      onSelected: (value) {
                        controller.currentDistrict.value = value;
                      },
                      isValidate: true,
                      hintText: "Please select District",
                    ),
                    const SizedBox(height: MySizes.md),
                    MyDropdownField(
                      labelText: 'State',
                      options: MyLists.indianStateOptions,
                      selectedValue: controller.currentState,
                      onSelected: (value) {
                        controller.currentState.value = value ?? '';
                      },
                      isValidate: true,
                    ),
                    const SizedBox(height: MySizes.md),
                    MyTextField(
                      labelText: 'Village',
                      controller: controller.currentVillageController,
                      validator:
                          RequiredValidator(errorText: 'Village is required')
                              .call,
                    ),
                    const SizedBox(height: MySizes.md),
                    MyTextField(
                      labelText: 'Pin Code',
                      controller: controller.currentPinCodeController,
                      keyboardType: TextInputType.number,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Pin Code is required'),
                        PatternValidator(r'^[0-9]+$',
                            errorText: 'Pin Code must contain only digits'),
                        LengthRangeValidator(
                            errorText: 'Pin Code must be 6 digits long',
                            min: 6,
                            max: 6)
                      ]).call,
                    )
                  ],
                ),
            ],
          )),
    ];
  }

  List<Widget> _buildEmergencyContactFields() {
    return [
      MyTextField(
        labelText: 'Full Name',
        controller: controller.emergencyFullNameController,
        validator: RequiredValidator(errorText: 'Full Name is required').call,
      ),
      const SizedBox(height: MySizes.md),
      MyDropdownField(
          labelText: 'Relationship',
          options: MyLists.relationshipOptions,
          selectedValue: controller.emergencyRelationship,
          onSelected: (value) {
            controller.emergencyRelationship.value = value ?? '';
          },
          isValidate: true),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Phone Number',
        controller: controller.emergencyPhoneNumberController,
        keyboardType: TextInputType.phone,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Phone Number is required'),
          PatternValidator(r'^[0-9]+$',
              errorText: 'Phone Number must contain only digits')
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Email Address',
        controller: controller.emergencyEmailAddressController,
        keyboardType: TextInputType.emailAddress,
        validator:
            EmailValidator(errorText: 'Enter a valid email address').call,
      ),
    ];
  }

  List<Widget> _buildFavoritesFields() {
    return [
      MyBottomSheetDropdown(
        labelText: 'Favorite Dish',
        optionsForChips: MyLists.dishOptions,
        onSingleChanged: (value) => controller.favoriteDish.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Favorite Subject',
        optionsForChips: SubjectName.labelsList,
        onSingleChanged: (value) =>
            controller.favoriteSubject.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Teacher',
        options: MyLists.teacherOptions,
        onSelected: (value) => controller.favoriteTeacher.value = value,
        hintText: "Select Favourite Teacher",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Book',
        options: MyLists.bookOptions,
        onSelected: (value) => controller.favoriteBook.value = value,
        hintText: "Select Favourite Book",
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Favorite Sport',
        optionsForChips: MyLists.favoriteSportOptions,
        onSingleChanged: (value) =>
            controller.favoriteSport.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Athlete',
        options: MyLists.athleteOptions,
        onSelected: (value) => controller.favoriteAthlete.value = value,
        hintText: "Select Favourite Athlete",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Movie',
        options: MyLists.movieOptions,
        onSelected: (value) => controller.favoriteMovie.value = value,
        hintText: "Select Favourite Movie",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Cuisine',
        options: MyLists.cuisineOptions,
        onSelected: (value) => controller.favoriteCuisine.value = value,
        hintText: "Select Favourite Cuisine",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Singer',
        options: MyLists.singerOptions,
        onSelected: (value) => controller.favoriteSinger.value = value,
        hintText: "Select Favourite Singer",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Place to Visit',
        options: MyLists.placeToVisitOptions,
        onSelected: (value) => controller.favoritePlaceToVisit.value = value,
        hintText: "Select Favourite Place to Visit",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Festival',
        options: MyLists.festivalOptions,
        onSelected: (value) => controller.favoriteFestival.value = value,
        hintText: "Select Favourite Festival",
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Personality',
        options: MyLists.personalityOptions,
        onSelected: (value) => controller.favoritePersonality.value = value,
        hintText: "Select Favourite Personality",
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Favorite Season',
        optionsForChips: MyLists.seasonOptions,
        onSingleChanged: (value) =>
            controller.favoriteSeason.value = value,
      ),
      const SizedBox(height: MySizes.md),
      MySearchableDropdown(
        labelText: 'Favorite Animal',
        options: MyLists.animalOptions,
        onSelected: (value) => controller.favoriteAnimal.value = value,
        hintText: "Select Favourite Animal",
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Favorite Quote',
        onChanged: (value) => controller.favoriteQuote.value = value,
      ),
    ];
  }

  Widget _buildRoleSpecificDetails() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.selectedRoles.contains(UserRole.student))
              _buildExpansionTileCustom(
                  title: 'Student Details', children: _buildStudentDetails()),
            if (controller.selectedRoles.contains(UserRole.teacher))
              _buildExpansionTileCustom(
                  title: 'Teacher Details', children: _buildTeacherDetails()),
            if (controller.selectedRoles.contains(UserRole.busDriver))
              _buildExpansionTileCustom(
                  title: 'Driver Details', children: _buildDriverDetails()),
            if (controller.selectedRoles.contains(UserRole.securityGuard))
              _buildExpansionTileCustom(
                  title: 'Security Guard Details',
                  children: _buildSecurityGuardDetails()),
            if (controller.selectedRoles.contains(UserRole.janitor))
              _buildExpansionTileCustom(
                  title: 'Maintenance Staff Details',
                  children: _buildMaintenanceStaffDetails()),
            if (controller.selectedRoles.contains(UserRole.admin))
              _buildExpansionTileCustom(
                  title: 'Admin Details', children: _buildAdminDetails()),
            if (controller.selectedRoles.contains(UserRole.schoolAdmin))
              _buildExpansionTileCustom(
                  title: 'School Admin Details',
                  children: _buildSchoolAdminDetails()),
            if (controller.selectedRoles.contains(UserRole.director))
              _buildExpansionTileCustom(
                  title: 'Director Details', children: _buildDirectorDetails()),
            if (controller.selectedRoles.contains(UserRole.departmentHead))
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
      MyBottomSheetDropdown(
          labelText: 'Class',
          optionsForChips: ClassName.displayNamesList,
          onSingleChanged: (value) {
            controller.className.value = value;
          },
          isValid: true),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
          labelText: 'Section',
          optionsForChips:
              List.generate(26, (index) => String.fromCharCode(65 + index)),
          onSingleChanged: (value) {
            controller.section.value = value;
          },
          isValid: true),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
          labelText: 'House',
          optionsForChips: MyLists.schoolHouseOptions,
          onSingleChanged: (value) {
            controller.house.value = value;
          },
          isValid: true),
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
                style: MyTextStyle.titleLarge,
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
              if (controller.selectedGuardian.value == null)
                const Text("Please Select A Guardian",
                    style: TextStyle(color: MyColors.activeRed)),
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
                style: MyTextStyle.titleLarge,
              ),
              const SizedBox(
                height: MySizes.md,
              ),
              MyTextField(
                labelText: 'Full Name',
                controller: controller.guardianFullNameController,
                validator:
                    RequiredValidator(errorText: 'Full Name is required').call,
              ),
              const SizedBox(height: MySizes.md),
              MyBottomSheetDropdown(
                labelText: 'Relationship to Student',
                optionsForChips: MyLists.relationshipOptions,
                onSingleChanged: (value) {
                  controller.guardianRelationshipToStudent.value = value;
                },
                isValid: true,
              ),
              const SizedBox(height: MySizes.md),
              MyBottomSheetDropdown(
                labelText: 'Occupation',
                optionsForChips: MyLists.occupations,
                onSingleChanged: (value) {
                  controller.guardianOccupation.value = value;
                },
                isValid: true,
              ),
              const SizedBox(height: MySizes.md),
              MyTextField(
                labelText: 'Phone Number',
                controller: controller.motherPhoneNumberController,
                keyboardType: TextInputType.phone,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Phone Number is required'),
                  PatternValidator(r'^[0-9]+$',
                      errorText: 'Phone Number must contain only digits'),
                ]).call,
              ),
              const SizedBox(height: MySizes.md),
              MyTextField(
                labelText: 'Email Address',
                controller: controller.motherEmailAddressController,
                keyboardType: TextInputType.emailAddress,
                validator:
                    EmailValidator(errorText: 'Enter a valid email address')
                        .call,
              ),
              const SizedBox(height: MySizes.md),
              MyDropdownField(
                labelText: 'Highest Education Level',
                options: MyLists.educationDegreeOptions,
                selectedValue: controller.guardianHighestEducationLevel,
                onSelected: (value) {
                  controller.guardianHighestEducationLevel.value = value ?? '';
                },
                isValidate: true,
              ),
              const SizedBox(height: MySizes.md),
              MyTextField(
                labelText: 'Annual Income',
                controller: controller.motherAnnualIncomeController,
                keyboardType: TextInputType.number,
                validator: PatternValidator(r'^[0-9.]*$',
                        errorText: 'Annual Income must be a valid number')
                    .call,
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
      MyBottomSheetDropdown(
        labelText: 'Subjects Taught',
        optionsForChips: const ['Mathematics', 'Science', 'English', 'History'],
        onMultipleChanged: (values) {
          controller.subjectsTaught.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
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
        validator: PatternValidator(r'^[0-9.]*$',
                errorText: 'Experience must be a valid number')
            .call,
      ),
    ];
  }

  List<Widget> _buildDriverDetails() {
    return [
      MyTextField(
        labelText: 'License Number',
        controller: controller.licenseNumberController,
        validator:
            RequiredValidator(errorText: 'License Number is required').call,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Routes Assigned',
        optionsForChips: const ['Route A', 'Route B', 'Route C', 'Route D'],
        onMultipleChanged: (values) {
          controller.routesAssigned.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
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
        validator:
            RequiredValidator(errorText: 'Assigned Area is required').call,
      ),
      const SizedBox(height: MySizes.md),
    ];
  }

  List<Widget> _buildMaintenanceStaffDetails() {
    return [
      MyBottomSheetDropdown(
        labelText: 'Responsibilities',
        optionsForChips: const [
          'Cleaning',
          'Repairing',
          'Gardening',
          'Plumbing'
        ],
        onMultipleChanged: (values) {
          controller.maintenanceResponsibilities.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
    ];
  }

  List<Widget> _buildAdminDetails() {
    return [
      MyBottomSheetDropdown(
        labelText: 'Permissions',
        optionsForChips: const [
          'Create Users',
          'Edit Users',
          'Delete Users',
          'View Users'
        ],
        onMultipleChanged: (values) {
          controller.adminPermissions.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Assigned Modules',
        optionsForChips: const [
          'User Management',
          'School Management',
          'Finance Management',
          'Attendance Management'
        ],
        onMultipleChanged: (values) {
          controller.adminPermissions.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Manageable Schools',
        optionsForChips: const ['School A', 'School B', 'School C', 'School D'],
        onMultipleChanged: (values) {
          controller.manageableSchools.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
    ];
  }

  List<Widget> _buildSchoolAdminDetails() {
    return [
      MyBottomSheetDropdown(
        labelText: 'Permissions',
        optionsForChips: const ['Create Users', 'Edit Users', 'View Users'],
        onMultipleChanged: (values) {
          controller.schoolAdminPermissions.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Assigned Modules',
        optionsForChips: const ['User Management', 'Attendance Management'],
        onMultipleChanged: (values) {
          controller.schoolAdminAssignedModules.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
    ];
  }

  List<Widget> _buildDirectorDetails() {
    return [
      MyBottomSheetDropdown(
        labelText: 'Schools',
        optionsForChips: const ['School A', 'School B', 'School C'],
        onMultipleChanged: (values) {
          controller.directorSchools.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Years In Management',
        controller: controller.yearsInManagementController,
        keyboardType: TextInputType.number,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Years in Management is required'),
          PatternValidator(r'^[0-9.]*$', errorText: 'Enter a valid number'),
        ]).call,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Permissions',
        optionsForChips: const [
          'Create Schools',
          'Edit Schools',
          'Delete Schools',
          'View Schools'
        ],
        onMultipleChanged: (values) {
          controller.directorPermissions.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
    ];
  }

  List<Widget> _buildDepartmentHeadDetails() {
    return [
      MyTextField(
        labelText: 'Department',
        controller: controller.departmentController,
        validator: RequiredValidator(errorText: 'Department is required').call,
      ),
      const SizedBox(height: MySizes.md),
      MyTextField(
        labelText: 'Years As Head',
        controller: controller.yearsAsHeadController,
        keyboardType: TextInputType.number,
        validator: PatternValidator(r'^[0-9.]*$',
                errorText: 'Years as head must be a valid number')
            .call,
      ),
      const SizedBox(height: MySizes.md),
      MyBottomSheetDropdown(
        labelText: 'Responsibilities',
        optionsForChips: const [
          'Curriculum Design',
          'Teacher Evaluation',
          'Student Mentoring'
        ],
        onMultipleChanged: (values) {
          controller.departmentResponsibilities.value = values ?? [];
        },
        isMultipleSelection: true,
        isValid: true,
      ),
    ];
  }
}

Widget _buildRoleCard({
  required String role,
  required String description,
  required bool isSelected,
  required String assetPath,
  required VoidCallback onTap, // Added onTap callback
}) {
  return GestureDetector(
    // Wrap with GestureDetector
    onTap: onTap, // Attach onTap callback
    child: Container(
      decoration: BoxDecoration(
        color: isSelected ? MyColors.activeBlue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: isSelected ? MyColors.activeBlue : MyColors.borderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MySizes.md - 4),
        child: Row(
          children: [
            // SizedBox(
            //   height: 36,
            //   width: 36,
            //   child: SvgPicture.asset(
            //       assetPath), // Use assetPath here
            // ),
            // const SizedBox(
            //   width: MySizes.md,
            // ),
            Expanded(
              // Added Expanded to prevent overflow
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    role,
                    style: MyTextStyle.bodyLarge,
                  ),
                  const SizedBox(
                    height: MySizes.xs,
                  ),
                  Text(
                    description,
                    style: MyTextStyle.labelMedium,
                    maxLines: 2, // Limit to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
