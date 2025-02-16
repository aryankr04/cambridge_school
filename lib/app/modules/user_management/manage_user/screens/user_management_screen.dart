// user_management_screen.dart
import 'package:cambridge_school/app/modules/user_management/manage_user/screens/user_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/tab_bar_theme.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/controllers/user_management_controller.dart';

class UserManagementScreen extends GetView<UserManagementController> {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
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
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  child: Theme(
                    data: ThemeData(
                      tabBarTheme: MyTabBarTheme.defaultTabBarTheme.copyWith(
                        indicatorColor: MyDynamicColors.activeBlue,
                        unselectedLabelColor: Colors.grey,
                        labelColor: MyDynamicColors.activeBlue,
                        dividerColor: MyDynamicColors.borderColor,
                        dividerHeight: 0.5,
                        splashFactory: NoSplash.splashFactory,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      onTap: (index) {
                        controller.changeTab(index);
                      },
                      tabs: const [
                        Tab(
                          text: 'Students',
                        ),
                        Tab(
                          text: 'Teachers',
                        ),
                        Tab(
                          text: 'Directors',
                        ),
                        Tab(
                          text: 'Admins',
                        ),
                        Tab(
                          text: 'Staff',
                        ),
                        Tab(
                          text: 'Drivers',
                        ),
                      ],
                    ),
                  ),
                ),
                pinned: true,
                floating: true,
              ),
            ];
          },
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
            children: [
              UserTabView(
                rosterType: 'student',
                title: 'Students',
                filterOptions: const ['Class', 'Section', 'Name'], // Add your student-specific filter options
                userList: controller.studentList,
                onSearchPressed: () => controller.fetchStudents(), // Call fetchStudents
              ),
              UserTabView(
                rosterType: 'teacher',
                title: 'Teachers',
                filterOptions: const ['Subject', 'Name', 'Experience'], // Add your teacher-specific filter options
                userList: controller.teacherList,
                onSearchPressed: () => controller.fetchTeachers(), // Call fetchTeachers
              ),
              UserTabView(
                rosterType: 'director',  // Director tab
                title: 'Directors',
                filterOptions: const ['School', 'Name'], // Add director-specific filter options
                userList: controller.directorList,
                onSearchPressed: () => controller.fetchDirectors(), // Call fetchDirectors
              ),
              UserTabView(
                rosterType: 'admin',
                title: 'Admins',
                filterOptions: const ['Role', 'Name'], // Add admin-specific filter options
                userList: controller.adminList,
                onSearchPressed: () => controller.fetchAdmins(), // Call fetchAdmins
              ),
              UserTabView(
                rosterType: 'staff',
                title: 'Staff',
                filterOptions: const ['Department', 'Name'], // Add staff-specific filter options
                userList: controller.staffList,
                onSearchPressed: () => controller.fetchStaff(), // Call fetchStaff
              ),
              UserTabView(
                rosterType: 'driver',  // Driver tab
                title: 'Drivers',
                filterOptions: const ['Route', 'Name'], // Add driver-specific filter options
                userList: controller.driverList,
                onSearchPressed: () => controller.fetchDrivers(),  // Call fetchDrivers
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sliver App Bar Delegate (Extracted for better organization)
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Theme child;

  const _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}