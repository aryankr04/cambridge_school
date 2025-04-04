import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/empty_state.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:cambridge_school/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/utils/constants/text_styles.dart';
import '../controllers/user_management_controller.dart';
import '../../create_user/models/user_model.dart';
import '../models/roster_model.dart';
import '../widgets/user_card_widget.dart';
import 'dart:async'; // Import for Timer

class UserTabView extends GetView<UserManagementController> {
  final UserRosterType rosterType;
  final String title;
  final List<String> filterOptions;
  final List<UserModel> userList;
  final VoidCallback onSearchPressed;

  const UserTabView({
    super.key, // Add Key? key for null safety
    required this.rosterType,
    required this.title,
    required this.filterOptions,
    required this.userList,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap the entire column with SingleChildScrollView
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: MySizes.md, left: MySizes.md, right: MySizes.md),
            child: Column(
              children: [
                const SizedBox(
                  height: MySizes.md,
                ),
                Obx(() => controller.selectedTabIndex.value == 0
                    ? Column(
                        children: [
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     MyBottomSheetDropdown(
                          //       optionsForChips: controller.classNameOptions,
                          //       onSingleChanged: (value) async {
                          //         controller.selectedClassName.value = value;
                          //         controller.extractSectionNames();
                          //       },
                          //       dropdownWidgetType: DropdownWidgetType.filter,
                          //       hintText: 'Class',
                          //       selectedValue: controller.selectedClassName,
                          //     ),
                          //     const SizedBox(
                          //       width: MySizes.md,
                          //     ),
                          //     MyBottomSheetDropdown(
                          //       optionsForChips: controller.sectionNameOptions,
                          //       onSingleChanged: (value) async {
                          //         controller.selectedSectionName.value = value;
                          //       },
                          //       dropdownWidgetType: DropdownWidgetType.filter,
                          //       hintText: 'Section',
                          //       selectedValue: controller.selectedSectionName,
                          //     ),
                          //     const SizedBox(width: MySizes.md),
                          //     Column(
                          //       children: [
                          //         FilledButton(
                          //           onPressed: () async {
                          //             await controller.fetchStudentUserRoster();
                          //           },
                          //           child: const Text('Search'),
                          //         ),
                          //         const SizedBox(
                          //           height: MySizes.md,
                          //         )
                          //       ],
                          //     ),
                          //
                          //   ],
                          // ),
                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: MyDropdownField(
                                  options: controller.classNameOptions,
                                  hintText: "Class",
                                  onSelected: (value) {
                                    controller.selectedClassName.value = value!;
                                    controller.extractSectionNames();
                                  },
                                  selectedValue: controller.selectedClassName,
                                ),
                              ),
                              const SizedBox(
                                width: MySizes.md,
                              ),
                              Expanded(
                                child: MyDropdownField(
                                  options:controller.sectionNameOptions,
                                  hintText: "Section",
                                  onSelected: (value) {
                                    controller.selectedSectionName.value = value!;
                                  },
                                  selectedValue: controller.selectedSectionName,
                                ),
                              ),
                              const SizedBox(width: MySizes.md),
                              FilledButton(
                                onPressed: () async {
                                  await controller.fetchStudentUserRoster();
                                },
                                child: const Text('Search'),
                              ),
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink()),
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: MyColors.dividerColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        () {
                          switch (controller.selectedTabIndex.value) {
                            case 0:
                              return 'Students (${controller.studentUserRoster.value?.userList.length ?? 0})';
                            case 1:
                              return 'Employees (${controller.employeeUserRoster.value?.userList.length ?? 0})';

                            default:
                              return 'Unknown';
                          }
                        }(),
                        style: MyTextStyle.headlineSmall,
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
                const SizedBox(
                  height: MySizes.sm,
                ),
              ],
            ),
          ),
          Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
                  child: InkWell(
                    onTap: () {
                      _showSearchDialog(
                          context, userList); // Show search dialog
                    },
                    child: IgnorePointer(
                      // Prevent text field interaction
                      child: MyTextField(
                        onTap: () {
                          _showSearchDialog(
                              context, userList); // Show search dialog
                        },
                        hintText: 'Search',
                      ),
                    ),
                  ),
                ),
                if (controller.isLoading.value)
                  _buildShimmerLoading()
                else if (userList.isEmpty)
                  const Center(
                      child: MyEmptyStateWidget(
                    type: EmptyStateType.noData,
                    message: 'No User Found',
                    svgSize: 200,
                  ))
                else
                  ListView.builder(
                    shrinkWrap:
                        true, // Important: Allow ListView to size itself within the Column
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the full-screen search dialog
  void _showSearchDialog(
      BuildContext context, List<UserModel> initialUserList) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SearchDialog(userList: initialUserList);
      },
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
        shrinkWrap:
            true, // Important: Allow ListView to size itself within the Column
        physics:
            const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
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
  final UserRosterType rosterType;
  final String title;

  const FilterDialog(
      {super.key, required this.rosterType, required this.title});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserManagementController>();

    return AlertDialog(
      title: const Text(
        'Filter Options',
        style: MyTextStyle.headlineSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyBottomSheetDropdown(
            labelText: 'Sort By',
            optionsForChips: controller
                .availableSortingFields[controller.selectedTabIndex.value]!,
            onSingleChanged: (value) {
              controller.selectedSortBy.value = value;
            },
            selectedValue: controller.selectedSortBy,
            dropdownWidgetType: DropdownWidgetType.choiceChip,
          ),
          MyBottomSheetDropdown(
            labelText: 'Order By',
            optionsForChips: const ['Ascending', 'Descending'],
            onSingleChanged: (value) {
              controller.selectedOrderBy.value = value;
            },
            selectedValue: controller.selectedOrderBy,
            dropdownWidgetType: DropdownWidgetType.choiceChip,
          ),
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
                  controller.sortListByField(controller.selectedSortBy.value);
                  controller.isAscending.value =
                      controller.selectedOrderBy.value == "Ascending";
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

// Full-screen search dialog
class SearchDialog extends StatefulWidget {
  final List<UserModel> userList;

  const SearchDialog({super.key, required this.userList});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> filteredUserList = []; // List to hold search results
  final _Debouncer _debouncer =
      _Debouncer(milliseconds: 500); // Adjust debounce duration as needed

  @override
  void initState() {
    super.initState();
    filteredUserList = List.from(widget.userList); // Initially, show all users
  }

  Future<void> filterSearchResults(String query) async {
    _debouncer.run(() async {
      if (query.isEmpty) {
        setState(() => filteredUserList = List.from(widget.userList));
        return;
      }

      try {
        final queryLower = query.toLowerCase();

        // Filter users whose name contains the query
        final filteredList = widget.userList.where((user) {
          final name = user.fullName?.toLowerCase() ?? "";
          final username = user.username.toLowerCase();
          return name.contains(queryLower); //|| username.contains(queryLower)
        }).toList();
        // Sort in dictionary order while prioritizing names that start with query
        filteredList.sort((a, b) {
          final aName = a.fullName?.toLowerCase() ?? "";
          final bName = b.fullName?.toLowerCase() ?? "";

          final aStarts = aName.startsWith(queryLower);
          final bStarts = bName.startsWith(queryLower);

          if (aStarts && !bStarts) return -1; // 'a' should come first
          if (!aStarts && bStarts) return 1; // 'b' should come first

          return aName.compareTo(bName); // Dictionary order
        });

        setState(() => filteredUserList = filteredList);
      } catch (e) {
        MySnackBar.showSuccessSnackBar("Error during search: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),

        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search User',
            hintStyle: MyTextStyle.placeholder,
            border: InputBorder.none,
            fillColor: Colors.white,

            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                filterSearchResults(''); // Clear the search
              },
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
              Get.back();
              },
            ),
          ),
          style: MyTextStyle.inputField,
          onChanged: (value) {
            filterSearchResults(value);
          },
        ),
      ),
      body: filteredUserList.isEmpty
          ? const Center(
              child: MyEmptyStateWidget(
              type: EmptyStateType.noData,
              message: 'No Data Found (Search Results)',
              svgSize: 300,
            ))
          : ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, index) {
                return UserCardWidget(
                  userProfile: filteredUserList[index],
                  onView: () {},
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            ),
    );
  }
}

// Debouncer class to delay execution of a function
class _Debouncer {
  final int milliseconds;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
