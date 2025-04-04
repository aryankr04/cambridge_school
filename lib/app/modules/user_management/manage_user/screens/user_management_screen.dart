import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cambridge_school/app/modules/user_management/manage_user/screens/user_tab_view.dart';
import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/theme/widget_themes/tab_bar_theme.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/controllers/user_management_controller.dart';

import '../models/roster_model.dart';

enum UserType { student, employee }

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
          elevation: 10,
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(kToolbarHeight), // Standard TabBar height
            child: TabBar(
              tabAlignment: TabAlignment.fill,
              indicatorColor: MyDynamicColors.activeBlue,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              labelStyle: MyTextStyle.bodyLarge
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              dividerColor: MyColors.dividerColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,

              // indicator: BoxDecoration(
              //   color: MyDynamicColors.activeBlue, // Change the color as needed
              //   borderRadius: BorderRadius.circular(8), // Rounded corners
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.2),
              //       blurRadius: 5,
              //       spreadRadius: 1,
              //       offset: const Offset(0, 3),
              //     ),
              //   ],
              // ),
              tabs: const [
                Tab(text: 'Students'),
                Tab(text: 'Employees'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => UserTabView(
                  rosterType: UserRosterType.studentRoster,
                  title: 'Students',
                  filterOptions: const ['Class', 'Section', 'Name'],
                  userList: controller.studentUserRoster.value?.userList ?? [],
                  onSearchPressed: () {}, // Call fetchStudents
                )),
            Obx(() => UserTabView(
                  rosterType: UserRosterType.employeeRoster,
                  title: 'Employees',
                  filterOptions: const ['Subject', 'Name', 'Experience'],
                  userList: controller.employeeUserRoster.value?.userList ?? [],
                  onSearchPressed: () {}, // Call fetchTeachers
                )),
          ],
        ),
      ),
    );
  }
}

// import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
// import 'package:cambridge_school/core/utils/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:cambridge_school/app/modules/user_management/manage_user/screens/user_tab_view.dart';
// import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
// import 'package:cambridge_school/core/utils/theme/widget_themes/tab_bar_theme.dart';
// import 'package:cambridge_school/app/modules/user_management/manage_user/controllers/user_management_controller.dart';
//
// import '../models/roster_model.dart';
//
// enum UserType { student, employee }
//
// class UserManagementScreen extends GetView<UserManagementController> {
//   const UserManagementScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'User Management',
//             style: Theme.of(context)
//                 .textTheme
//                 .headlineSmall
//                 ?.copyWith(color: Colors.white),
//           ),
//           backgroundColor: MyDynamicColors.activeBlue,
//           elevation: 5,
//         ),
//         body: Column(
//           children: [
//             // TabBar moved here, below the AppBar
//             Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: MyBoxShadows.kLightShadow
//               ),
//               child: TabBar(
//                 tabAlignment: TabAlignment.fill,
//                 indicatorColor: MyDynamicColors.activeBlue,
//                 unselectedLabelColor: Colors.black.withOpacity(0.5),
//                 labelColor: MyColors.headlineTextColor,
//                 dividerColor: MyColors.dividerColor,
//                 dividerHeight: 0.5,
//                 tabs: const [
//                   Tab(text: 'Students'),
//                   Tab(text: 'Employees'),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   Obx(() => UserTabView(
//                     rosterType: UserRosterType.studentRoster,
//                     title: 'Students',
//                     filterOptions: const ['Class', 'Section', 'Name'],
//                     userList: controller.studentUserRoster.value?.userList ?? [],
//                     onSearchPressed: () {}, // Call fetchStudents
//                   )),
//                   Obx(() => UserTabView(
//                     rosterType: UserRosterType.employeeRoster,
//                     title: 'Employees',
//                     filterOptions: const ['Subject', 'Name', 'Experience'],
//                     userList: controller.employeeUserRoster.value?.userList ?? [],
//                     onSearchPressed: () {}, // Call fetchTeachers
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
