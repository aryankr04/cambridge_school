import 'dart:io';

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/core/widgets/image_picker.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart' as create_school_screen;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../../core/widgets/time_picker.dart';
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

class CreateSchoolScreen extends create_school_screen.StatelessWidget {
  CreateSchoolScreen({create_school_screen.Key? key}) : super(key: key);

  final CreateSchoolController controller = Get.put(CreateSchoolController());

  @override
  create_school_screen.Widget build(create_school_screen.BuildContext context) {
    return create_school_screen.Scaffold(
      appBar: create_school_screen.AppBar(
        title: const create_school_screen.Text('Create School'),
        leading: create_school_screen.IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const create_school_screen.Icon(create_school_screen.Icons.arrow_back_rounded),
        ),
      ),
      body: create_school_screen.Column(
        children: [
          create_school_screen.Padding(
            padding: const create_school_screen.EdgeInsets.only(left: MySizes.lg, right: MySizes.lg, top: MySizes.lg),
            child: create_school_screen.Column(
              children: [
                Obx(() => MyStepper(
                    activeStep: controller.activeStep.value - 1,
                    noOfSteps: 8)),
                const create_school_screen.SizedBox(height: MySizes.spaceBtwSections),
                Obx(
                      () => create_school_screen.Column(
                    children: [
                      if (controller.activeStep > 0)
                        create_school_screen.Align(
                          alignment: create_school_screen.Alignment.centerLeft,
                          child: create_school_screen.Text(
                            controller.getStepName(),
                            style: create_school_screen.Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      // const SizedBox(height: SchoolSizes.lg,)
                    ],
                  ),
                ),
              ],
            ),
          ),
          create_school_screen.Expanded(
            child: create_school_screen.PageView(
              physics: const create_school_screen.NeverScrollableScrollPhysics(),
              scrollDirection: create_school_screen.Axis.horizontal,
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
          create_school_screen.Padding(
            padding: const create_school_screen.EdgeInsets.only(
              left: MySizes.lg,
              right: MySizes.lg,
              bottom: MySizes.lg,
            ),
            child: create_school_screen.Row(
              mainAxisAlignment: create_school_screen.MainAxisAlignment.spaceBetween,
              children: [
                create_school_screen.Expanded(
                  child: Obx(
                        () => MyButton(
                      isOutlined: true,
                      text: 'Back',
                      onPressed: () {
                        if (controller.activeStep.value > 0) {
                          controller.decrementStep();
                        }
                      },
                      isDisabled: controller.activeStep.value == 0
                          ? true
                          : false,
                    ),
                  ),
                ),
                const create_school_screen.SizedBox(width: MySizes.lg),
                create_school_screen.Expanded(
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

  create_school_screen.Widget _buildIntroductionStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      child: create_school_screen.Padding(
        padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
        child: create_school_screen.Column(
          crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
          children: [
            create_school_screen.Align(
              alignment: create_school_screen.Alignment.centerLeft,
              child: create_school_screen.Text(
                'Introduction to Student Registration',
                style: create_school_screen.Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const create_school_screen.SizedBox(
              height: MySizes.lg,
            ),
            create_school_screen.Row(
              children: [
                create_school_screen.Expanded(
                  child: create_school_screen.Text(
                    "Welcome! This registration will guide you through 8 simple steps to set up your school profile with essential details about its identity, infrastructure, curriculum, academics. This process ensures that all critical information is recorded to create a comprehensive and effective profile for your institution.",
                    style: create_school_screen.Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: create_school_screen.FontWeight.w400,color: MyColors.subtitleTextColor),
                  ),
                ),
                // SvgPicture.asset(
                //   'assets/images/illustration/sign_up_cuate.svg',
                //   height: 150,
                //   fit: BoxFit.fill,
                // )
              ],
            ),
            const create_school_screen.SizedBox(
              height: MySizes.spaceBtwSections,
            ),
            create_school_screen.Text(
              "Create School in 8 Easy Steps",
              style: create_school_screen.Theme.of(context).textTheme.headlineSmall?.copyWith(),
            ),
            const create_school_screen.SizedBox(
              height: MySizes.md-8
              ,
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

  create_school_screen.Widget _buildGeneralInformationStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
      child: create_school_screen.Form(
        child: create_school_screen.Column(
          crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
          children: [

            MyTextField(
              labelText: 'School Name',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.schoolNameController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.business),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Established Year',
              keyboardType: create_school_screen.TextInputType.number,
              controller: controller.establishedYearController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.calendar_month),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Affiliation/Registration Number',
              keyboardType: create_school_screen.TextInputType.text,
              controller:
              controller.affiliationRegistrationNumberController,
              validator: null, // Optional validation
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.group),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Management Authority',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.schoolManagementAuthorityController,
              validator: null, // Optional validation
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.admin_panel_settings),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'School Motto/Slogan',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.schoolMottoController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.auto_awesome),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'About School',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.aboutSchoolController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.auto_awesome),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.schoolTypeOptions,
              onSingleChanged: (val) {
                controller.selectedSchoolType.value = val!;
              },
              labelText: 'School Type',
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),

          ],
        ),
      ),
    );
  }

  create_school_screen.Widget _buildLocationDetailsStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
      child: create_school_screen.Form(
        child: create_school_screen.Column(
          crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Address',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.addressController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.location_on),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.countriesOptions,
              onSingleChanged: (val) {
                controller.selectedCountry.value = val!;
              },
              labelText: 'Country',
              prefixIcon: create_school_screen.Icons.public,
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.indianStateOptions,
              onSingleChanged: (val) {
                controller.selectedState.value = val!;
              },
              labelText: 'State',
              prefixIcon: create_school_screen.Icons.map,
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.indianStateOptions,
              onSingleChanged: (val) {
                controller.selectedDistrict.value = val!;
              },
              labelText: 'District',
              prefixIcon: create_school_screen.Icons.map,
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'City',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.cityController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.location_city),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'ZIP Code',
              keyboardType: create_school_screen.TextInputType.number,
              controller: controller.zipCodeController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.numbers),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Street',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.streetController,
              validator:
              RequiredValidator(errorText: 'This field is required').call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.add_road),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Nearby Landmarks',
              keyboardType: create_school_screen.TextInputType.text,
              controller: controller.landmarksNearbyController,
              validator: null, // Optional field
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.temple_hindu),
            ),
          ],
        ),
      ),
    );
  }

