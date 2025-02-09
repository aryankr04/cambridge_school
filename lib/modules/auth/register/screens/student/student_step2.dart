import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/date_picker_field.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student_step2_controller.dart';

class StudentStep2Form extends StatelessWidget {
  const StudentStep2Form({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep2FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step2FormKey,
          child: Column(
            children: [
              // Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'School',
              //       style: Theme.of(context).textTheme.labelLarge?.copyWith(
              //             fontWeight: FontWeight.w500,
              //           ),
              //     )),
              // const SizedBox(
              //   height: SchoolSizes.sm,
              // ),
              // AutoCompleteTextField<Map<String, dynamic>>(
              //   key: GlobalKey(),
              //   controller: controller.step2SelectedSchoolController,
              //   clearOnSubmit: false,
              //   suggestions: controller.schoolList,
              //   itemFilter: (item, query) {
              //     return item["schoolName"]
              //         .toLowerCase()
              //         .contains(query.toLowerCase()); // Handle null query
              //   },
              //   itemSorter: (a, b) {
              //     return a["schoolName"].compareTo(b["schoolName"]);
              //   },
              //   itemSubmitted: (item) {
              //     controller.step2SelectedSchoolController.text = item["schoolId"];
              //   },
              //   itemBuilder: (context, item) {
              //     return Container(
              //       alignment: Alignment.centerLeft,
              //       padding: const EdgeInsets.all(SchoolSizes.sm),
              //       color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
              //       child: Row(
              //         children: [
              //           const SizedBox(
              //             width: SchoolSizes.md,
              //           ),
              //           Icon(
              //             Icons.school,
              //             color: SchoolDynamicColors.iconColor,
              //           ),
              //           const SizedBox(
              //             width: SchoolSizes.md + 8,
              //           ),
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 item['schoolName'] ?? '',
              //                 style: Theme.of(context).textTheme.bodyLarge,
              //               ),
              //               Text(
              //                 item['schoolId'] ?? '',
              //                 style: Theme.of(context).textTheme.bodySmall,
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              //   decoration: InputDecoration(
              //       hintStyle: Theme.of(context)
              //           .textTheme
              //           .bodyLarge
              //           ?.copyWith(color: SchoolDynamicColors.placeholderColor),
              //       hintText: 'School',
              //       // prefixIcon: Icon(
              //       //   Icons.search,
              //       //   color: SchoolDynamicColors.iconColor,
              //       // ),
              //       border: InputBorder.none,
              //       enabledBorder: const OutlineInputBorder().copyWith(
              //         borderRadius:
              //         BorderRadius.circular(SchoolSizes.inputFieldRadius),
              //         borderSide: BorderSide(
              //             width: 0,
              //             color:
              //             SchoolDynamicColors.backgroundColorWhiteDarkGrey),
              //       ),
              //       focusedBorder: const OutlineInputBorder().copyWith(
              //         borderRadius:
              //         BorderRadius.circular(SchoolSizes.inputFieldRadius),
              //         borderSide: BorderSide(
              //             width: 1.5, color: SchoolDynamicColors.primaryColor),
              //       ),
              //       filled: true,
              //       fillColor: SchoolDynamicColors.backgroundColorTintLightGrey,
              //       suffixIcon: IconButton(
              //         color: SchoolDynamicColors.iconColor,
              //         icon: controller.step2SelectedSchoolController.toString() == ''
              //             ? const Icon(Icons.search)
              //             : const Icon(Icons.close_rounded),
              //         onPressed: () {
              //           controller.step2SelectedSchoolController.clear();
              //         },
              //       )),
              //   textChanged: (query) {
              //     if (query.isNotEmpty) {
              //       // Fetch schools based on the query
              //       //controller.fetchSchools(query);
              //       // Filter the suggestions based on the query
              //       controller.schoolList.assignAll(controller.schoolList.where(
              //               (school) =>
              //           school["schoolName"] != null &&
              //               school["schoolName"]
              //                   .toLowerCase()
              //                   .contains(query.toLowerCase())));
              //     } else {
              //       // If the query is empty, fetch all schools
              //       //controller.fetchSchools(query);
              //     }
              //   },
              // ),
              const SizedBox(
                height: MySizes.lg,
              ),

              const SizedBox(height: MySizes.defaultSpace),
              Row(
                children: [
                  Expanded(
                    child: MyDropdownField(
                      options: MyLists.classOptions,
                      labelText: 'Class',
                      isValidate: true,
                      onSelected: (value) {
                        controller.selectedClass.value = value!;
                      },
                      selectedValue: controller.selectedClass,
                    ),
                  ),
                  const SizedBox(width: MySizes.defaultSpace),
                  Expanded(
                    child: MyDropdownField(
                      options: MyLists.sectionOptions,
                      labelText: 'Section',
                      isValidate: true,
                      onSelected: (value) {
                        controller.selectedSection.value = value!;
                      },
                      selectedValue: controller.selectedSection,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyTextField(
                labelText: 'Roll No',
                keyboardType: TextInputType.number,
                controller: controller.rollNoController,
                validator: MultiValidator([
                  RequiredValidator(errorText: ''),
                  RangeValidator(
                    min: 1,
                    max: 100,
                    errorText: 'Enter Valid Roll No.',
                  ),
                ]).call,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                options: MyLists.schoolHouseOptions,
                labelText: 'House/Team Allocation',
                isValidate: true,
                onSelected: (value) {
                  controller.selectedHouseOrTeam.value = value!;
                },
                selectedValue: controller.selectedHouseOrTeam,
              ),
              const SizedBox(
                height: MySizes.lg,
              ),
              MyDropdownField(
                options: MyLists.modeOfTransportOptions,
                labelText: 'Mode of Transport',
                isValidate: true,
                onSelected: (value) {
                  controller.selectedModeOfTransport.value = value!;
                },
                selectedValue: controller.selectedModeOfTransport,
              ),
              const SizedBox(
                height: MySizes.lg,
              ),
              controller.selectedModeOfTransport.value == 'School Transport'
                  ? MyDropdownField(
                options: MyLists.modeOfTransportOptions,
                labelText: "Vehicle No",
                isValidate: true,
                onSelected: (value) {
                  controller.selectedVehicleNo.value = value!;
                },
                selectedValue: controller.selectedVehicleNo,
              )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
