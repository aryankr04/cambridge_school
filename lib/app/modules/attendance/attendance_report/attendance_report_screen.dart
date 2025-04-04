import 'dart:math' as math;

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/utils/formatters/date_time_formatter.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/date_picker_field.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/empty_state.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:cambridge_school/core/widgets/shimmer_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/utils/constants/enums/attendance_status.dart';
import '../../user_management/manage_user/models/roster_model.dart';
import '../mark_attendance/user_attendance_model.dart';
import 'attendance_calendar_widget.dart';
import 'attendance_report_controller.dart';

class AttendanceReportScreen extends GetView<AttendanceReportController> {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
      ),
      backgroundColor: MyColors.lightGrey,
      body: Obx(
        () => controller.isLoading.value
            ? const SingleChildScrollView(
                padding: EdgeInsets.all(MySizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Shimmer
                    MyShimmers(
                      text: 'Loading Calendar...',
                      height: 150,
                      itemPadding: EdgeInsets.only(bottom: MySizes.md),
                    ),

                    // Summary Dashboard Shimmer
                    MyShimmers(
                      text: 'Loading Summary...',
                      height: 150,
                      itemPadding: EdgeInsets.only(bottom: MySizes.lg),
                    ),

                    // Bar Chart Shimmer
                    MyShimmers(
                      text: 'Loading Bar Chart...',
                      height: 150,
                      itemPadding: EdgeInsets.only(bottom: MySizes.lg),
                    ),

                    // Comparison Card Shimmer
                    MyShimmers(
                      text: 'Loading Comparison...',
                      height: 150,
                      itemPadding: EdgeInsets.only(bottom: MySizes.lg),
                    ),

                    // Rank Overview Card Shimmer
                    MyShimmers(
                      text: 'Loading Rank...',
                      height: 150,
                      itemPadding: EdgeInsets.only(bottom: MySizes.lg),
                    ),

                    // Streak Card Shimmer
                    MyShimmers(
                      text: 'Loading Streaks...',
                      height: 150,
                      itemPadding: EdgeInsets.only(bottom: MySizes.lg),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => MyAttendanceCalendar(
                        userAttendance: controller.userAttendanceData.value,
                        onMonthChanged: controller.setSelectedMonth,
                      ),
                    ),
                    const SizedBox(height: MySizes.lg),
                    AttendanceSummaryDashboard(controller: controller),
                    const SizedBox(height: MySizes.lg),
                    const MonthlyAttendanceBarChart(),
                    const SizedBox(height: MySizes.lg),
                    StudentAverageComparisonCard(controller: controller),
                    const SizedBox(height: MySizes.lg),
                    StudentRankOverviewCard(controller: controller),
                    const SizedBox(height: MySizes.lg),
                    AttendanceStreakCard(controller: controller),
                  ],
                ),
              ),
      ),
    );
  }
}

class AttendanceStreakCard extends StatelessWidget {
  AttendanceStreakCard({super.key, required this.controller});

  final AttendanceReportController controller;
  final RxBool _isExpanded = false.obs; // For "Show More/Less" functionality
  final int initialStreakCount = 10; // Show 10 streaks initially

