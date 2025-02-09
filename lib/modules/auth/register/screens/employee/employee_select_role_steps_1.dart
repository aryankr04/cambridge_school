import 'package:cambridge_school/core/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/sizes.dart';

class EmployeeSelectRolesController extends GetxController {
  RxList<String> selectedRoles = <String>[].obs;
}

class EmployeeSelectRoles extends StatelessWidget {
  final EmployeeSelectRolesController controller;

  const EmployeeSelectRoles({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            children: [
              MySelectionWidget(
                spacing: MySizes.md,
                items: MyLists.schoolStaffRoles,
                isMultiSelect: true,
                selectedItem: controller.selectedRoles.isNotEmpty
                    ? controller.selectedRoles.first
                    : null,
                onMultiSelectChanged: (List<String> selectedItems) {
                  controller.selectedRoles.assignAll(selectedItems);
                },
                selectionWidgetType: SelectionWidgetType.icon,
                content: const Icon(
                  Icons.account_circle_sharp,
                  color: MyColors.activeBlue,
                  size: 48,
                ),
              ),
            ],
          )),
    );
  }
}
