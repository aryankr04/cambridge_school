
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';

class ManageSchoolScreen extends StatelessWidget {
  const ManageSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Management Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        elevation: 2,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SchoolInformationSection(),
            SizedBox(height: 16),
            AcademicsSection(),
            SizedBox(height: 16),
            FacilitiesSection(),
            SizedBox(height: 16),
            AdministrationSection(),
            SizedBox(height: 16),
            SecurityAndTransportSection(),
            SizedBox(height: 16),
            OtherSections(),
          ],
        ),
      ),
    );
  }
}

class SchoolInformationSection extends StatelessWidget {
  const SchoolInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategory('General', [
          {'name': 'School Details', 'icon': Icons.assignment, 'color': MyColors.colorOrange},
          {'name': 'Featured News', 'icon': Icons.announcement, 'color': MyColors.colorPurple},

        ]),
        const SizedBox(height: 8),
        _buildCategory('Communication', [
        ]),
        const SizedBox(height: 8),
        _buildCategory('Recognition', [
          {'name': 'Awards', 'icon': Icons.emoji_events, 'color': MyColors.colorViolet},
          {'name': 'Accreditation', 'icon': Icons.verified, 'color': MyColors.activeBlue},
          {'name': 'Rankings', 'icon': Icons.leaderboard, 'color': MyColors.activeGreen},
        ]),
      ],
    );
  }
}

class AcademicsSection extends StatelessWidget {
  const AcademicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategory('Class Management', [
          {'name': 'Class', 'icon': Icons.class_, 'color': MyColors.activeOrange},
          {'name': 'Subject', 'icon': Icons.subject, 'color': MyColors.activeRed},
          {'name': 'Syllabus', 'icon': Icons.description, 'color': MyColors.colorOrange},
          {'name': 'Routine', 'icon': Icons.table_chart, 'color': MyColors.colorYellow},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Events', [
          {'name': 'School Calendar', 'icon': Icons.event_note, 'color': MyColors.colorGreen},
          {'name': 'Holiday', 'icon': Icons.holiday_village, 'color': MyColors.colorSkyBlue},
        ]),
      ],
    );
  }
}

class FacilitiesSection extends StatelessWidget {
  const FacilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategory('Infrastructure', [
          {'name': 'Classroom', 'icon': Icons.meeting_room, 'color': MyColors.colorBlue},
          {'name': 'Labs', 'icon': Icons.computer, 'color': MyColors.colorTeal},
          {'name': 'Library', 'icon': Icons.local_library, 'color': MyColors.colorPink},
          {'name': 'Playground', 'icon': Icons.sports_soccer, 'color': MyColors.colorRed},
          {'name': 'Medical Rooms', 'icon': Icons.medical_services, 'color': MyColors.colorPurple},
          {'name': 'Cafeteria', 'icon': Icons.restaurant, 'color': MyColors.colorViolet},
          {'name': 'Hostels', 'icon': Icons.hotel, 'color': MyColors.activeBlue},
          {'name': 'Staff Rooms', 'icon': Icons.workspaces, 'color': MyColors.activeGreen},
          {'name': 'Auditorium', 'icon': Icons.theaters, 'color': MyColors.activeOrange},
          {'name': 'Exam Halls', 'icon': Icons.event_seat, 'color': MyColors.activeRed},
          {'name': 'CCTV Cameras', 'icon': Icons.security, 'color': MyColors.colorBlue},

        ]),
      ],
    );
  }
}

class AdministrationSection extends StatelessWidget {
  const AdministrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategory('User Management', [
          {'name': 'User', 'icon': Icons.person_add, 'color': MyColors.colorOrange},
          {'name': 'Role', 'icon': Icons.manage_accounts, 'color': MyColors.colorYellow},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Finance', [
          {'name': 'Fee Structure', 'icon': Icons.request_quote, 'color': MyColors.colorGreen},
          {'name': 'Payroll', 'icon': Icons.payments, 'color': MyColors.colorSkyBlue},
        ]),
      ],
    );
  }
}

class SecurityAndTransportSection extends StatelessWidget {
  const SecurityAndTransportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategory('Security', [
          {'name': 'Security System', 'icon': Icons.security, 'color': MyColors.colorBlue},
          {'name': 'Attendance System', 'icon': Icons.fingerprint, 'color': MyColors.colorTeal},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Transport', [
          {'name': 'Vehicles', 'icon': Icons.local_shipping, 'color': MyColors.colorPink},
        ]),
      ],
    );
  }
}

