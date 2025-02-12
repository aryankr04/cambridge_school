import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/divider.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/hostel_fee_structure_controller.dart';
import '../models/hostel_fee_structure_model.dart';

class HostelFeeStructureWidget extends StatelessWidget {
  final HostelFeeStructureController controller =
      Get.put(HostelFeeStructureController());

  HostelFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: MyDetailCard(
          title: 'Hostel Fee',
          titleStyle: Theme.of(context).textTheme.titleLarge,
          icon: Icons.app_registration,
          color: MyColors.activeOrange,
          hasSameBorderColor: true,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    children: controller.hostelPlanInputs
                        .asMap()
                        .map((index, hostelPlanInput) {
                          return MapEntry(
                            index,
                            _buildPlan(hostelPlanInput, index, context),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ),
                const SizedBox(height: MySizes.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Plan"),
                    onPressed: controller.addHostelPlanInput,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build each plan independently with its own state
  Widget _buildPlan(
      HostelPlanInput hostelPlanInput, int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPlanHeader(context, index),
        _buildPlanDetails(hostelPlanInput, context),
        const Divider(height: MySizes.lg, color: MyColors.activeOrange),
      ],
    );
  }

  // Plan header with delete option
  Widget _buildPlanHeader(BuildContext context, int index) {
    return Row(
      children: [
        Text(
          'Plan ${index + 1}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: MyDottedLine(
              dashLength: 4,
              dashGapLength: 4,
              lineThickness: 1,
              dashColor: Colors.grey,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => controller.removeHostelPlanInput(index),
        ),
      ],
    );
  }

  // Plan details including text fields and selection options
  Widget _buildPlanDetails(
      HostelPlanInput hostelPlanInput, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextField(
          height: 42,
          hintText: 'Plan Name',
          controller: hostelPlanInput.planNameController,
        ),
        const SizedBox(height: MySizes.lg),
        MyTextField(
          height: 42,
          hintText: 'Fee',
          controller: hostelPlanInput.feeController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: MySizes.lg),
        Row(
          children: [
            Expanded(
              child: MyDropdownField(
                height: 42,
                hintText: 'Room Type',
                labelText: 'Room Type',
                options: const ['Single', 'Double', 'Triple', 'Quadruple'],
                onSelected: (selectedValue) {
                  hostelPlanInput.roomType.value = selectedValue!;
                },
                selectedValue:  hostelPlanInput.roomType,
              ),
            ),
            const SizedBox(
              width: MySizes.lg,
            ),
            Expanded(
              child: MyDropdownField(
                height: 42,
                hintText: 'AC or Non-AC',
                labelText: 'AC or Non-AC',
                options: const [
                  'AC',
                  'Non-AC',
                ],
                onSelected: (selectedValue) {
                  hostelPlanInput.isAC.value = selectedValue == 'AC';
                },
                selectedValue: hostelPlanInput.isAC.value ? 'AC'.obs : 'Non-AC'.obs,
              ),
            ),
          ],
        ),

        const SizedBox(height: MySizes.lg),
        Row(
          children: [
            Expanded(
              child: MyDropdownField(
                height: 42,
                hintText: 'Meals Per Day',
                labelText: 'Meals Per Day',
                options: const ['1 Time', '2 Times', '3 Times', '4 Times'],
                onSelected: (selected) {
                  hostelPlanInput.timesOfMealsPerDay.value =
                      int.parse(selected!.split(' ')[0]);
                },
                selectedValue:
                    '${hostelPlanInput.timesOfMealsPerDay.value} Times'.obs,
              ),
            ),
            const SizedBox(
              width: MySizes.lg,
            ),
            Expanded(
              child: MyDropdownField(
                height: 42,
                hintText: 'Include Meals',
                labelText: 'Include Meals',
                options: const ['Yes', 'No'],
                onSelected: (selectedValue) {
                  hostelPlanInput.includesMeals.value = selectedValue == 'Yes';
                },
                selectedValue:
                    hostelPlanInput.includesMeals.value ? 'Yes'.obs : 'No'.obs,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: MySizes.md,
        ),
        MyDropdownField(
          height: 42,
          hintText: 'Include Non-Veg',
          labelText: 'Include Non-Veg',
          options: const ['Yes', 'No'],
          onSelected: (selectedValue) {
            hostelPlanInput.isVeg.value = selectedValue == 'No';
          },
          selectedValue: hostelPlanInput.isVeg.value ? 'No'.obs : 'Yes'.obs,
        ),
        const SizedBox(
          height: MySizes.md,
        ),
        // SchoolSelectionWidget(
        //   title: 'Room Type',
        //   items: const ['Single', 'Double', 'Triple', 'Quadruple'],
        //   selectedItem: hostelPlanInput.roomType.value,
        //   onSelectionChanged: (selectedValue) {
        //     hostelPlanInput.roomType.value = selectedValue!;
        //   },
        // ),
        // const SizedBox(height: SchoolSizes.lg),
        // SchoolSelectionWidget(
        //   title: 'AC or Non AC',
        //   items: const ['AC', 'Non AC'],
        //   selectedItem: hostelPlanInput.isAC.value ? 'AC' : 'Non AC',
        //   onSelectionChanged: (selectedValue) {
        //     hostelPlanInput.isAC.value = selectedValue == 'AC';
        //   },
        // ),
        // const SizedBox(height: SchoolSizes.lg),
        // SchoolSelectionWidget(
        //   title: 'Meals Per Day',
        //   items: const ['1 Time', '2 Times', '3 Times', '4 Times'],
        //   selectedItem: '${hostelPlanInput.timesOfMealsPerDay.value} Times',
        //   onSelectionChanged: (selected) {
        //     hostelPlanInput.timesOfMealsPerDay.value =
        //         int.parse(selected!.split(' ')[0]);
        //   },
        // ),
        // const SizedBox(height: SchoolSizes.lg),
        // SchoolSelectionWidget(
        //   title: 'Includes Meals',
        //   items: const ['Yes', 'No'],
        //   selectedItem: hostelPlanInput.includesMeals.value ? 'Yes' : 'No',
        //   onSelectionChanged: (selected) {
        //     hostelPlanInput.includesMeals.value = selected == 'Yes';
        //   },
        // ),
        // const SizedBox(height: SchoolSizes.lg),
        // SchoolSelectionWidget(
        //   title: 'Includes Non-Veg Meals',
        //   items: const [
        //     'Yes',
        //     'No',
        //   ],
        //   selectedItem: hostelPlanInput.isVeg.value ? 'No' : 'Yes',
        //   onSelectionChanged: (selected) {
        //     hostelPlanInput.isVeg.value = selected == 'No';
        //   },
        // ),
        // const SizedBox(height: SchoolSizes.lg),
        // // Multi-select for Available Facilities
        // SchoolSelectionWidget(
        //   title: 'Available Facilities',
        //   items: const [
        //     'Wi-Fi',
        //     'Heaters',
        //     'Laundry Services',
        //     'Housekeeping',
        //     '24/7 Security',
        //     'CCTV Surveillance',
        //     'Study Tables and Chairs',
        //     'Wardrobes',
        //     'Attached Bathrooms',
        //     'Shared Bathrooms',
        //     'Hot Water',
        //     'Gym',
        //     'Drinking Water Facility',
        //     'Power Backup',
        //     'Sports Facilities',
        //     'Library Access',
        //     'Parking Area',
        //     'Medical Assistance',
        //     'Kitchen Access',
        //     'Laundry Machines',
        //     'Transport Facility',
        //     'Personal Lockers',
        //     'Fire Safety Measures'
        //   ],
        //   selectedItems: hostelPlanInput.availableFacilities,
        //   onMultiSelectChanged: (selected) {
        //     hostelPlanInput.availableFacilities.value = List<String>.from(
        //         selected); // Update the list with selected items
        //   },
        //   isMultiSelect: true,
        // ),
      ],
    );
  }
}
