import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/label_chip.dart';
import '../../manage_school/models/school_model.dart';
import 'attendance_record_controller.dart';
import 'attendance_record_models.dart';
import '../mark_attendance/mark_attendance_screen.dart';

class AttendanceRecordScreen extends GetView<AttendanceRecordController> {
  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Record'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.10,
                  vertical: MySizes.spaceBtwSections),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MySizes.md),
                color: MyDynamicColors.backgroundColorTintDarkGrey,
              ),
              child: const TabBar(
                tabs: [
                  Tab(text: 'Class'),
                  Tab(text: 'User'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTab1Content(),
                  _buildTab2Content(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab1Content() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.errorMessage.value != null) {
        return Center(
          child: Text(
            'Error: ${controller.errorMessage.value!}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
          child: Column(
            children: [
              _buildInputRow(),
              Expanded(
                child: _buildClassList(),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildTab2Content() {
    return const Center(
      child: Text(
        'Tab 2 Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.getFormattedSelectedDate(),
          style:
              MyTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: MySizes.md,
        ),
        TextButton.icon(
          onPressed: () {},
          label: Text('Change Date'),
          icon: Icon(
            Icons.date_range,
            color: MyColors.activeBlue,
            size: 20,
          ),
        )
      ],
    );
  }

  Widget _buildClassList() {
    return ListView.builder(
      itemCount: controller.sections.length,
      itemBuilder: (context, index) {
        final section = controller.sections[index];
        final isTaken = controller.isAttendanceTakenForSection(
            section.className, section.sectionName);
        final summary = controller.getClassAttendanceSummary(
            section.className, section.sectionName);

        return ClassAttendanceSummaryCard(
          summary: summary,
          section: section,
          isTaken: isTaken,
          onTakeAttendance: (SectionData sectionData) {
            Get.to(() => MarkAttendanceScreen(
                  section: sectionData,
                  date: controller.selectedDate.value,
                  attendanceFor: controller.selectedAttendanceFor.value,
                ));
          },
        );
      },
    );
  }
}

class ClassAttendanceSummaryCard extends StatelessWidget {
  final ClassAttendanceSummary summary;
  final Function(SectionData) onTakeAttendance;
  final bool isTaken;
  final SectionData section;

  const ClassAttendanceSummaryCard({
    super.key,
    required this.summary,
    required this.onTakeAttendance,
    required this.isTaken,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isTaken ? MyDynamicColors.activeOrange : MyDynamicColors.activeGreen;
    final buttonText = isTaken ? 'Update' : 'Take';

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class ${summary.className} - ${summary.sectionName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.headlineTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'By: ${summary.markedBy.name} (${summary.markedBy.uid})',
                    style: MyTextStyles.labelMedium
                        .copyWith(color: MyColors.captionTextColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MyLabelChip(
                        text: 'Presents: ${summary.presents}',
                        color: MyColors.activeGreen,
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                      MyLabelChip(
                        text: 'Absents: ${summary.absents}',
                        color: MyColors.activeRed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onTakeAttendance(section),
              child: Container(
                width: Get.width * 0.2,
                padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  style: MyTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
