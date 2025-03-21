import 'dart:io';

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/campus_area.dart';
import 'package:cambridge_school/core/utils/constants/enums/exam_pattern.dart';
import 'package:cambridge_school/core/utils/constants/enums/grading_system.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_board.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_gender_policy.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_ownership.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_specialization.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/core/widgets/image_picker.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../../core/widgets/time_picker.dart';
import '../../../../core/utils/constants/enums/academic_level.dart';
import '../../../../core/utils/constants/enums/medium_of_instruction.dart';
import 'edit_school_details_controller.dart';

class EditSchoolDetailsScreen extends StatelessWidget {
  // Changed to StatelessWidget
  final String schoolId;

  const EditSchoolDetailsScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    // Use the 'initialSchoolId' in the lazyPut
    Get.lazyPut(() => EditSchoolController(initialSchoolId: schoolId));

    final controller = Get.find<EditSchoolController>();

    final List<String> schoolDetailsCategory = [
      'General',
      'Location',
      'Contact',
      'Infrastructure',
      'Academic',
      'Administrative',
      'Branding',
      'Authentication'
    ];

    return DefaultTabController(
      length: schoolDetailsCategory.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit School'),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          bottom: TabBar(
            controller: controller.tabController,
            isScrollable: true,
            tabs: schoolDetailsCategory.map((name) => Tab(text: name)).toList(),
            onTap: (index) {
              controller.activeStep.value = index;
            },
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return TabBarView(
                controller: controller.tabController,
                children: [
                  _buildGeneralInformationStep(
                      controller), // Pass the controller
                  _buildLocationDetailsStep(controller), // Pass the controller
                  _buildContactInformationStep(
                      controller), // Pass the controller
                  _buildInfrastructureDetailsStep(
                      controller), // Pass the controller
                  _buildAcademicDetailsStep(controller), // Pass the controller
                  _buildAdministrativeInformationStep(
                      controller), // Pass the controller
                  _buildBrandingSetupStep(controller), // Pass the controller
                  _buildAuthenticationStep(controller), // Pass the controller
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Obx(
          () {
            if (controller.isLoading.value) {
              return const SizedBox.shrink();
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                  left: MySizes.lg,
                  right: MySizes.lg,
                  bottom: MySizes.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyButton(
                        isOutlined: true,
                        text: 'Back',
                        onPressed: () {
                          if (controller.activeStep.value > 0) {
                            controller.tabController
                                .animateTo(controller.activeStep.value - 1);
                            controller.activeStep.value--;
                          }
                        },
                        isDisabled: controller.activeStep.value == 0,
                      ),
                    ),
                    const SizedBox(width: MySizes.lg),
                    Expanded(
                      child: (controller.activeStep.value ==
                              schoolDetailsCategory.length - 1)
                          ? MyButton(
                              text: 'Update',
                              onPressed: () {
                                controller.isUpdating.value
                                    ? null
                                    : controller.updateSchoolData();
                              },
                              isDisabled: controller.isUpdating.value,
                            )
                          : MyButton(
                              text: 'Next',
                              onPressed: () {
                                if (controller.activeStep.value <
                                    schoolDetailsCategory.length - 1) {
                                  controller.tabController.animateTo(
                                      controller.activeStep.value + 1);
                                  controller.activeStep.value++;
                                }
                              },
                              isDisabled: controller.activeStep.value >=
                                  schoolDetailsCategory.length - 1,
                            ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildGeneralInformationStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'School Name',
              keyboardType: TextInputType.text,
              controller: controller.schoolNameController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.business),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Established Year',
              keyboardType: TextInputType.number,
              controller: controller.establishedYearController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.calendar_month),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Affiliation/Registration Number',
              keyboardType: TextInputType.text,
              controller: controller.affiliationRegistrationNumberController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.group),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Code',
              keyboardType: TextInputType.text,
              controller: controller.schoolCodeController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.numbers),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Motto/Slogan',
              keyboardType: TextInputType.text,
              controller: controller.schoolMottoController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.auto_awesome),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'About School',
              keyboardType: TextInputType.text,
              controller: controller.aboutSchoolController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.auto_awesome),
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: SchoolOwnershipExtension.labelsList,
              onSingleChanged: (val) {
                controller.selectedSchoolOwnership.value = val;
              },
              labelText: 'School Ownership',
              selectedValue:
                  controller.selectedSchoolOwnership, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: SchoolSpecializationExtension.labelsList,
              onSingleChanged: (val) {
                controller.selectedSchoolSpecialization.value = val;
              },
              labelText: 'School Specialization',
              selectedValue: controller
                  .selectedSchoolSpecialization, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: SchoolGenderPolicyExtension.labelsList,
              onSingleChanged: (val) {
                controller.selectedSchoolGenderPolicy.value = val;
              },
              labelText: 'School Gender Policy',
              selectedValue:
                  controller.selectedSchoolGenderPolicy, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetailsStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Address',
              keyboardType: TextInputType.text,
              controller: controller.addressController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.location_on),
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.countriesOptions,
              onSingleChanged: (val) {
                controller.selectedCountry.value = val;
              },
              labelText: 'Country',
              prefixIcon: Icons.public,
              selectedValue: controller.selectedCountry, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.indianStateOptions,
              onSingleChanged: (val) {
                controller.selectedState.value = val;
              },
              labelText: 'State',
              prefixIcon: Icons.map,
              selectedValue: controller.selectedState, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.indianStateOptions,
              onSingleChanged: (val) {
                controller.selectedDistrict.value = val;
              },
              labelText: 'District',
              prefixIcon: Icons.map,
              selectedValue: controller.selectedDistrict, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'City',
              keyboardType: TextInputType.text,
              controller: controller.cityController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.location_city),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'ZIP Code',
              keyboardType: TextInputType.number,
              controller: controller.zipCodeController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.numbers),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Street',
              keyboardType: TextInputType.text,
              controller: controller.streetController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.add_road),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Nearby Landmarks',
              keyboardType: TextInputType.text,
              controller: controller.landmarksNearbyController,
              validator: null, // Optional field
              suffixIcon: const Icon(Icons.temple_hindu),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInformationStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Primary Phone Number',
              keyboardType: TextInputType.phone,
              controller: controller.primaryPhoneNumberController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'This field is required'),
                PatternValidator(r'^\+?[0-9]{7,15}$',
                    errorText: 'Enter a valid phone number')
              ]).call,
              suffixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Secondary Phone Number',
              keyboardType: TextInputType.phone,
              controller: controller.secondaryPhoneNumberController,
              validator: PatternValidator(r'^\+?[0-9]{7,15}$',
                      errorText: 'Enter a valid phone number')
                  .call,
              suffixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailAddressController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'This field is required'),
                EmailValidator(errorText: 'Enter a valid email address')
              ]).call,
              suffixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Website',
              keyboardType: TextInputType.url,
              controller: controller.websiteController,
              validator: PatternValidator(
                r'^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$',
                errorText: 'Enter a valid website URL',
              ).call,
              suffixIcon: const Icon(Icons.web),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Fax Number (if applicable)',
              keyboardType: TextInputType.phone,
              controller: controller.faxNumberController,
              validator: null, // Optional field
              suffixIcon: const Icon(Icons.print),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfrastructureDetailsStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Campus Size (in sq ft)',
              keyboardType: TextInputType.number,
              controller: controller.campusSizeController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              prefixIcon: const Icon(Icons.crop_free),
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  List.generate(25, (index) => (index + 1).toString()),
              onSingleChanged: (val) {
                controller.selectedNumberOfBuildings.value = val;
              },
              labelText: 'Number of Buildings',
              prefixIcon: Icons.apartment,
              selectedValue:
                  controller.selectedNumberOfBuildings, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.labsAvailable,
              onMultipleChanged: (val) {
                controller.selectedLabsAvailable.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Available Laboratories',
              prefixIcon: Icons.biotech,
              initialSelectedValues: controller
                  .selectedLabsAvailable, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.sportsFacilities,
              onMultipleChanged: (val) {
                controller.selectedSportsFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Available Sports Facilities',
              prefixIcon: Icons.sports_baseball,
              initialSelectedValues: controller
                  .selectedSportsFacilities, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.musicAndArtFacilities,
              onMultipleChanged: (val) {
                controller.selectedMusicAndArtFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Music and Art Facilities',
              prefixIcon: Icons.music_note,
              initialSelectedValues: controller
                  .selectedMusicAndArtFacilities, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.studentClubs,
              onMultipleChanged: (val) {
                controller.selectedStudentClubs.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Student Clubs',
              prefixIcon: Icons.people,
              initialSelectedValues: controller
                  .selectedStudentClubs, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.specialTrainingPrograms,
              onMultipleChanged: (val) {
                controller.selectedSpecialTrainingPrograms.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Special Training Programs',
              prefixIcon: Icons.school,
              initialSelectedValues: controller
                  .selectedSpecialTrainingPrograms, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.generalFacilities,
              onMultipleChanged: (val) {
                controller.selectedGeneralFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'General Facilities',
              prefixIcon: Icons.home,
              initialSelectedValues: controller
                  .selectedGeneralFacilities, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.transportFacilities,
              onMultipleChanged: (val) {
                controller.selectedTransportFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Transport Facilities',
              prefixIcon: Icons.bus_alert,
              initialSelectedValues: controller
                  .selectedTransportFacilities, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.sportsInfrastructure,
              onMultipleChanged: (val) {
                controller.selectedSportsInfrastructure.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Sports Infrastructure',
              prefixIcon: Icons.fitness_center,
              initialSelectedValues: controller
                  .selectedSportsInfrastructure, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.healthAndSafetyFacilities,
              onMultipleChanged: (val) {
                controller.selectedHealthAndSafetyFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Health and Safety Facilities',
              prefixIcon: Icons.health_and_safety,
              initialSelectedValues: controller
                  .selectedHealthAndSafetyFacilities, // ADDED initialSelectedValues
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.additionalFacilities,
              onMultipleChanged: (val) {
                controller.selectedAdditionalFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Additional Facilities',
              prefixIcon: Icons.add_box,
              initialSelectedValues: controller
                  .selectedAdditionalFacilities, // ADDED initialSelectedValues
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdministrativeInformationStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: MyBottomSheetDropdown(
                    optionsForChips: MyLists.monthOptions,
                    onSingleChanged: (val) {
                      controller.selectedAcademicYearStart.value = val;
                    },
                    labelText: 'Academic Year Start',
                    prefixIcon: Icons.date_range,
                    hintText: 'Start',
                    selectedValue: controller
                        .selectedAcademicYearStart, // ADDED selectedValue
                  ),
                ),
                const SizedBox(
                  width: MySizes.md,
                ),
                Expanded(
                  child: MyBottomSheetDropdown(
                    optionsForChips: MyLists.monthOptions,
                    onSingleChanged: (val) {
                      controller.selectedAcademicYearEnd.value = val;
                    },
                    labelText: 'Academic Year End',
                    prefixIcon: Icons.date_range,
                    hintText: 'End',
                    selectedValue: controller
                        .selectedAcademicYearEnd, // ADDED selectedValue
                  ),
                ),
              ],
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Number of Periods per Day',
              keyboardType: TextInputType.number,
              controller: controller.periodsPerDayController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(Icons.timelapse),
            ),
            const SizedBox(
              height: MySizes.lg,
            ),
            const MyDottedLine(
              dashColor: MyColors.dividerColor,
            ),
            const SizedBox(
              height: MySizes.md,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "School Timings",
                  style: Theme.of(Get.context!)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: MySizes.md),
                Row(
                  children: [
                    Expanded(
                      child: MyTimePickerField(
                        labelText: 'Arrival Time',
                        hintText: 'Arrival',
                        selectedTime: controller.arrivalTime,
                        onTimeChanged: (time) {
                          controller.arrivalTime.value = time;
                        },
                      ),
                    ),
                    const SizedBox(width: MySizes.lg),
                    Expanded(
                      child: MyTimePickerField(
                        labelText: 'Departure Time',
                        hintText: 'Departure',
                        selectedTime: controller.departureTime,
                        onTimeChanged: (time) {
                          controller.departureTime.value = time;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.lg),
                Row(
                  children: [
                    Expanded(
                      child: MyTimePickerField(
                        labelText: 'Assembly Start Time',
                        hintText: 'Start',
                        selectedTime: controller.assemblyStartTime,
                        onTimeChanged: (time) {
                          controller.assemblyStartTime.value = time;
                        },
                      ),
                    ),
                    const SizedBox(width: MySizes.lg),
                    Expanded(
                      child: MyTimePickerField(
                        labelText: 'Assembly End Time',
                        hintText: 'End',
                        selectedTime: controller.assemblyEndTime,
                        onTimeChanged: (time) {
                          controller.assemblyEndTime.value = time;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.lg),
                Row(
                  children: [
                    Expanded(
                      child: MyTimePickerField(
                        labelText: 'Break Start Time',
                        hintText: 'Start',
                        selectedTime: controller.breakStartTime,
                        onTimeChanged: (time) {
                          controller.breakStartTime.value = time;
                        },
                      ),
                    ),
                    const SizedBox(width: MySizes.lg),
                    Expanded(
                      child: MyTimePickerField(
                        labelText: 'Break End Time',
                        hintText: 'End',
                        selectedTime: controller.breakEndTime,
                        onTimeChanged: (time) {
                          controller.breakEndTime.value = time;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: MySizes.md,
            ),
            const MyDottedLine(
              dashColor: MyColors.dividerColor,
            ),
            const SizedBox(
              height: MySizes.md,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicDetailsStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyBottomSheetDropdown(
              optionsForChips: SchoolBoard.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedSchoolBoard.value = val;
              },
              labelText: 'School Board',
              selectedValue:
                  controller.selectedSchoolBoard, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  GradingSystem.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedGradingSystem.value = val;
              },
              labelText: 'Grading System',
              selectedValue:
                  controller.selectedGradingSystem, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  ExaminationPattern.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedExaminationPattern.value = val;
              },
              labelText: 'Examination Pattern',
              selectedValue:
                  controller.selectedExaminationPattern, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  AcademicLevel.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedAcademicLevel.value = val;
              },
              labelText: 'Academic Level',
              selectedValue:
                  controller.selectedAcademicLevel, // ADDED selectedValue
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  MediumOfInstruction.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedMediumOfInstruction.value = val;
              },
              labelText: 'Medium of Instruction',
              selectedValue:
                  controller.selectedMediumOfInstruction, // ADDED selectedValue
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingSetupStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyImagePickerField(
                image: controller.schoolLogoImage.value,
                onImageSelected: (File value) {
                  controller.schoolLogoImage.value = value;
                },
              ),
              const SizedBox(height: MySizes.lg),
              MyImagePickerField(
                image: controller.schoolCoverImage.value,
                onImageSelected: (File value) {
                  controller.schoolCoverImage.value = value;
                },
              ),
              const SizedBox(height: MySizes.lg),
              if (controller.schoolImages.isNotEmpty) ...[
                const Text(
                  "School Gallery",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: MySizes.md),
                for (var schoolImage in controller.schoolImages) ...[
                  Text(
                    schoolImage.campusArea.label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: schoolImage.imageUrls
                        .map(
                          (imageUrl) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: MySizes.md),
                ],
              ],
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showAddImageDialog(Get.context!, controller),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Add School Images"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticationStep(EditSchoolController controller) {
    // Receive the controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Admin Phone Number',
              keyboardType: TextInputType.phone,
              controller: controller.adminPhoneNoController,
              validator: null, // Optional validation
              suffixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(
              height: MySizes.lg,
            ),
            MyButton(
              text: 'Update School',
              onPressed: () {
                controller.isUpdating.value
                    ? null
                    : controller.updateSchoolData();
              },
              isDisabled: controller.isUpdating.value,
            ),
            const SizedBox(
              height: MySizes.lg,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddImageDialog(
      BuildContext context, EditSchoolController controller) {
    // Receive the controller
    RxString selectedCampusArea = ''.obs;

    Get.defaultDialog(
      title: "Enter Campus Area",
      content: Column(
        children: [
          MyBottomSheetDropdown(
            optionsForChips: CampusArea.values.map((e) => e.label).toList(),
            onSingleChanged: (String? val) {
              selectedCampusArea.value = val ?? '';
            },
            labelText: 'Campus Area',
            selectedValue: selectedCampusArea,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (selectedCampusArea.isNotEmpty) {
                Get.back();
                controller.pickImages(
                    CampusAreaExtension.fromString(selectedCampusArea.value) ??
                        CampusArea.classroom);
              } else {
                Get.snackbar("Error", "Please select a campus area.");
              }
            },
            child: const Text("Select Images"),
          ),
        ],
      ),
    );
  }

  Widget stepInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: MyDynamicColors.activeBlue,
          ),
          const SizedBox(
            width: MySizes.md,
          ),
          Text(
            text,
            style: Theme.of(Get.context!)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