  create_school_screen.Widget _buildContactInformationStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
      child: create_school_screen.Form(
        child: create_school_screen.Column(
          crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
          children: [
            MyTextField(
              labelText: 'Primary Phone Number',
              keyboardType: create_school_screen.TextInputType.phone,
              controller: controller.primaryPhoneNumberController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'This field is required'),
                PatternValidator(r'^\+?[0-9]{7,15}$',
                    errorText: 'Enter a valid phone number')
              ]).call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.phone),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Secondary Phone Number',
              keyboardType: create_school_screen.TextInputType.phone,
              controller: controller.secondaryPhoneNumberController,
              validator: PatternValidator(r'^\+?[0-9]{7,15}$',
                  errorText: 'Enter a valid phone number')
                  .call, // Optional field
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.phone),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Email Address',
              keyboardType: create_school_screen.TextInputType.emailAddress,
              controller: controller.emailAddressController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'This field is required'),
                EmailValidator(errorText: 'Enter a valid email address')
              ]).call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.email),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Website',
              keyboardType: create_school_screen.TextInputType.url,
              controller: controller.websiteController,
              validator: PatternValidator(
                r'^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$',
                errorText: 'Enter a valid website URL',
              ).call,
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.web),
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyTextField(
              labelText: 'Fax Number (if applicable)',
              keyboardType: create_school_screen.TextInputType.phone,
              controller: controller.faxNumberController,
              validator: null, // Optional field
              suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.print),
            ),
            const create_school_screen.SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  create_school_screen.Widget _buildInfrastructureDetailsStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
      child: create_school_screen.Form(
      child: create_school_screen.Column(
      crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
      children: [
      // 1. Campus Size
      MyTextField(
      labelText: 'Campus Size (in sq ft)',
      keyboardType: create_school_screen.TextInputType.number,
      controller: controller.campusSizeController,
      validator:
      RequiredValidator(errorText: 'This field is required').call,
      prefixIcon: const create_school_screen.Icon(create_school_screen.Icons.crop_free),
    ),
    const create_school_screen.SizedBox(height: MySizes.lg),

    // 2. Number of Buildings
    MyTextField(
    labelText: 'Number of Buildings',
    keyboardType: create_school_screen.TextInputType.number,
    controller: controller.numberOfBuildingsController,
    validator:
    RequiredValidator(errorText: 'This field is required').call,
    prefixIcon: const create_school_screen.Icon(create_school_screen.Icons.home),
    ),
    const create_school_screen.SizedBox(height: MySizes.lg),



    // 5. Available Laboratories (Multiple Selection)
    MyBottomSheetDropdown(
    optionsForChips: MyLists.labsAvailable,
    onMultipleChanged: (val) {
    controller.selectedLabsAvailable.value = val!;
    },
    isMultipleSelection: true,
    labelText: 'Available Laboratories',
    prefixIcon: create_school_screen.Icons.biotech,
    ),
    const create_school_screen.SizedBox(height: MySizes.lg),

    // 6. Available Sports Facilities (Multiple Selection)
    MyBottomSheetDropdown(
    optionsForChips: MyLists.sportsFacilities,
    onMultipleChanged: (val) {
    controller.selectedSportsFacilities.value = val!;
    },
    isMultipleSelection: true,
    labelText: 'Available Sports Facilities',
    prefixIcon: create_school_screen.Icons.sports_baseball,
    ),
    const create_school_screen.SizedBox(height: MySizes.lg),

    // 7. Music and Art Facilities (Multiple Selection)
    MyBottomSheetDropdown(
    optionsForChips: MyLists.musicAndArtFacilities,
    onMultipleChanged: (val) {
    controller.selectedMusicAndArtFacilities.value = val!;
    },
    isMultipleSelection: true,
    labelText: 'Music and Art Facilities',
    prefixIcon: create_school_screen.Icons.music_note,
    ),
    const create_school_screen.SizedBox(height: MySizes.lg),

    // 8. Student Clubs (Multiple Selection)
    MyBottomSheetDropdown(
    optionsForChips: MyLists.studentClubs,
    onMultipleChanged: (val) {
    controller.selectedStudentClubs.value = val!;
    },
    isMultipleSelection: true,
    labelText: 'Student Clubs',
    prefixIcon: create_school_screen.Icons.people,
    ),
    const create_school_screen.SizedBox(height: MySizes.lg),

    // 9
        // 9. Special Training Programs (Multiple Selection)
        MyBottomSheetDropdown(
          optionsForChips: MyLists.specialTrainingPrograms,
          onMultipleChanged: (val) {
            controller.selectedSpecialTrainingPrograms.value = val!;
          },
          isMultipleSelection: true,
          labelText: 'Special Training Programs',
          prefixIcon: create_school_screen.Icons.school,
        ),
        const create_school_screen.SizedBox(height: MySizes.lg),

        // 10. General Facilities (Multiple Selection)
        MyBottomSheetDropdown(
          optionsForChips: MyLists.generalFacilities,
          onMultipleChanged: (val) {
            controller.selectedGeneralFacilities.value = val!;
          },
          isMultipleSelection: true,
          labelText: 'General Facilities',
          prefixIcon: create_school_screen.Icons.home,
        ),
        const create_school_screen.SizedBox(height: MySizes.lg),

        // 11. Transport Facilities (Multiple Selection)
        MyBottomSheetDropdown(
          optionsForChips: MyLists.transportFacilities,
          onMultipleChanged: (val) {
            controller.selectedTransportFacilities.value = val!;
          },
          isMultipleSelection: true,
          labelText: 'Transport Facilities',
          prefixIcon: create_school_screen.Icons.bus_alert,
        ),
        const create_school_screen.SizedBox(height: MySizes.lg),

        // 12. Sports Infrastructure (Multiple Selection)
        MyBottomSheetDropdown(
          optionsForChips: MyLists.sportsInfrastructure,
          onMultipleChanged: (val) {
            controller.selectedSportsInfrastructure.value = val!;
          },
          isMultipleSelection: true,
          labelText: 'Sports Infrastructure',
          prefixIcon: create_school_screen.Icons.fitness_center,
        ),
        const create_school_screen.SizedBox(height: MySizes.lg),

        // 13. Health and Safety Facilities (Multiple Selection)
        MyBottomSheetDropdown(
          optionsForChips: MyLists.healthAndSafetyFacilities,
          onMultipleChanged: (val) {
            controller.selectedHealthAndSafetyFacilities.value = val!;
          },
          isMultipleSelection: true,
          labelText: 'Health and Safety Facilities',
          prefixIcon: create_school_screen.Icons.health_and_safety,
        ),
        const create_school_screen.SizedBox(height: MySizes.lg),

        // 14. Additional Facilities (Multiple Selection)
        MyBottomSheetDropdown(
          optionsForChips: MyLists.additionalFacilities,
          onMultipleChanged: (val) {
            controller.selectedAdditionalFacilities.value = val!;
          },
          isMultipleSelection: true,
          labelText: 'Additional Facilities',
          prefixIcon: create_school_screen.Icons.add_box,
        ),
      ],
      ),
      ),
    );
  }

  create_school_screen.Widget _buildAcademicDetailsStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      child: create_school_screen.Padding(
        padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
        child: create_school_screen.Form(
          child: create_school_screen.Column(
            crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
            children: [
              create_school_screen.Row(
                children: [
                  create_school_screen.Expanded(
                    child: MyBottomSheetDropdown(
                      optionsForChips: MyLists.monthOptions,
                      onSingleChanged: (val) {
                        controller.selectedAcademicYearStart.value = val!;
                      },
                      labelText: 'Academic Year Start',
                      prefixIcon: create_school_screen.Icons.date_range,
                      hintText: 'Start',
                    ),
                  ),
                  const create_school_screen.SizedBox(
                    width: MySizes.md,
                  ),
                  create_school_screen.Expanded(
                    child: MyBottomSheetDropdown(
                      optionsForChips: MyLists.monthOptions,
                      onSingleChanged: (val) {
                        controller.selectedAcademicYearEnd.value = val!;
                      },
                      labelText: 'Academic Year End',
                      prefixIcon: create_school_screen.Icons.date_range,
                      hintText: 'End',
                    ),
                  ),
                ],
              ),
              const create_school_screen.SizedBox(height: MySizes.lg),
              MyTextField(
                labelText: 'Number of Periods per Day',
                keyboardType: create_school_screen.TextInputType.number,
                controller: controller.periodsPerDayController,
                validator:
                RequiredValidator(errorText: 'This field is required').call,
                suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.timelapse),
              ),
              const create_school_screen.SizedBox(height: MySizes.lg,)
              ,
              const MyDottedLine(dashColor: MyColors.dividerColor,),
              const create_school_screen.SizedBox(height: MySizes.md,),
              create_school_screen.Column(
                crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
                children: [
                  create_school_screen.Text(
                    "School Timings",
                    style: create_school_screen.Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18, fontWeight: create_school_screen.FontWeight.w600),
                  ),
                  const create_school_screen.SizedBox(height: MySizes.md),
                  create_school_screen.Row(
                    children: [
                      create_school_screen.Expanded(
                        child: MyTimePickerField(
                          labelText: 'Start Time',
                          hintText: 'Start',
                          selectedTime: controller.startTime,
                          onTimeChanged: (time) {
                            controller.startTime.value = time;
                            print("Start Time: $time");
                          },
                        ),
                      ),
                      const create_school_screen.SizedBox(width: MySizes.lg),
                      create_school_screen.Expanded(
                        child: MyTimePickerField(
                          labelText: 'End Time',
                          hintText: 'End',
                          selectedTime: controller.endTime,
                          onTimeChanged: (time) {
                            controller.endTime.value = time;
                            print("End Time: $time");
                          },
                        ),
                      ),
                    ],
                  ),
                  // End Time
                  const create_school_screen.SizedBox(height: MySizes.lg),
                  create_school_screen.Row(
                    children: [
                      create_school_screen.Expanded(
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
                      const create_school_screen.SizedBox(width: MySizes.lg),
                      create_school_screen.Expanded(
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
                  const create_school_screen.SizedBox(height: MySizes.lg),
                  create_school_screen.Row(
                    children: [
                      create_school_screen.Expanded(
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
                      const create_school_screen.SizedBox(width: MySizes.lg),
                      create_school_screen.Expanded(
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
              const create_school_screen.SizedBox(height: MySizes.md,)
              ,
              const MyDottedLine(dashColor: MyColors.dividerColor,),
              const create_school_screen.SizedBox(height: MySizes.md,),

            ],
          ),
        ),
      ),
    );
  }

  create_school_screen.Widget _buildAdministrativeInformationStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
      child: create_school_screen.Form(
        child: create_school_screen.Column(
          crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
          children: [


            MyBottomSheetDropdown(
              optionsForChips: MyLists.gradingSystemOptions,
              onSingleChanged: (val) {
                controller.selectedGradingSystem.value = val!;
              },
              labelText: 'Grading System',
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.examPatternOptions,
              onSingleChanged: (val) {
                controller.selectedExaminationPattern.value = val!;
              },
              labelText: 'Examination Pattern',
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),

            MyBottomSheetDropdown(
              optionsForChips: MyLists.academicLevelOptions,
              onSingleChanged: (val) {
                controller.selectedAcademicLevel.value = val!;
              },
              labelText: 'Academic Level',
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),
            MyBottomSheetDropdown(
              optionsForChips: MyLists.mediumOfInstructionOptions,
              onSingleChanged: (val) {
                controller.selectedMediumOfInstruction.value = val!;
              },
              labelText: 'Medium of Instruction',
            ),
          ],
        ),
      ),
    );
  }

  create_school_screen.Widget _buildBrandingSetupStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
      child: create_school_screen.Form(
        child: Obx(() => create_school_screen.Column(
          crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
          children: [
            /// **School Logo Picker**
            MyImagePickerField(
              image: controller.schoolLogoImage.value,
              onImageSelected: (File value) {
                controller.schoolLogoImage.value = value;
              },
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),

            /// **School Cover Image Picker**
            MyImagePickerField(
              image: controller.schoolCoverImage.value,
              onImageSelected: (File value) {
                controller.schoolCoverImage.value = value;
              },
            ),
            const create_school_screen.SizedBox(height: MySizes.lg),

            /// **Display Selected Images Grouped by Place Name**
            if (controller.schoolGallery.isNotEmpty) ...[
              const create_school_screen.Text(
                "School Gallery",
                style: create_school_screen.TextStyle(fontSize: 18, fontWeight: create_school_screen.FontWeight.bold),
              ),
              const create_school_screen.SizedBox(height: MySizes.md),
              for (var schoolImage in controller.schoolGallery) ...[
                create_school_screen.Text(
                  schoolImage.placeName,
                  style: const create_school_screen.TextStyle(
                      fontSize: 16, fontWeight: create_school_screen.FontWeight.w600),
                ),
                create_school_screen.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: schoolImage.imageUrls
                      .map((imageUrl) => create_school_screen.ClipRRect(
                    borderRadius: create_school_screen.BorderRadius.circular(8),
                    child: create_school_screen.Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: create_school_screen.BoxFit.cover,
                    ),
                  ))
                      .toList(),
                ),
                const create_school_screen.SizedBox(height: MySizes.md),
              ],
            ],

            /// **Add School Images Button**
            create_school_screen.Align(
              alignment: create_school_screen.Alignment.center,
              child: create_school_screen.ElevatedButton.icon(
                onPressed: () => _showAddImageDialog(context),
                icon: const create_school_screen.Icon(create_school_screen.Icons.add_photo_alternate),
                label: const create_school_screen.Text("Add School Images"),
              ),
            ),
          ],
        )),
      ),
    );
  }

  create_school_screen.Widget _buildAuthenticationStep(create_school_screen.BuildContext context) {
    return create_school_screen.SingleChildScrollView(
      child: create_school_screen.Padding(
        padding: const create_school_screen.EdgeInsets.all(MySizes.lg),
        child: create_school_screen.Form(
          child: create_school_screen.Column(
            crossAxisAlignment: create_school_screen.CrossAxisAlignment.start,
            children: [
              MyTextField(
                labelText: 'Admin Phone Number',
                keyboardType: create_school_screen.TextInputType.phone,
                controller: controller.adminPhoneNoController,
                validator: null, // Optional validation
                suffixIcon: const create_school_screen.Icon(create_school_screen.Icons.phone),
              ),
              const create_school_screen.SizedBox(
                height: MySizes.lg,
              ),
              MyButton(text: 'Create New School', onPressed: () { controller.addSchoolToFirebase();}),
              const create_school_screen.SizedBox(
                height: MySizes.lg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Show Dialog to Enter Place Name**
  void _showAddImageDialog(create_school_screen.BuildContext context) {
    create_school_screen.TextEditingController placeNameController = create_school_screen.TextEditingController();

    Get.defaultDialog(
      title: "Enter Place Name",
      content: create_school_screen.Column(
        children: [
          create_school_screen.TextField(
            controller: placeNameController,
            decoration: const create_school_screen.InputDecoration(
              hintText: "E.g., Library, Playground",
              border: create_school_screen.OutlineInputBorder(),
            ),
          ),
          const create_school_screen.SizedBox(height: 16),
          create_school_screen.ElevatedButton(
            onPressed: () {
              String placeName = placeNameController.text.trim();
              if (placeName.isNotEmpty) {
                Get.back();
                controller.pickImages(placeName);
              } else {
                Get.snackbar("Error", "Please enter a place name.");
              }
            },
            child: const create_school_screen.Text("Select Images"),
          ),
        ],
      ),
    );
  }

  create_school_screen.Widget stepInfoRow(String text) {
    return create_school_screen.Padding(
      padding: const create_school_screen.EdgeInsets.all(8.0),
      child: create_school_screen.Row(
        children: [
          create_school_screen.CircleAvatar(
            radius: 5,
            backgroundColor: MyDynamicColors.activeBlue,
          ),
          const create_school_screen.SizedBox(
            width: MySizes.md,
          ),
          create_school_screen.Text(
            text,
            style: create_school_screen.Theme.of(Get.context!)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: create_school_screen.FontWeight.w500),
          ),
        ],
      ),
    );
  }
}