  @override
  Widget build(BuildContext context) {
    return MyCard(
      hasShadow: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: MySizes.md,
                right: MySizes.md,
                top: MySizes.md,
                bottom: MySizes.sm),
            child: Column(
              children: [
                HeadingForCard(
                    controller: controller, heading: 'Attendance Streaks'),
                const SizedBox(
                  height: MySizes.md,
                ),
                Obx(
                  () => Align(
                    alignment: Alignment.centerLeft,
                    child: MyBottomSheetDropdown(
                      optionsForChips: const [
                        'Present',
                        'Absent',
                        'Late',
                        'Excused',
                      ],
                      onSingleChanged: (String? value) {
                        if (value != null) {
                          controller.selectedStatus.value =
                              AttendanceStatus.fromLabel(value);
                        }
                      },
                      selectedValue: controller.selectedStatus.value.label.obs,
                      dropdownWidgetType: DropdownWidgetType.choiceChip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: MyColors.borderColor,
            thickness: 0.5,
            height: 1,
          ),
          Obx(() {
            final summary = controller.userAttendanceSummary.value;
            final selectedStatus = controller.selectedStatus.value;

            if (summary == null) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Or any other loading indicator
            }

            AttendanceStreakList streaks;
            switch (selectedStatus) {
              case AttendanceStatus.present:
                streaks = summary.presentStreaks;
                break;
              case AttendanceStatus.absent:
                streaks = summary.absentStreaks;
                break;
              case AttendanceStatus.late:
                streaks = summary.lateStreaks;
                break;
              case AttendanceStatus.excused:
                streaks = summary.excusedStreaks;
                break;
              default:
                streaks = AttendanceStreakList(
                    streaks: [],
                    type: AttendanceStatus.present); // Empty list if default
            }

            if (streaks.streaks.isEmpty) {
              return const MyEmptyStateWidget(
                  type: EmptyStateType.noData,
                  message: 'No streaks to display.');
            }

            //Determine display limit
            final displayLimit =
                _isExpanded.value ? streaks.streaks.length : initialStreakCount;
            final displayedStreaks =
                streaks.streaks.take(displayLimit).toList();

            return Column(
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(displayedStreaks.length, (index) {
                    final streak = displayedStreaks[index];
                    return Column(
                      children: [
                        StreakItem(streak: streak),
                        if (index != displayLimit - 1)
                          const Divider(
                            color: MyColors.borderColor,
                            thickness: 0.5,
                            height: 1,
                          ),
                      ],
                    );
                  }),
                ),
                if (streaks.streaks.length > initialStreakCount)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _isExpanded.value = !_isExpanded.value;
                      },
                      child: Text(
                        _isExpanded.value ? 'See Less' : 'See All',
                        style: const TextStyle(color: MyColors.activeBlue),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class StudentAverageComparisonCard extends StatelessWidget {
  const StudentAverageComparisonCard({
    super.key,
    required this.controller,
  });

  final AttendanceReportController controller;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      hasShadow: true,
      padding: const EdgeInsets.all(MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingForCard(controller: controller, heading: 'You Vs Class'),
          const SizedBox(height: MySizes.md),
          Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: MyBottomSheetDropdown(
                optionsForChips: const [
                  'Present',
                  'Absent',
                  'Late',
                  'Excused',
                ],
                onSingleChanged: (value) {
                  controller.selectedStatus.value =
                      AttendanceStatus.fromLabel(value);
                },
                selectedValue: controller.selectedStatus.value.label.obs,
                dropdownWidgetType: DropdownWidgetType.choiceChip,
              ),
            ),
          ),
          Obx(() {
            // Access rosterAverageAttendanceSummary from the controller
            final rosterAverageAttendanceSummary =
                controller.rosterAverageAttendanceSummary.value;
            final userAttendanceSummary =
                controller.userAttendanceSummary.value;

            // Check if rosterAverageAttendanceSummary is null to prevent errors
            if (rosterAverageAttendanceSummary == null ||
                userAttendanceSummary == null) {
              return const Center(child: Text("No data available"));
            }

            // Determine which percentage to use based on the selected status
            double studentAttendancePercentage;
            double classAveragePercentage;

            switch (controller.selectedStatus.value) {
              case AttendanceStatus.present:
                studentAttendancePercentage =
                    userAttendanceSummary.presentPercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.presentPercentage;
                break;
              case AttendanceStatus.absent:
                studentAttendancePercentage =
                    userAttendanceSummary.absentPercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.absentPercentage;
                break;
              case AttendanceStatus.late:
                studentAttendancePercentage =
                    userAttendanceSummary.latePercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.latePercentage;
                break;
              case AttendanceStatus.excused:
                studentAttendancePercentage =
                    userAttendanceSummary.excusedPercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.excusedPercentage;
                break;
              default:
                studentAttendancePercentage = 0.0;
                classAveragePercentage = 0.0;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildAverageBox(
                    context,
                    "Your",
                    studentAttendancePercentage,
                    MyColors.activeGreen,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CircleAvatar(
                    backgroundColor: MyColors.activeRed.withOpacity(0.1),
                    child: Text(
                      'VS',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildAverageBox(
                    context,
                    "Class Average",
                    classAveragePercentage,
                    MyColors.activeBlue,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Obx(() {
            final rosterAverageAttendanceSummary =
                controller.rosterAverageAttendanceSummary.value;
            final userAttendanceSummary =
                controller.userAttendanceSummary.value;

            if (rosterAverageAttendanceSummary == null ||
                userAttendanceSummary == null) {
              return const SizedBox.shrink(); // Or any placeholder you'd like
            }

            double studentAttendancePercentage;
            double classAveragePercentage;

            switch (controller.selectedStatus.value) {
              case AttendanceStatus.present:
                studentAttendancePercentage =
                    userAttendanceSummary.presentPercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.presentPercentage;
                break;
              case AttendanceStatus.absent:
                studentAttendancePercentage =
                    userAttendanceSummary.absentPercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.absentPercentage;
                break;
              case AttendanceStatus.late:
                studentAttendancePercentage =
                    userAttendanceSummary.latePercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.latePercentage;
                break;
              case AttendanceStatus.excused:
                studentAttendancePercentage =
                    userAttendanceSummary.excusedPercentage;
                classAveragePercentage =
                    rosterAverageAttendanceSummary.excusedPercentage;
                break;
              default:
                studentAttendancePercentage = 0.0;
                classAveragePercentage = 0.0;
            }

            return Row(
              children: [
                Icon(
                  studentAttendancePercentage >= classAveragePercentage
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: studentAttendancePercentage >= classAveragePercentage
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  "Difference: ${studentAttendancePercentage >= classAveragePercentage ? '+ ${(studentAttendancePercentage - classAveragePercentage).toStringAsFixed(2)}%' : '${(studentAttendancePercentage - classAveragePercentage).toStringAsFixed(2)}%'} vs Class",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAverageBox(
      BuildContext context, String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: MySizes.md,
        horizontal: MySizes.md,
      ),
      margin: const EdgeInsets.symmetric(horizontal: MySizes.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 36,
            lineWidth: 6.0,
            percent: value / 100,
            center: Text(
              '${value.toStringAsFixed(2)}%',
              style:
                  MyTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            progressColor: color,
            backgroundColor: color.withOpacity(0.3),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: MySizes.md),
          Text(
            label,
            style: MyTextStyle.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StudentRankOverviewCard extends StatelessWidget {
  StudentRankOverviewCard({super.key, required this.controller});

  final AttendanceReportController controller;
  final RxBool _isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      padding: const EdgeInsets.all(MySizes.md),
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingForCard(controller: controller, heading: 'Rank Overview'),
          const SizedBox(height: MySizes.md),
          Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: MyBottomSheetDropdown(
                optionsForChips: const [
                  'Present',
                  'Absent',
                  'Late',
                  'Excused',
                ],
                onSingleChanged: (value) {
                  controller.selectedStatus.value =
                      AttendanceStatus.fromLabel(value);
                },
                selectedValue: controller.selectedStatus.value.label.obs,
                dropdownWidgetType: DropdownWidgetType.choiceChip,
              ),
            ),
          ),
          Obx(() {
            final selectedStatus = controller.selectedStatus.value;
            final rosterAverageAttendanceSummary =
                controller.rosterAverageAttendanceSummary.value;

            //Early return null if null
            if (rosterAverageAttendanceSummary == null) {
              return const SizedBox.shrink();
            }

            // Extract user summaries and sort based on selected status
            final userSummaries =
                rosterAverageAttendanceSummary.userAverageAttendanceSummaryList;

            if (userSummaries.isEmpty) {
              return const Center(
                  child: MyEmptyStateWidget(
                      type: EmptyStateType.noData,
                      message: 'No Users available!'));
            }

            // Sort the user summaries based on the selected status
            final sortedSummaries =
                List<UserAverageAttendanceSummary>.from(userSummaries);
            sortedSummaries.sort((a, b) {
              final percentageA = getAveragePercentage(a, selectedStatus);
              final percentageB = getAveragePercentage(b, selectedStatus);
              return percentageB.compareTo(percentageA);
            });

            // Get the top rank percentage
            double topRankPercentage = 0.0;
            if (sortedSummaries.isNotEmpty) {
              topRankPercentage =
                  getAveragePercentage(sortedSummaries.first, selectedStatus);
            }

            // Find the user's average summary
            final userSummary = sortedSummaries.firstWhereOrNull(
                (element) => element.userId == controller.userId.value);

            // Calculate user's rank
            int userRank = 0;
            if (userSummary != null) {
              final userPercentage =
                  getAveragePercentage(userSummary, selectedStatus);
              userRank = calculateRank(
                  sortedSummaries, userPercentage, selectedStatus);
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRankBox(
                  context,
                  "Your Rank",
                  userRank,
                  userSummary != null
                      ? getAveragePercentage(userSummary, selectedStatus)
                      : 0.0,
                  Colors.blueAccent,
                ),
                _buildRankBox(
                  context,
                  "Top Rank",
                  1,
                  topRankPercentage,
                  Colors.orangeAccent,
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          const Text(
            "Rank Breakdown",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Obx(() {
            final selectedStatus = controller.selectedStatus.value;
            final rosterAverageAttendanceSummary =
                controller.rosterAverageAttendanceSummary.value;

            //If null return
            if (rosterAverageAttendanceSummary == null) {
              return const SizedBox.shrink();
            }

            // Extract user summaries
            final userSummaries =
                rosterAverageAttendanceSummary.userAverageAttendanceSummaryList;

            // Sort user summaries based on selected status
            final sortedSummaries =
                List<UserAverageAttendanceSummary>.from(userSummaries);
            sortedSummaries.sort((a, b) {
              final percentageA = getAveragePercentage(a, selectedStatus);
              final percentageB = getAveragePercentage(b, selectedStatus);
              return percentageB.compareTo(percentageA);
            });

            return Column(
              children: _buildRankDistributionRows(
                context,
                sortedSummaries,
                selectedStatus,
              ),
            );
          }),
        ],
      ),
    );
  }

  int calculateRank(
      List<UserAverageAttendanceSummary> sortedSummaries,
      double userPercentage,
      AttendanceStatus selectedStatus,
      ) {
    int rank = 1;

    for (int i = 0; i < sortedSummaries.length; i++) {
      final percentage = getAveragePercentage(sortedSummaries[i], selectedStatus);

      if (percentage > userPercentage) {
        rank++;
      } else {
        break; // Stop when the user's percentage is found or passed
      }
    }

    return rank;
  }

  double getAveragePercentage(
      UserAverageAttendanceSummary userSummary, AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return userSummary.presentPercentage;
      case AttendanceStatus.absent:
        return userSummary.absentPercentage;
      case AttendanceStatus.late:
        return userSummary.latePercentage;
      case AttendanceStatus.excused:
        return userSummary.excusedPercentage;
      default:
        return 0.0;
    }
  }

  Widget _buildRankBox(BuildContext context, String label, int rank,
      double percentage, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        children: [
          Text(
            rank == 1 ? '👑' : '🏅',
            style: const TextStyle(
              fontSize: 28,
            ),
          ),
          const SizedBox(width: MySizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$label: $rank${_getRankSuffix(rank)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${percentage.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRankSuffix(int rank) {
    if (rank == 1) {
      return 'st';
    } else if (rank == 2) {
      return 'nd';
    } else if (rank == 3) {
      return 'rd';
    } else {
      return 'th';
    }
  }

  Color _getRankColor(String rank) {
    final rankInt = int.tryParse(rank) ?? 0;
    if (rankInt == 1) {
      return Colors.green;
    } else if (rankInt == 2) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  List<Widget> _buildRankDistributionRows(
    BuildContext context,
    List<UserAverageAttendanceSummary> rankingList,
    AttendanceStatus selectedStatus,
  ) {
    // Define the limit for initial display (top 3)
    final topRanks = rankingList.take(3).toList();

    // Determine the limit for the rows based on expansion state
    final limit = _isExpanded.value ? rankingList.length : topRanks.length;
    int currentRank = 0;
    double previousPercentage = -1.0;
    int rankIncrement = 1;

    final rankDistributionRows = <Widget>[];

    for (var i = 0; i < limit; i++) {
      final student = rankingList[i];
      final name = student.userName;
      final id = student.userId;
      final rollNo = student.rollNo;
      final percentage = getAveragePercentage(student, selectedStatus);

      if (percentage != previousPercentage) {
        currentRank += rankIncrement;
        rankIncrement = 1;
      } else {
        rankIncrement++;
      }

      previousPercentage = percentage;

      final rank = currentRank.toString();
      final color = _getRankColor(rank);

      rankDistributionRows.add(_buildRankDistributionRow(context, name, id,
          rank, percentage.toStringAsFixed(1), color, rollNo));
    }

    // Add "See All" / "See Less" button if the list is longer than the initial limit
    if (rankingList.length > topRanks.length) {
      rankDistributionRows.add(
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => GestureDetector(
              onTap: () => _isExpanded.value = !_isExpanded.value,
              child: Text(
                _isExpanded.value ? 'See Less' : 'See All',
                style: const TextStyle(
                  color: MyColors.activeBlue,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return rankDistributionRows;
  }

  Widget _buildRankDistributionRow(BuildContext context, String name, String id,
      String rank, String percentage, Color color, String? rollNo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        color: controller.userId.value == id
            ? color.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Text(
                _getRankText(rank),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: color),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userId.value == id ? 'You' : name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    rollNo == null ? id : 'Roll No: $rollNo ($id)',
                    style: MyTextStyle.labelMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRankText(String rank) {
    switch (rank) {
      case '1':
        return "1st";
      case '2':
        return "2nd";
      case '3':
        return "3rd";
      default:
        return rank;
    }
  }
}

class StreakItem extends StatelessWidget {
  const StreakItem({super.key, required this.streak});

  final AttendanceStreak streak;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yy');
    final startDate = streak.start;
    final endDate = streak.end;
    final length = streak.length;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      child: Container(
        child: Row(
          children: [
            Text(
              '🔥   $length Days',
              style: MyTextStyle.bodyLarge,
            ),
            const SizedBox(width: MySizes.lg),
            Text(
              dateFormat.format(startDate),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(width: MySizes.md),
            const Expanded(
              child: MyDottedLine(
                dashColor: MyColors.dividerColor,
                lineThickness: 2,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: MyColors.dividerColor,
              size: 12,
            ),
            const SizedBox(width: MySizes.md),
            const Text(
              '',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              dateFormat.format(endDate),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAttendanceSummaryCard extends StatelessWidget {
  const UserAttendanceSummaryCard({
    super.key,
    required this.status,
    required this.summary,
  });

  final AttendanceStatus status;
  final UserAttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    int count = _getStatusCount(status);
    double percentage = _getStatusPercentage(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12,
      ),
      margin: const EdgeInsets.symmetric(horizontal: MySizes.xs),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 34,
            lineWidth: 6.0,
            percent: percentage / 100,
            center: Text(
              percentage.toStringAsFixed(2),
              style:
                  MyTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            progressColor: status.color,
            backgroundColor: status.color.withOpacity(0.3),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: MySizes.xs),
          Text(
            '$count',
            style: MyTextStyle.bodyLarge,
          ),
          Text(
            status.label,
            style: MyTextStyle.bodyMedium.copyWith(height: 1),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getStatusCount(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return summary.presentCount;
      case AttendanceStatus.absent:
        return summary.absentCount;
      case AttendanceStatus.holiday:
        return summary.holidayCount;
      case AttendanceStatus.late:
        return summary.lateCount;
      case AttendanceStatus.excused:
        return summary.excusedCount;
      case AttendanceStatus.notApplicable:
        return summary.notApplicableCount;
      case AttendanceStatus.working:
        return summary.workingDaysCount;
    }
  }

  double _getStatusPercentage(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return summary.presentPercentage;
      case AttendanceStatus.absent:
        return summary.absentPercentage;
      case AttendanceStatus.holiday:
        return summary.holidayPercentage;
      case AttendanceStatus.late:
        return summary.latePercentage;
      case AttendanceStatus.excused:
        return summary.excusedPercentage;
      case AttendanceStatus.notApplicable:
        return summary.notApplicablePercentage;
      case AttendanceStatus.working:
        return summary.workingDaysPercentage;
    }
  }
}

class MonthlyAttendanceBarChart extends GetView<AttendanceReportController> {
  const MonthlyAttendanceBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userAttendanceSummary.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final monthlyAttendanceList =
          controller.userAttendanceSummary.value!.monthlyAttendance;
      final selectedStatus = controller.selectedStatus.value;

      // Prepare data for the chart
      List<BarChartGroupData> barGroups = [];
      int groupIndex = 0;
      const double barWidth = 6;

      for (final monthlyData in monthlyAttendanceList) {
        // Determine the count based on selected status
        double count;
        Color barColor;

        switch (selectedStatus) {
          case AttendanceStatus.present:
            count = monthlyData.presentCount.toDouble();
            barColor = AttendanceStatus.present.color;
            break;
          case AttendanceStatus.absent:
            count = monthlyData.absentCount.toDouble();
            barColor = AttendanceStatus.absent.color;
            break;
          case AttendanceStatus.late:
            count = monthlyData.lateCount.toDouble();
            barColor = AttendanceStatus.late.color;
            break;
          case AttendanceStatus.excused:
            count = monthlyData.excusedCount.toDouble();
            barColor = AttendanceStatus.excused.color;
            break;
          case AttendanceStatus.holiday:
            count = monthlyData.holidayCount.toDouble();
            barColor = AttendanceStatus.holiday.color;
            break;
          case AttendanceStatus.working:
            count = monthlyData.workingDaysCount.toDouble();
            barColor = AttendanceStatus.working.color;
            break;
          default: // Consider adding a "default" case or handling other statuses
            count = 0;
            barColor = Colors.grey; // Or any other default color
        }

        barGroups.add(
          BarChartGroupData(
            showingTooltipIndicators: [0],
            x: groupIndex,
            barRods: [
              BarChartRodData(
                toY: count,
                color: barColor,
                width: barWidth,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ],
            barsSpace: 4,
          ),
        );
        groupIndex++;
      }

      double maxAttendanceValue = monthlyAttendanceList.isNotEmpty
          ? monthlyAttendanceList
              .map((e) {
                switch (selectedStatus) {
                  case AttendanceStatus.present:
                    return e.presentCount;
                  case AttendanceStatus.absent:
                    return e.absentCount;
                  case AttendanceStatus.late:
                    return e.lateCount;
                  case AttendanceStatus.excused:
                    return e.excusedCount;
                  case AttendanceStatus.holiday:
                    return e.holidayCount;
                  case AttendanceStatus.working:
                    return e.workingDaysCount;
                  default:
                    return 0;
                }
              })
              .reduce(math.max)
              .toDouble()
          : 0; // Handle empty case

      return MyCard(
        hasShadow: true,
        child: Column(
          children: [
            HeadingForCard(
                controller: controller, heading: 'Monthly Attendance'),
            const SizedBox(
              height: MySizes.md,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MyBottomSheetDropdown(
                optionsForChips: const [
                  'Present',
                  'Absent',
                  'Late',
                  'Excused',
                  'Holiday',
                  'Working',
                ],
                onSingleChanged: (value) {
                  controller.selectedStatus.value =
                      AttendanceStatus.fromLabel(value);
                },
                selectedValue: controller.selectedStatus.value.label.obs,
                dropdownWidgetType: DropdownWidgetType.choiceChip,
              ),
            ),
            SizedBox(
              height: Get.width * .6,
              child: SingleChildScrollView(
                // Wrap BarChart with SingleChildScrollView
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: SizedBox(
                  // Give the BarChart a wider width
                  width: monthlyAttendanceList.length *
                      40.0, // Adjust width as needed
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxAttendanceValue + 5,
                      barGroups: barGroups,
                      groupsSpace: 20,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48, // Increased reservedSize
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: MyColors.captionTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12, // Reduced font size
                              );
                              if (monthlyAttendanceList.isEmpty ||
                                  value.toInt() >=
                                      monthlyAttendanceList.length) {
                                return const Text("");
                              }

                              final String monthYearString =
                                  monthlyAttendanceList[value.toInt()].month;
                              final DateTime monthYear = DateFormat('yyyy-MM')
                                  .parse(monthYearString); // Parse the string
                              final String text = DateFormat('MMM')
                                  .format(monthYear); // Format to "MMM yy"
                              final String year = DateFormat('yy')
                                  .format(monthYear); // Format to "MMM yy"

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 2, // Reduced space
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      text,
                                      style: style,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      year,
                                      style: style,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: false,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(0),
                          getTooltipColor: (BarChartGroupData group) {
                            return Colors.transparent;
                          },
                          tooltipMargin: 0,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toInt()}',
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                        handleBuiltInTouches: true,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AttendanceSummaryDashboard extends StatelessWidget {
  const AttendanceSummaryDashboard({super.key, required this.controller});

  final AttendanceReportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userAttendanceSummary.value == null) {
        return const MyCard(
          margin: EdgeInsets.zero,
          hasShadow: true,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return MyCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(MySizes.md),
        hasShadow: true,
        child: Column(
          children: [
            HeadingForCard(
                controller: controller, heading: 'Attendance Summary'),
            const SizedBox(height: MySizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserAttendanceSummaryCard(
                  status: AttendanceStatus.present,
                  summary: controller.userAttendanceSummary.value!,
                ),
                UserAttendanceSummaryCard(
                  status: AttendanceStatus.absent,
                  summary: controller.userAttendanceSummary.value!,
                ),
                UserAttendanceSummaryCard(
                  status: AttendanceStatus.late,
                  summary: controller.userAttendanceSummary.value!,
                ),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserAttendanceSummaryCard(
                  status: AttendanceStatus.excused,
                  summary: controller.userAttendanceSummary.value!,
                ),
                UserAttendanceSummaryCard(
                  status: AttendanceStatus.holiday,
                  summary: controller.userAttendanceSummary.value!,
                ),
                UserAttendanceSummaryCard(
                  status: AttendanceStatus.working,
                  summary: controller.userAttendanceSummary.value!,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class HeadingForCard extends StatelessWidget {
  const HeadingForCard({
    super.key,
    required this.controller,
    required this.heading,
  });

  final AttendanceReportController controller;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: MyTextStyle.headlineSmall,
          ),
          Obx(
            () => Text(
              'From ${MyDateTimeFormatter.formatPrettyLongDate(controller.selectedStartDate.value)} to ${MyDateTimeFormatter.formatPrettyLongDate(controller.selectedEndDate.value)}',
              style: MyTextStyle.labelMedium,
            ),
          )
        ],
      ),
      GestureDetector(
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: const Text(
                  'Filter Attendance',
                  style: MyTextStyle.headlineSmall,
                ),
                content: SingleChildScrollView(
                  child: Obx(() => Column(
                        children: [
                          // Text('Filter By',style: MyTextStyle.bodyLarge,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MyBottomSheetDropdown(
                              optionsForChips: const [
                                'Monthly',
                                'Yearly',
                                'Custom'
                              ],
                              selectedValue: controller.selectedFilterType,
                              onSingleChanged: (value) {
                                controller.selectedFilterType.value = value;
                              },
                              labelText: 'Filter By',
                              dropdownWidgetType: DropdownWidgetType.choiceChip,
                            ),
                          ),

                          if (controller.selectedFilterType.value == 'Monthly')
                            MyDropdownField(
                              options: controller.monthList,
                              selectedValue: controller.selectedMonth,
                              onSelected: (value) {
                                controller.selectedMonth.value = value!;
                              },
                              labelText: 'Month',
                            )
                          else if (controller.selectedFilterType.value ==
                              'Yearly')
                            MyDropdownField(
                              options: controller.yearList,
                              selectedValue: controller.selectedYear,
                              onSelected: (value) {
                                controller.selectedYear.value = value!;
                              },
                              labelText: 'Year',
                            )
                          else if (controller.selectedFilterType.value ==
                              'Custom')
                            Column(
                              children: [
                                MyDatePickerField(
                                  labelText: 'From',
                                  selectedDate: controller.selectedStartDate,
                                  firstDate: controller.userAttendanceData
                                      .value!.academicPeriodStart,
                                  lastDate:
                                      controller.endDateOfAttendance.value,
                                  onDateChanged: (value) {
                                    controller.selectedStartDate.value = value;
                                  },
                                ),
                                MyDatePickerField(
                                  labelText: 'To',
                                  selectedDate: controller.selectedEndDate,
                                  firstDate: controller.userAttendanceData
                                      .value!.academicPeriodStart,
                                  lastDate:
                                      controller.endDateOfAttendance.value,
                                  onDateChanged: (value) {
                                    controller.selectedEndDate.value = value;
                                  },
                                ),
                              ],
                            )
                        ],
                      )),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Use Get.back() to close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.updateDateRange();
                      Get.back();
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
              barrierDismissible: false, // Prevents closing on tap outside
            );
          },
          child: const MyLabelChip(
            text: 'Filter',
            color: MyColors.activeBlue,
          ))
      // TextButton(
      //   onPressed: () {
      //     Get.dialog(
      //       AlertDialog(
      //         title: const Text(
      //           'Filter Attendance',
      //           style: MyTextStyle.headlineSmall,
      //         ),
      //         content: SingleChildScrollView(
      //           child: Obx(() => Column(
      //                 children: [
      //                   // Text('Filter By',style: MyTextStyle.bodyLarge,),
      //                   Align(
      //                     alignment: Alignment.centerLeft,
      //                     child: MyBottomSheetDropdown(
      //                       optionsForChips: const [
      //                         'Monthly',
      //                         'Yearly',
      //                         'Custom'
      //                       ],
      //                       selectedValue: controller.selectedFilterType,
      //                       onSingleChanged: (value) {
      //                         controller.selectedFilterType.value = value;
      //                         controller.selectedMonth.value = '';
      //                         controller.selectedYear.value = '';
      //                         controller.selectedStartDate.value = DateTime(
      //                             DateTime.now().year, DateTime.now().month, 1);
      //                         controller.selectedEndDate.value = DateTime(
      //                             DateTime.now().year,
      //                             DateTime.now().month + 1,
      //                             0);
      //                       },
      //                       labelText: 'Filter By',
      //                       dropdownWidgetType: DropdownWidgetType.choiceChip,
      //                     ),
      //                   ),
      //
      //                   if (controller.selectedFilterType.value == 'Monthly')
      //                     MyDropdownField(
      //                       options: controller.monthList,
      //                       selectedValue: controller.selectedMonth,
      //                       onSelected: (value) {
      //                         controller.selectedMonth.value = value!;
      //                       },
      //                       labelText: 'Month',
      //                     )
      //                   else if (controller.selectedFilterType.value ==
      //                       'Yearly')
      //                     MyDropdownField(
      //                       options: controller.yearList,
      //                       selectedValue: controller.selectedYear,
      //                       onSelected: (value) {
      //                         controller.selectedYear.value = value!;
      //                       },
      //                       labelText: 'Year',
      //                     )
      //                   else if (controller.selectedFilterType.value ==
      //                       'Custom')
      //                     Column(
      //                       children: [
      //                         MyDatePickerField(
      //                           labelText: 'From',
      //                           selectedDate: controller.selectedStartDate,
      //                           firstDate: controller.userAttendanceData.value!
      //                               .academicPeriodStart,
      //                           lastDate: DateTime.now(),
      //                           onDateChanged: (value) {
      //                             controller.selectedStartDate.value = value;
      //                           },
      //                         ),
      //                         MyDatePickerField(
      //                           labelText: 'To',
      //                           selectedDate: controller.selectedEndDate,
      //                           firstDate: controller.userAttendanceData.value!
      //                               .academicPeriodStart,
      //                           lastDate: DateTime.now(),
      //                           onDateChanged: (value) {
      //                             controller.selectedEndDate.value = value;
      //                           },
      //                         ),
      //                       ],
      //                     )
      //                 ],
      //               )),
      //         ),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Get.back(); // Use Get.back() to close the dialog
      //             },
      //             child: const Text('Cancel'),
      //           ),
      //           TextButton(
      //             onPressed: () {
      //               controller.updateDateRange();
      //               Get.back();
      //             },
      //             child: const Text('Apply'),
      //           ),
      //         ],
      //       ),
      //       barrierDismissible: false, // Prevents closing on tap outside
      //     );
      //   },
      //   child: const Text('Filter'),
      // ),
    ]);
  }
}

class AttendanceExplanationDialog extends StatelessWidget {
  const AttendanceExplanationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
      ),
      backgroundColor: MyColors.white,
      title: Text(
        'Attendance Terms & Calculation',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Terms',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: MySizes.md),
            _buildTermExplanation(
              context,
              term: 'Present (P)',
              description: 'Student was present on this day.',
              color: MyColors.activeGreen,
              termLetter: 'P',
            ),
            _buildTermExplanation(
              context,
              term: 'Absent (A)',
              description: 'Student was absent on this day.',
              color: MyColors.activeRed,
              termLetter: 'A',
            ),
            _buildTermExplanation(
              context,
              term: 'Holiday (H)',
              description: 'A holiday was observed on this day.',
              color: MyColors.activeOrange,
              termLetter: 'H',
            ),
            _buildTermExplanation(
              context,
              term: 'Late (L)',
              description: 'Student was late on this day.',
              color: MyColors.colorPurple,
              termLetter: 'L',
            ),
            _buildTermExplanation(
              context,
              term: 'Excused (E)',
              description: 'Student was excused on this day.',
              color: MyColors.colorViolet,
              termLetter: 'E',
            ),
            _buildTermExplanation(
              context,
              term: 'Working (W)',
              description: 'Total working days in this month.',
              color: MyColors.activeBlue,
              termLetter: 'W',
            ),
            const SizedBox(height: MySizes.sm),
            Text(
              'Attendance Calculation:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: MySizes.md),
            _buildCalculationExplanation(
              context,
              title: 'Total Working Days (W)',
              calculation: 'W = P + A + L + E',
              description:
                  'Total Working Days is the sum of Present, Absent, Late, and Excused days.',
              color: MyColors.activeBlue,
              termLetter: 'W',
            ),
            const SizedBox(height: MySizes.sm),
            Text(
              'Percentage Calculation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: MySizes.md),
            _buildPercentageCalculation(
              context,
              percentageType: 'Present Percentage',
              calculation: '(Present Days / Total Working Days) * 100',
              color: MyColors.activeGreen,
              termLetter: 'P',
            ),
            _buildPercentageCalculation(
              context,
              percentageType: 'Absent Percentage',
              calculation: '(Absent Days / Total Working Days) * 100',
              color: MyColors.activeRed,
              termLetter: 'A',
            ),
            _buildPercentageCalculation(
              context,
              percentageType: 'Late Percentage',
              calculation: '(Late Days / Total Working Days) * 100',
              color: MyColors.colorPurple,
              termLetter: 'L',
            ),
            _buildPercentageCalculation(
              context,
              percentageType: 'Excused Percentage',
              calculation: '(Excused Days / Total Working Days) * 100',
              color: MyColors.colorViolet,
              termLetter: 'E',
            ),
            _buildPercentageCalculation(
              context,
              percentageType: 'Holiday Percentage',
              calculation: '(Holiday Days / Total Days in Month) * 100',
              color: MyColors.activeOrange,
              termLetter: 'H',
            ),
            _buildPercentageCalculation(
              context,
              percentageType: 'Working Percentage',
              calculation: '(Working Days / Total Days in Month) * 100',
              color: MyColors.activeBlue,
              termLetter: 'W',
            ),
            const SizedBox(height: MySizes.lg),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.xl,
                    vertical: MySizes.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySizes.buttonRadius),
                  ),
                ),
                child: Text(
                  'Close',
                  style: MyTextStyle.bodyLarge.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermExplanation(
    BuildContext context, {
    required String term,
    required String description,
    required Color color,
    required String termLetter,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: MySizes.sm),
      padding: const EdgeInsets.symmetric(
        vertical: MySizes.sm,
        horizontal: MySizes.md,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Text(
              termLetter,
              style: MyTextStyle.bodyLarge.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: MySizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(term, style: Theme.of(context).textTheme.bodyLarge),
                Text(description, style: MyTextStyle.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationExplanation(
    BuildContext context, {
    required String title,
    required String calculation,
    required String description,
    required Color color,
    required String termLetter,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: MySizes.sm),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              termLetter,
              style: MyTextStyle.bodyLarge.copyWith(color: color),
            ),
          ),
          const SizedBox(width: MySizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: MySizes.xs),
                Text(calculation,
                    style: MyTextStyle.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: MySizes.sm),
                Text(description, style: MyTextStyle.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageCalculation(
    BuildContext context, {
    required String percentageType,
    required String calculation,
    required Color color,
    required String termLetter,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: MySizes.sm),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Text(
              termLetter,
              style: MyTextStyle.bodyLarge.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: MySizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  percentageType,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: MySizes.xs),
                Text(calculation,
                    style: MyTextStyle.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