class OtherSections extends StatelessWidget {
  const OtherSections({super.key});
 // New section for additional items
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategory('Academics & Learning', [
          {'name': 'Assignments & Homework', 'icon': Icons.assignment_turned_in, 'color': MyColors.colorOrange},
          {'name': 'Examinations', 'icon': Icons.fact_check, 'color': MyColors.colorYellow},
          {'name': 'Results & Report Cards', 'icon': Icons.assessment, 'color': MyColors.colorGreen},
          {'name': 'Learning Materials', 'icon': Icons.menu_book, 'color': MyColors.colorSkyBlue},
          {'name': 'Online Classes', 'icon': Icons.video_call, 'color': MyColors.colorBlue},
          {'name': 'Student Performance Analytics', 'icon': Icons.analytics, 'color': MyColors.colorTeal},
          {'name': 'Special Education', 'icon': Icons.accessibility_new, 'color': MyColors.colorPink},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Teacher & Staff Management', [
          {'name': 'Teacher Profiles', 'icon': Icons.badge, 'color': MyColors.colorRed},
          {'name': 'Staff Attendance', 'icon': Icons.calendar_today, 'color': MyColors.colorPurple},
          {'name': 'Leave Management', 'icon': Icons.beach_access, 'color': MyColors.colorViolet},
          {'name': 'Payroll & Salaries', 'icon': Icons.attach_money, 'color': MyColors.activeBlue},
          {'name': 'Training & Workshops', 'icon': Icons.school, 'color': MyColors.activeGreen},
          {'name': 'Staff Evaluations', 'icon': Icons.star, 'color': MyColors.activeOrange},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Student Life & Activities', [
          {'name': 'Clubs & Societies', 'icon': Icons.groups, 'color': MyColors.activeRed},
          {'name': 'Sports & Competitions', 'icon': Icons.sports_basketball, 'color': MyColors.colorOrange},
          {'name': 'Annual Day & Celebrations', 'icon': Icons.celebration, 'color': MyColors.colorYellow},
          {'name': 'School Trips & Excursions', 'icon': Icons.directions_bus, 'color': MyColors.colorGreen},
          {'name': 'Alumni Network', 'icon': Icons.people_alt, 'color': MyColors.colorSkyBlue},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Finance & Fees Management', [
          {'name': 'Fee Collection', 'icon': Icons.account_balance_wallet, 'color': MyColors.colorBlue},
          {'name': 'Scholarships & Grants', 'icon': Icons.card_giftcard, 'color': MyColors.colorTeal},
          {'name': 'Expense Tracking', 'icon': Icons.receipt_long, 'color': MyColors.colorPink},
          {'name': 'Budget & Financial Reports', 'icon': Icons.insert_chart, 'color': MyColors.colorRed},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Attendance & Records', [
          {'name': 'Biometric Attendance', 'icon': Icons.fingerprint, 'color': MyColors.colorPurple},
          {'name': 'Student Roll Call', 'icon': Icons.format_list_bulleted, 'color': MyColors.colorViolet},
          {'name': 'Daily Reports', 'icon': Icons.insert_drive_file, 'color': MyColors.activeBlue},
          {'name': 'Late & Absentee Records', 'icon': Icons.error_outline, 'color': MyColors.activeGreen},
        ]),
        const SizedBox(height: 8),
        _buildCategory('School Operations', [
          {'name': 'Timetable & Scheduling', 'icon': Icons.schedule, 'color': MyColors.activeOrange},
          {'name': 'Hostel Management', 'icon': Icons.house, 'color': MyColors.activeRed},
          {'name': 'Library Book Management', 'icon': Icons.library_books, 'color': MyColors.colorOrange},
          {'name': 'Cafeteria Menu & Orders', 'icon': Icons.restaurant_menu, 'color': MyColors.colorYellow},
          {'name': 'Lost & Found', 'icon': Icons.search, 'color': MyColors.colorGreen},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Parent & Student Communication', [
          {'name': 'Notice Board', 'icon': Icons.campaign, 'color': MyColors.colorSkyBlue},
          {'name': 'Messaging System', 'icon': Icons.message, 'color': MyColors.colorBlue},
          {'name': 'Parent-Teacher Meetings', 'icon': Icons.event, 'color': MyColors.colorTeal},
          {'name': 'Complaint & Feedback Box', 'icon': Icons.feedback, 'color': MyColors.colorPink},
        ]),
        const SizedBox(height: 8),
        _buildCategory('Security & Transport', [
          {'name': 'Live Bus Tracking', 'icon': Icons.directions_bus_filled, 'color': MyColors.colorRed},
          {'name': 'Visitor Logs', 'icon': Icons.perm_identity, 'color': MyColors.colorPurple},
          {'name': 'Emergency Alerts', 'icon': Icons.warning, 'color': MyColors.colorViolet},
          {'name': 'Discipline Management', 'icon': Icons.gavel, 'color': MyColors.activeBlue},
        ]),
        const SizedBox(height: 8),
        _buildCategory('IT & Digital Services', [
          {'name': 'Student ID & Smart Cards', 'icon': Icons.credit_card, 'color': MyColors.activeGreen},
          {'name': 'Website & Portal Management', 'icon': Icons.web, 'color': MyColors.activeOrange},
          {'name': 'E-Library & Online Resources', 'icon': Icons.computer, 'color': MyColors.activeRed},
          {'name': 'Cyber Safety & Policies', 'icon': Icons.lock, 'color': MyColors.colorOrange},
        ]),
      ],
    );
  }
}

// Reusable _buildCategory method
Widget _buildCategory(String title, List<Map<String, dynamic>> items) {
  return Padding(
    padding: const EdgeInsets.only(bottom: MySizes.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: MyColors.headlineTextColor,
          ),
        ),
        const SizedBox(height: MySizes.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildGridItem(item['name'], item['icon'], item['color'], context);
          },
        ),
      ],
    ),
  );
}

// Reusable _buildGridItem method
Widget _buildGridItem(String name, IconData icon, Color color, BuildContext context) {

  return LayoutBuilder(
    builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(constraints.maxWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: constraints.maxWidth * 0.25,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                textAlign: TextAlign.center,
                style: MyTextStyle.labelLarge.copyWith(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    },
  );
}