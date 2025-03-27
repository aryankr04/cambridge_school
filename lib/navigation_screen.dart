import 'package:cambridge_school/app/modules/dashboard/main_page/profile/profile.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/utils/helpers/helper_functions.dart';
import 'package:cambridge_school/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryHeader("School Management"),
              _buildButtonGrid([
                _buildNavButton('School Management', AppRoutes.manageSchoolRoute, Icons.settings),
                _buildNavButton('Profile', AppRoutes.manageSchoolRoute, Icons.settings),
                _buildNavButton('School List', AppRoutes.schoolListRoute, Icons.list),
                _buildNavButton('Create School', AppRoutes.createSchoolRoute, Icons.school),
              ]),
              _buildCategoryHeader("User Management"),
              _buildButtonGrid([
                _buildNavButton('Login', AppRoutes.loginRoute, Icons.login),
                _buildNavButton('Create User', AppRoutes.createUserRoute, Icons.person_add),
                _buildNavButton('User Management', AppRoutes.userManagementRoute, Icons.group),
              ]),
              _buildCategoryHeader("Attendance Management"),
              _buildButtonGrid([
                _buildNavButton('Mark Attendance', AppRoutes.markAttendanceRoute, Icons.check_circle),
                _buildNavButton('Attendance Record', AppRoutes.attendanceRecordRoute, Icons.list_alt),
                _buildNavButton('Attendance Report', AppRoutes.attendanceReportRoute, Icons.report),
              ]),
              _buildCategoryHeader("Leave Management"),
              _buildButtonGrid([
                _buildNavButton('Apply Leave', AppRoutes.applyLeaveRoute, Icons.event_note),
                _buildNavButton('Leave Dashboard', AppRoutes.leaveDashboardRoute, Icons.dashboard),
                _buildNavButton('Leave Request', AppRoutes.leaveRequestRoute, Icons.pending_actions),
              ]),
              _buildCategoryHeader("Other"),
              _buildButtonGrid([
                _buildNavButton('Onboarding', AppRoutes.onboardingRoute, Icons.explore),
                _buildNavButton('Class Management', AppRoutes.classManagementRoute, Icons.class_),
                _buildNavButton('Create Routine', AppRoutes.createRoutineRoute, Icons.pending_actions),
                _buildNavButton('Create Notice', AppRoutes.createNoticeRoute, Icons.add_alert),
                _buildNavButton('Notice', AppRoutes.noticeScreenRoute, Icons.notifications),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: MyTextStyle.titleLarge),
        const SizedBox(height: MySizes.xs),
      ],
    );
  }

  Widget _buildButtonGrid(List<Widget> buttons) {
    return Column(
      children: [
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: buttons,
        ),
        const SizedBox(height: MySizes.lg,)
      ],
    );
  }

  Widget _buildNavButton(String label, String route, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        backgroundColor: Colors.blueAccent,
      ),
      onPressed: () => Get.toNamed(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(height: MySizes.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}