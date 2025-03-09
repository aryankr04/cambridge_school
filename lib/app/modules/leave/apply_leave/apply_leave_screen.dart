import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../leave_model.dart';
import 'apply_leave_controller.dart';

class ApplyLeaveScreen extends StatelessWidget {
  const ApplyLeaveScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final ApplyLeaveController controller = Get.find<ApplyLeaveController>();
    final LeaveModel? leave = controller.leave.value; // Getting leave here

    // Populate data if in edit mode
    if (leave != null) {
      controller.selectedLeaveType.value = leave.leaveType;
      controller.startDate.value = leave.startDate;
      controller.endDate.value = leave.endDate;
      controller.reasonController.text = leave.reason;
    } else {
      print('Leave is null');
      print(leave?.leaveType ?? 'Af');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(leave == null ? 'Apply for Leave' : 'Edit Leave'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            children: [
              MyDropdownField(
                options: MyLists.leaveTypes(),
                labelText: 'Leave Type',
                onSelected: (newValue) {
                  controller.selectedLeaveType.value = newValue;
                },
                selectedValue: controller.selectedLeaveType,
              ),
              MyDatePickerField(
                labelText: 'Start Date',
                selectedDate: controller.startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (newDate) {
                  controller.startDate.value = newDate;
                },
              ),
              MyDatePickerField(
                labelText: 'End Date',
                selectedDate: controller.endDate,
                firstDate: controller.startDate.value ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (newDate) {
                  controller.endDate.value = newDate;
                },
              ),
              MyTextField(
                labelText: 'Reason',
                maxLines: 3,
                controller: controller.reasonController,
              ),
              const SizedBox(height: 20),
              MyButton(
                  onPressed: () {
                    if (leave != null) {
                      // Call addLeaveToFirestore with the leave ID to update
                      controller.addLeaveToFirestore(leaveIdToUpdate: leave.id);
                    } else {
                      controller.addLeaveToFirestore();
                    }
                  },
                  text: leave == null ? 'Apply' : 'Update'),
            ],
          ),
        ),
      ),
    );
  }
}
