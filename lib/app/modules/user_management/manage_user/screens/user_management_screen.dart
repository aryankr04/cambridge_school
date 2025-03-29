// user_management_screen.dart
import 'package:cambridge_school/app/modules/user_management/manage_user/screens/user_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/tab_bar_theme.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/controllers/user_management_controller.dart';

import '../models/roster_model.dart';
enum UserType{
  student,
  employee
}
class UserManagementScreen extends GetView<UserManagementController> {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'User Management',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white),
          ),
          backgroundColor: MyDynamicColors.activeBlue,
          elevation: 5,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Theme(
              data: ThemeData(
                tabBarTheme: MyTabBarTheme.defaultTabBarTheme.copyWith(
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  tabAlignment: TabAlignment.start,
                ),
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                onTap: (index) {
                  controller.selectedTabIndex.value = index;
                },
                tabs: const [
                  Tab(
                    text: 'Students',
                  ),
                  Tab(
                    text: 'Employees',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          children: [
            Obx(() => UserTabView(
              rosterType: UserRosterType.studentRoster,
              title: 'Students',
              filterOptions: const ['Class', 'Section', 'Name'], // Add your student-specific filter options
              userList: controller.studentUserRoster.value?.userList ?? [],
              onSearchPressed: () {}, // Call fetchStudents
            )),
            Obx(() => UserTabView(
              rosterType: UserRosterType.employeeRoster,
              title: 'Employees',
              filterOptions: const ['Subject', 'Name', 'Experience'], // Add your teacher-specific filter options
              userList: controller.employeeUserRoster.value?.userList ?? [],
              onSearchPressed: () {}, // Call fetchTeachers
            )),

          ],
        ),
      ),
    );
  }
}