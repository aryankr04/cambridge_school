import 'dart:io';

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/campus_area.dart';
import 'package:cambridge_school/core/utils/constants/enums/examination_pattern.dart';
import 'package:cambridge_school/core/utils/constants/enums/grading_system.dart';
import 'package:cambridge_school/core/utils/constants/enums/month.dart';
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
import '../../../../core/widgets/stepper.dart';
import 'create_school_controller.dart';

final List<String> stepNamesForCreateSchool = [
  'Introduction to Create a School',
  'General Information',
  'Location Details',
  'Contact Information',
  'Infrastructure Details',
  'Academic Details',
  'Administrative Information',
  ' School Branding',
  'Authentication'
];

class CreateSchoolScreen extends StatelessWidget {
  CreateSchoolScreen({super.key});

  final CreateSchoolController controller = Get.put(CreateSchoolController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create School'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
              Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: MySizes.lg, right: MySizes.lg, top: MySizes.lg),
            child: Column(
              children: [
                Obx(() => MyStepper(
                    activeStep: controller.activeStep.value - 1, noOfSteps: 8)),
                const SizedBox(
                    height: MySizes.spaceBtwSections),
                FilledButton(
                    onPressed: () {
                      controller.sendDummySchoolsToFirebase();
                    },
                    child: const Text('Send')),
                Obx(
                  () => Column(
                    children: [
                      if (controller.activeStep > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.getStepName(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall,
                          ),
                        ),
                      // const SizedBox(height: SchoolSizes.lg,)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics:
                  const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (int page) {
                controller.activeStep.value = page;
              },
              controller: controller.pageController,
              children: [
                _buildIntroductionStep(context),
                _buildGeneralInformationStep(context),
                _buildLocationDetailsStep(context),
                _buildContactInformationStep(context),
                _buildInfrastructureDetailsStep(context),
                _buildAdministrativeInformationStep(context),
                _buildAcademicDetailsStep(context),
                _buildBrandingSetupStep(context),
                _buildAuthenticationStep(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: MySizes.lg,
              right: MySizes.lg,
              bottom: MySizes.lg,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                    () => MyButton(
                      isOutlined: true,
                      text: 'Back',
                      onPressed: () {
                        if (controller.activeStep.value > 0) {
                          controller.decrementStep();
                        }
                      },
                      isDisabled:
                          controller.activeStep.value == 0 ? true : false,
                    ),
                  ),
                ),
                const SizedBox(width: MySizes.lg),
                Expanded(
                  child: Obx(
                    () => MyButton(
                      text: 'Next',
                      onPressed: () {
                        if (controller.activeStep.value <= 7) {
                          controller.incrementStep();
                        }
                      },
                      isDisabled:
                          controller.activeStep.value > 7 ? true : false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionStep(
      BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Introduction to Student Registration',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),
            ),
            const SizedBox(
              height: MySizes.lg,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Welcome! This registration will guide you through 8 simple steps to set up your school profile with essential details about its identity, infrastructure, curriculum, academics. This process ensures that all critical information is recorded to create a comprehensive and effective profile for your institution.",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: MyColors.subtitleTextColor),
                  ),
                ),
                // SvgPicture.asset(
                //   'assets/images/illustration/sign_up_cuate.svg',
                //   height: 150,
                //   fit: BoxFit.fill,
                // )
              ],
            ),
            const SizedBox(
              height: MySizes.spaceBtwSections,
            ),
            Text(
              "Create School in 8 Easy Steps",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(),
            ),
            const SizedBox(
              height: MySizes.md - 8,
            ),
            stepInfoRow(stepNamesForCreateSchool[1]),
            stepInfoRow(stepNamesForCreateSchool[2]),
            stepInfoRow(stepNamesForCreateSchool[3]),
            stepInfoRow(stepNamesForCreateSchool[4]),
            stepInfoRow(stepNamesForCreateSchool[5]),
            stepInfoRow(stepNamesForCreateSchool[6]),
            stepInfoRow(stepNamesForCreateSchool[7]),
            stepInfoRow(stepNamesForCreateSchool[8]),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInformationStep(
      BuildContext context) {
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
              suffixIcon: const Icon(
                  Icons.business),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Established Year',
              keyboardType: TextInputType.number,
              controller: controller.establishedYearController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(
                  Icons.calendar_month),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Affiliation/Registration Number',
              keyboardType: TextInputType.text,
              controller: controller.affiliationRegistrationNumberController,
              validator: null, // Optional validation
              suffixIcon: const Icon(
                  Icons.group),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Code',
              keyboardType: TextInputType.text,
              controller: controller.schoolCodeController,
              validator: null, // Optional validation
              suffixIcon: const Icon(
                  Icons.numbers),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Motto/Slogan',
              keyboardType: TextInputType.text,
              controller: controller.schoolMottoController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(
                  Icons.auto_awesome),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'About School',
              keyboardType: TextInputType.text,
              controller: controller.aboutSchoolController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(
                  Icons.auto_awesome),
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: SchoolOwnership.labelsList,
              onSingleChanged: (val) {
                controller.selectedSchoolOwnership.value = val;
              },
              labelText: 'School Ownership',
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: SchoolSpecialization .labelsList,
              onSingleChanged: (val) {
                controller.selectedSchoolSpecialization.value = val;
              },
              labelText: 'School Specialization',
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: SchoolGenderPolicy.labelsList,
              onSingleChanged: (val) {
                controller.selectedSchoolGenderPolicy.value = val;
              },
              labelText: 'School Gender Policy',
            ),
            const SizedBox(height: MySizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetailsStep(
      BuildContext context) {
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
              suffixIcon: const Icon(
                  Icons.location_on),
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.countriesOptions,
              onSingleChanged: (val) {
                controller.selectedCountry.value = val;
              },
              labelText: 'Country',
              prefixIcon: Icons.public,
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.indianStateOptions,
              onSingleChanged: (val) {
                controller.selectedState.value = val;
              },
              labelText: 'State',
              prefixIcon: Icons.map,
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.indianStateOptions,
              onSingleChanged: (val) {
                controller.selectedDistrict.value = val;
              },
              labelText: 'District',
              prefixIcon: Icons.map,
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'City',
              keyboardType: TextInputType.text,
              controller: controller.cityController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(
                  Icons.location_city),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'ZIP Code',
              keyboardType: TextInputType.number,
              controller: controller.zipCodeController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(
                  Icons.numbers),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Street',
              keyboardType: TextInputType.text,
              controller: controller.streetController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const Icon(
                  Icons.add_road),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Nearby Landmarks',
              keyboardType: TextInputType.text,
              controller: controller.landmarksNearbyController,
              validator: null, // Optional field
              suffixIcon: const Icon(
                  Icons.temple_hindu),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInformationStep(
      BuildContext context) {
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
              suffixIcon: const Icon(
                  Icons.phone),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Secondary Phone Number',
              keyboardType: TextInputType.phone,
              controller: controller.secondaryPhoneNumberController,
              validator: PatternValidator(r'^\+?[0-9]{7,15}$',
                      errorText: 'Enter a valid phone number')
                  .call, // Optional field
              suffixIcon: const Icon(
                  Icons.phone),
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
              suffixIcon: const Icon(
                  Icons.email),
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
              suffixIcon: const Icon(
                  Icons.web),
            ),
            const SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Fax Number (if applicable)',
              keyboardType: TextInputType.phone,
              controller: controller.faxNumberController,
              validator: null, // Optional field
              suffixIcon: const Icon(
                  Icons.print),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfrastructureDetailsStep(
      BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Campus Size
            MyTextField(
              labelText: 'Campus Size (in sq ft)',
              keyboardType: TextInputType.number,
              controller: controller.campusSizeController,
              validator:
                  RequiredValidator(errorText: 'This field is required').call,
              prefixIcon: const Icon(
                  Icons.crop_free),
            ),
            const SizedBox(height: MySizes.lg),

            // 2. Number of Buildings
            MyBottomSheetDropdown(
              optionsForChips:
                  List.generate(25, (index) => (index + 1).toString()),
              onSingleChanged: (val) {
                controller.selectedNumberOfBuildings.value = val;
              },
              labelText: 'Number of Buildings',
              prefixIcon: Icons.apartment,
            ),
            const SizedBox(height: MySizes.lg),

            // 5. Available Laboratories (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.labsAvailable,
              onMultipleChanged: (val) {
                controller.selectedLabsAvailable.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Available Laboratories',
              prefixIcon: Icons.biotech,
            ),
            const SizedBox(height: MySizes.lg),

            // 6. Available Sports Facilities (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.sportsFacilities,
              onMultipleChanged: (val) {
                controller.selectedSportsFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Available Sports Facilities',
              prefixIcon: Icons.sports_baseball,
            ),
            const SizedBox(height: MySizes.lg),

            // 7. Music and Art Facilities (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.musicAndArtFacilities,
              onMultipleChanged: (val) {
                controller.selectedMusicAndArtFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Music and Art Facilities',
              prefixIcon: Icons.music_note,
            ),
            const SizedBox(height: MySizes.lg),

            // 8. Student Clubs (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.studentClubs,
              onMultipleChanged: (val) {
                controller.selectedStudentClubs.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Student Clubs',
              prefixIcon: Icons.people,
            ),
            const SizedBox(height: MySizes.lg),

            // 9
            // 9. Special Training Programs (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.specialTrainingPrograms,
              onMultipleChanged: (val) {
                controller.selectedSpecialTrainingPrograms.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Special Training Programs',
              prefixIcon: Icons.school,
            ),
            const SizedBox(height: MySizes.lg),

            // 10. General Facilities (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.generalFacilities,
              onMultipleChanged: (val) {
                controller.selectedGeneralFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'General Facilities',
              prefixIcon: Icons.home,
            ),
            const SizedBox(height: MySizes.lg),

            // 11. Transport Facilities (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.transportFacilities,
              onMultipleChanged: (val) {
                controller.selectedTransportFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Transport Facilities',
              prefixIcon: Icons.bus_alert,
            ),
            const SizedBox(height: MySizes.lg),

            // 12. Sports Infrastructure (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.sportsInfrastructure,
              onMultipleChanged: (val) {
                controller.selectedSportsInfrastructure.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Sports Infrastructure',
              prefixIcon: Icons.fitness_center,
            ),
            const SizedBox(height: MySizes.lg),

            // 13. Health and Safety Facilities (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.healthAndSafetyFacilities,
              onMultipleChanged: (val) {
                controller.selectedHealthAndSafetyFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Health and Safety Facilities',
              prefixIcon: Icons.health_and_safety,
            ),
            const SizedBox(height: MySizes.lg),

            // 14. Additional Facilities (Multiple Selection)
            MyBottomSheetDropdown(
              optionsForChips: MyLists.additionalFacilities,
              onMultipleChanged: (val) {
                controller.selectedAdditionalFacilities.value = val!;
              },
              isMultipleSelection: true,
              labelText: 'Additional Facilities',
              prefixIcon: Icons.add_box,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdministrativeInformationStep(
      BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.lg),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyBottomSheetDropdown(
                      optionsForChips: Month.labelsList(),
                      onSingleChanged: (val) {
                        controller.selectedAcademicYearStart.value = val;
                      },
                      labelText: 'Academic Year Start',
                      prefixIcon: Icons.date_range,
                      hintText: 'Start',
                    ),
                  ),
                  const SizedBox(
                    width: MySizes.md,
                  ),
                  Expanded(
                    child: MyBottomSheetDropdown(
                      optionsForChips: Month.labelsList(),
                      onSingleChanged: (val) {
                        controller.selectedAcademicYearEnd.value = val;
                      },
                      labelText: 'Academic Year End',
                      prefixIcon: Icons.date_range,
                      hintText: 'End',
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
                suffixIcon: const Icon(
                    Icons.timelapse),
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "School Timings",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
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
                  // End Time
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
                            print("Assembly Start Time: $time");
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
                            print("Assembly End Time: $time");
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
                            print("Break Start Time: $time");
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
                            print("Break End Time: $time");
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
      ),
    );
  }

  Widget _buildAcademicDetailsStep(
      BuildContext context) {
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
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  GradingSystem.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedGradingSystem.value = val;
              },
              labelText: 'Grading System',
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  ExaminationPattern.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedExaminationPattern.value = val;
              },
              labelText: 'Examination Pattern',
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  AcademicLevel.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedAcademicLevel.value = val;
              },
              labelText: 'Academic Level',
            ),
            const SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips:
                  MediumOfInstruction.values.map((e) => e.label).toList(),
              onSingleChanged: (val) {
                controller.selectedMediumOfInstruction.value = val;
              },
              labelText: 'Medium of Instruction',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingSetupStep(
      BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **School Logo Picker**
                MyImagePickerField(
                  image: controller.schoolLogoImage.value,
                  onImageSelected: (File value) {
                    controller.schoolLogoImage.value = value;
                  },
                ),
                const SizedBox(height: MySizes.lg),

                /// **School Cover Image Picker**
                MyImagePickerField(
                  image: controller.schoolCoverImage.value,
                  onImageSelected: (File value) {
                    controller.schoolCoverImage.value = value;
                  },
                ),
                const SizedBox(height: MySizes.lg),

                /// **Display Selected Images Grouped by Place Name**
                if (controller.schoolImages.isNotEmpty) ...[
                  const Text(
                    "School Gallery",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: MySizes.md),
                  for (var schoolImage in controller.schoolImages) ...[
                    Text(
                      schoolImage.campusArea.label,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: schoolImage.imageUrls
                          .map((imageUrl) => ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                        8),
                                child: Image.network(
                                  imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: MySizes.md),
                  ],
                ],

                /// **Add School Images Button**
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddImageDialog(context),
                    icon: const Icon(
                        Icons.add_photo_alternate),
                    label: const Text("Add School Images"),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildAuthenticationStep(
      BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                suffixIcon: const Icon(
                    Icons.phone),
              ),
              const SizedBox(
                height: MySizes.lg,
              ),
              MyButton(
                  text: 'Create New School',
                  onPressed: () {
                    controller.addSchoolToFirebase();
                  }),
              const SizedBox(
                height: MySizes.lg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Show Dialog to Enter Place Name**
  void _showAddImageDialog(BuildContext context) {
    RxString selectedCampusArea = ''.obs;

    Get.defaultDialog(
      title: "Enter Place Name",
      content: Column(
        children: [
          MyBottomSheetDropdown(
            optionsForChips: CampusArea.values.map((e) => e.label).toList(),
            onSingleChanged: (val) {
              selectedCampusArea.value = val;
            },
            labelText: 'Campus Area',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (selectedCampusArea.isNotEmpty) {
                Get.back();
                controller.pickImages(
                    CampusArea.fromString(selectedCampusArea.value) ??
                        CampusArea.classroom);
              } else {
                Get.snackbar("Error", "Please enter a place name.");
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
