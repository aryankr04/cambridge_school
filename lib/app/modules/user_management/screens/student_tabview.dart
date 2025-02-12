import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../controllers/user_management_controller.dart';
import '../models/user_model.dart';
import '../widgets/user_card_widget.dart';

class UserTabView extends GetView<UserManagementController> {
  final String rosterType;
  final String title;
  final List<String> filterOptions;
  final RxList<UserModel> userList;
  final Future<void> Function() onSearchPressed;

  const UserTabView({
    Key? key,
    required this.rosterType,
    required this.title,
    required this.filterOptions,
    required this.userList,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:MySizes.md,left: MySizes.md,right: MySizes.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        controller.searchTerm.value = text;
                        print("term $text");
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: MySizes.md),
                  FilledButton(
                    onPressed: () async {
                      await onSearchPressed(); // Call the passed onSearchPressed function
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
              const SizedBox(height: MySizes.md),
              Obx(() => controller.selectedTabIndex.value == 0
                  ? Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: MyDropdownField(
                                options: MyLists.classOptions,
                                hintText: "Class",
                                onSelected: (value) {
                                  controller.className.value = value!;
                                },
                                selectedValue: controller.className,
                              ),
                            ),
                            const SizedBox(
                              width: MySizes.md,
                            ),
                            Expanded(
                              child: MyDropdownField(
                                options: MyLists.sectionOptions,
                                hintText: "Section",
                                onSelected: (value) {
                                  controller.sectionName.value = value!;
                                },
                                selectedValue: controller.sectionName,
                              ),
                            ),
                            const SizedBox(width: MySizes.md),
                            FilledButton(
                              onPressed: () async {
                                await controller.fetchStudents();
                              },
                              child: const Text('Search'),
                            ),
                          ],
                        ),
                        const SizedBox(height: MySizes.md),
                      ],
                    )
                  : const SizedBox.shrink()),

              Divider(thickness: 0.5,color: MyColors.borderColor,),
              const SizedBox(height: MySizes.sm),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      () {
                        switch (controller.selectedTabIndex.value) {
                          case 0:
                            return 'Students (${controller.studentList.length})';
                          case 1:
                            return 'Teachers (${controller.teacherList.length})';
                          case 2:
                            return 'Directors (${controller.directorList.length})';
                          case 3:
                            return 'Admins (${controller.adminList.length})';
                          case 4:
                            return 'Staff (${controller.staffList.length})';
                          case 5:
                            return 'Drivers (${controller.driverList.length})';
                          case 6:
                            return 'Security Guards (${controller.driverList.length})';
                          default:
                            return 'Unknown';
                        }
                      }(),
                      style: MyTextStyles.headlineSmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showFilterDialog(context);
                    },
                    child: const Text('Filter List'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(
          () => Expanded(
            child: controller.isLoading.value
                ? _buildShimmerLoading()
                : ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return UserCardWidget(
                        userProfile: userList[index],
                        onView: () {},
                        onEdit: () {},
                        onDelete: () {},
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          rosterType: rosterType,
          title: title,
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Container(
                        height: 12,
                        width: Get.width * 0.4,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// separate filter dialog as its own class
class FilterDialog extends StatefulWidget {
  final String rosterType;
  final String title;

  const FilterDialog({Key? key, required this.rosterType, required this.title})
      : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? selectedSortBy;
  String? selectedOrderBy;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserManagementController>();

    return AlertDialog(
      title: const Text(
        'Filter Options',
        style: MyTextStyles.headlineSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort By Options
          const Text(
            "Sort By",
            style: MyTextStyles.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Wrap(
            spacing: 8.0,
            children: controller
                .availableSortingFields[controller.selectedTabIndex.value]!
                .map((option) {
              return FilterChip(
                label: Text(option),
                selected: selectedSortBy == option,
                onSelected: (bool selected) {
                  setState(() {
                    selectedSortBy = selected ? option : null;
                  });
                },
                shape: RoundedRectangleBorder(
                  // Make chips fully rounded
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide.none, // Remove border by default
                backgroundColor:
                    Colors.grey.shade200, // Set a default background color
                selectedColor: Theme.of(context)
                    .primaryColor, // Use the theme's primary color for selected
                labelStyle: TextStyle(
                  color: selectedSortBy == option
                      ? Colors.white
                      : MyColors
                          .headlineTextColor, // Change text color when selected
                ),
              );
            }).toList(),
          ),

          // Order By Options
          const SizedBox(height: MySizes.lg),
          const Text(
            "Order By",
            style: MyTextStyles.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),

          Wrap(
            spacing: 8.0,
            children: ['Ascending', 'Descending'].map((option) {
              return FilterChip(
                label: Text(option),
                selected: selectedOrderBy == option,
                onSelected: (bool selected) {
                  setState(() {
                    selectedOrderBy = selected ? option : null;
                  });
                },
                shape: RoundedRectangleBorder(
                  // Make chips fully rounded
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: BorderSide.none, // Remove border by default
                backgroundColor:
                    Colors.grey.shade200, // Set a default background color
                selectedColor: Theme.of(context)
                    .primaryColor, // Use the theme's primary color for selected
                labelStyle: TextStyle(
                  color: selectedOrderBy == option
                      ? Colors.white
                      : MyColors
                          .headlineTextColor, // Change text color when selected
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: MySizes.sm,
          )
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(
              width: MySizes.md,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Apply Filter Logic Here
                  if (selectedSortBy != null) {
                    controller.sortListByField(selectedSortBy!);
                  }
                  if (selectedOrderBy != null) {
                    controller.isAscending.value =
                        selectedOrderBy == "Ascending";
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
