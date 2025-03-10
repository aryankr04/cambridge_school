import 'dart:math' as math;

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/dynamic_colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'attendance_calendar_widget.dart';
import 'attendance_report_controller.dart';

class AttendanceReportScreen extends GetView<AttendanceReportController> {
  AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyAttendanceCalendar(
                userAttendance: controller.userAttendanceData.value,
                onMonthChanged: controller.setSelectedMonth,
              ),
              const SizedBox(height: MySizes.md),
              AttendanceSummaryDashboard(controller: controller),
              const SizedBox(height: MySizes.lg),
              const MonthlyAttendanceBarChart(),
              const SizedBox(height: MySizes.lg),
              _buildYourAverageVsClassAverage(context),
              const SizedBox(height: MySizes.lg),
              _buildRankOverview(),
              const SizedBox(height: MySizes.lg),
              AttendanceConsistencyIndicator(controller: controller),
              const SizedBox(height: MySizes.lg),
              _buildStreaksSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAverageBox(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.md, horizontal: MySizes.md),
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

  Widget _buildYourAverageVsClassAverage(BuildContext context) {
    final studentAttendancePercentage = controller
        .getStudentAttendancePercentage(controller.studentList.firstWhere(
            (student) => student.userId == controller.userId.value));

    return MyCard(
      hasShadow: true,
      padding: const EdgeInsets.all(MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Your Average vs Class Average",
              style: MyTextStyle.headlineSmall,
            ),
          ),
          const SizedBox(height: MySizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAverageBox("Your Average", studentAttendancePercentage,
                  MyColors.activeGreen),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CircleAvatar(
                  backgroundColor: MyColors.activeRed.withOpacity(0.1),
                  child: Text(
                    'VS',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              _buildAverageBox("Class Average",
                  controller.averageClassAttendance.value, MyColors.activeBlue),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                studentAttendancePercentage >=
                    controller.averageClassAttendance.value
                    ? Icons.trending_up
                    : Icons.trending_down,
                color: studentAttendancePercentage >=
                    controller.averageClassAttendance.value
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                "Difference: ${studentAttendancePercentage >= controller.averageClassAttendance.value ? '+ ${(studentAttendancePercentage - controller.averageClassAttendance.value).toStringAsFixed(2)}%' : '${(studentAttendancePercentage - controller.averageClassAttendance.value).toStringAsFixed(2)}%'} vs Class",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankOverview() {
    return MyCard(
      padding: const EdgeInsets.all(MySizes.md),
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Rank Overview",
              style: MyTextStyle.headlineSmall,
            ),
          ),
          const SizedBox(height: MySizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRankBox(
                  "Your Rank",
                  controller.studentRankings.indexWhere((element) =>
                  element.student.userId == controller.userId.value) +
                      1,
                  controller.getStudentAttendancePercentage(
                      controller.studentList.firstWhere((student) =>
                      student.userId == controller.userId.value)),
                  Colors.orangeAccent),
              _buildRankBox(
                  "Top Rank",
                  1,
                  controller.studentRankings.isNotEmpty
                      ? controller.studentRankings.first.percentage
                      : 0.0,
                  Colors.blueAccent),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Rank Breakdown",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ..._buildRankDistributionRows(controller.studentRankings),
        ],
      ),
    );
  }

  Widget _buildRankBox(String label, int rank, double percentage, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
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
                "$label: $rank${rank == 1 ? 'st' : rank == 2 ? 'nd' : rank == 3 ? 'rd' : 'th'}",
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

  final RxBool _isExpanded = false.obs;

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

  List<Widget> _buildRankDistributionRows(List<StudentRanking> rankingList) {
    final topRanks = rankingList
        .where((student) => rankingList.indexOf(student) + 1 <= 3)
        .toList();
    final limit = _isExpanded.value ? rankingList.length : topRanks.length;
    final rankDistributionRows = <Widget>[];

    for (var i = 0; i < limit; i++) {
      final student = rankingList[i];
      final name = student.student.fullName ?? '';
      final id = student.student.userId;
      final rank = (rankingList.indexOf(student) + 1).toString();
      final percentage = student.percentage.toString();
      final color = _getRankColor(rank);

      rankDistributionRows
          .add(_buildRankDistributionRow(name, id, rank, percentage, color));
    }

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

  Widget _buildRankDistributionRow(
      String name, String id, String rank, String percentage, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
        color: controller.userId.value == id
            ? color.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
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
                rank == '1'
                    ? "1st"
                    : rank == '2'
                    ? "2nd"
                    : rank == '3'
                    ? "3rd"
                    : rank,
                style: Theme.of(Get.context!)
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

  Widget _buildStreaksSection() {
    return MyCard(
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attendance Streaks',
              style: Theme.of(Get.context!).textTheme.headlineSmall),
          const SizedBox(height: MySizes.sm),
          controller.streaks.isEmpty
              ? const Text("No streaks to display.")
              : Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: controller.streaks
                .map((streak) => StreakCard(streak: streak))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.streak});

  final Map<String, dynamic> streak;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yy');
    final startDate = streak['start'] as DateTime;
    final endDate = streak['end'] as DateTime;
    final length = streak['length'] as int;

    return Padding(
      padding: const EdgeInsets.all(MySizes.sm),
      child: Row(
        children: [
          Text(
            '🔥   $length Days',
            style: MyTextStyle.bodyLarge,
          ),
          const SizedBox(
            width: MySizes.lg,
          ),
          Text(
            dateFormat.format(startDate),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(
            width: MySizes.md,
          ),
          const Expanded(
            child: MyDottedLine(
              dashColor: MyColors.dividerColor,
              lineThickness: 2,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: MyColors.dividerColor,
            size: 16,
          ),
          const SizedBox(
            width: MySizes.md,
          ),
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
    );
  }
}

class AttendanceStatusCard extends StatelessWidget {
  final String status;
  final String label;
  final Map<String, int> summary;
  final int totalDays;

  const AttendanceStatusCard({
    super.key,
    required this.status,
    required this.label,
    required this.summary,
    required this.totalDays,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'P':
        return MyDynamicColors.activeGreen;
      case 'A':
        return MyDynamicColors.activeRed;
      case 'H':
        return MyColors.activeOrange;
      case 'L':
        return Colors.purple;
      case 'E':
        return MyColors.colorViolet;
      case 'W':
        return MyColors.activeBlue;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    int count = summary[label] ?? 0;
    double percentage = totalDays > 0 ? (count / totalDays) : 0.0;
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: MySizes.xs),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 34,
            lineWidth: 6.0,
            percent: percentage,
            center: Text(
              '${(percentage * 100).toStringAsFixed(1)}%',
              style:
              MyTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            progressColor: statusColor,
            backgroundColor: statusColor.withOpacity(0.3),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: MySizes.sm),
          Text(
            '$count',
            style: MyTextStyle.bodyLarge,
          ),
          const SizedBox(width: MySizes.xs,),
          Text(
            label,
            style: MyTextStyle.bodyMedium,
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }
}

class AttendanceConsistencyIndicator extends StatelessWidget {
  const AttendanceConsistencyIndicator({super.key, required this.controller});

  final AttendanceReportController controller;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      hasShadow: true,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Attendance Consistency',
              style: Theme.of(Get.context!)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: LinearProgressIndicator(
                    value: 1 - (controller.consistency / 100),
                    backgroundColor: MyColors.activeBlue.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        MyColors.activeBlue),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${(100 - (controller.consistency)).toStringAsFixed(2)}%",
                style: MyTextStyle.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MonthlyAttendanceBarChart extends GetView<AttendanceReportController> {
  const MonthlyAttendanceBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final monthlyData = controller.monthlyAttendanceData.entries.map((entry) {
      List<String> parts = entry.key.split('_');
      String monthYear = parts[0];
      String type = parts[1];

      return _MonthlyAttendanceData(
        monthYear,
        type,
        entry.value,
      );
    }).toList();

    final Map<String, _MonthlyAttendanceSummary> monthlySummary = {};

    for (final data in monthlyData) {
      final monthKey =
      DateFormat('MMM').format(DateFormat('yyyy-MM').parse(data.monthYear));
      if (!monthlySummary.containsKey(monthKey)) {
        monthlySummary[monthKey] = _MonthlyAttendanceSummary();
      }
      if (data.type == 'P') {
        monthlySummary[monthKey]!.present = data.count.toDouble();
      } else {
        monthlySummary[monthKey]!.absent = data.count.toDouble();
      }
    }

    List<BarChartGroupData> barGroups = [];
    int groupIndex = 0;
    const double barWidth = 6;

    for (final monthName in monthlySummary.keys) {
      final summary = monthlySummary[monthName]!;

      barGroups.add(
        BarChartGroupData(
          showingTooltipIndicators: [0, 1],
          x: groupIndex,
          barRods: [
            BarChartRodData(
              toY: summary.present,
              color: MyColors.activeGreen,
              width: barWidth,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            BarChartRodData(
              toY: summary.absent,
              color: MyColors.activeRed,
              width: barWidth,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ],
          barsSpace: 4,
        ),
      );
      groupIndex++;
    }
    double maxAttendanceValue =
    monthlySummary.values.map((e) => e.present + e.absent).reduce(math.max);

    return MyCard(
      hasShadow: true,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Monthly Attendance',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: Get.width * .6,
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
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: MyColors.captionTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        );
                        final String text =
                        monthlySummary.keys.toList()[value.toInt()];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: Text(text, style: style),
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
        ],
      ),
    );
  }
}

class _MonthlyAttendanceData {
  final String monthYear;
  final String type;
  final int count;

  _MonthlyAttendanceData(this.monthYear, this.type, this.count);
}

class _MonthlyAttendanceSummary {
  double present = 0;
  double absent = 0;
}

class AttendanceSummaryDashboard extends StatelessWidget {
  final AttendanceReportController controller;
  const AttendanceSummaryDashboard({super.key, required this.controller});

  int getTotalDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      hasShadow: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Summary',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(const AttendanceExplanationDialog());
                },
                child: const Text('Explain?',style: TextStyle(color: MyColors.activeBlue,fontSize: 12),),
              )
            ],
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AttendanceStatusCard(
                status: 'P',
                label: 'Present',
                summary: controller.attendanceSummary,
                totalDays: controller.attendanceSummary['Working'] ?? 0,
              ),
              AttendanceStatusCard(
                status: 'A',
                label: 'Absent',
                summary: controller.attendanceSummary,
                totalDays: controller.attendanceSummary['Working'] ?? 0,
              ),
              AttendanceStatusCard(
                status: 'W',
                label: 'Working',
                summary: controller.attendanceSummary,
                totalDays: getTotalDaysInMonth(controller.selectedMonth.value),
              ),
            ],
          ),
          const SizedBox(height: MySizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AttendanceStatusCard(
                status: 'L',
                label: 'Late',
                summary: controller.attendanceSummary,
                totalDays: controller.attendanceSummary['Working'] ?? 0,
              ),
              AttendanceStatusCard(
                status: 'E',
                label: 'Excused',
                summary: controller.attendanceSummary,
                totalDays: controller.attendanceSummary['Working'] ?? 0,
              ),
              AttendanceStatusCard(
                status: 'H',
                label: 'Holiday',
                summary: controller.attendanceSummary,
                totalDays: getTotalDaysInMonth(controller.selectedMonth.value),
              ),
            ],
          ),
        ],
      ),
    );
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
            Text('Attendance Terms',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: MySizes.md),
            _buildTermExplanation(context,
                term: 'Present (P)',
                description: 'Student was present on this day.',
                color: MyColors.activeGreen,
                termLetter: 'P'),
            _buildTermExplanation(context,
                term: 'Absent (A)',
                description: 'Student was absent on this day.',
                color: MyColors.activeRed,
                termLetter: 'A'),
            _buildTermExplanation(context,
                term: 'Holiday (H)',
                description: 'A holiday was observed on this day.',
                color: MyColors.activeOrange,
                termLetter: 'H'),
            _buildTermExplanation(context,
                term: 'Late (L)',
                description: 'Student was late on this day.',
                color: MyColors.colorPurple,
                termLetter: 'L'),
            _buildTermExplanation(context,
                term: 'Excused (E)',
                description: 'Student was excused on this day.',
                color: MyColors.colorViolet,
                termLetter: 'E'),
            _buildTermExplanation(context,
                term: 'Working (W)',
                description: 'Total working days in this month.',
                color: MyColors.activeBlue,
                termLetter: 'W'),
            const SizedBox(height: MySizes.sm),
            Text('Attendance Calculation:',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: MySizes.md),
            _buildCalculationExplanation(context,
                title: 'Total Working Days (W)',
                calculation: 'W = P + A + L + E',
                description:
                'Total Working Days is the sum of Present, Absent, Late, and Excused days.',
                color: MyColors.activeBlue,
                termLetter: 'W'),
            const SizedBox(height: MySizes.sm),
            Text('Percentage Calculation',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: MySizes.md),
            _buildPercentageCalculation(context,
                percentageType: 'Present Percentage',
                calculation: '(Present Days / Total Working Days) * 100',
                color: MyColors.activeGreen,
                termLetter: 'P'),
            _buildPercentageCalculation(context,
                percentageType: 'Absent Percentage',
                calculation: '(Absent Days / Total Working Days) * 100',
                color: MyColors.activeRed,
                termLetter: 'A'),
            _buildPercentageCalculation(context,
                percentageType: 'Late Percentage',
                calculation: '(Late Days / Total Working Days) * 100',
                color: MyColors.colorPurple,
                termLetter: 'L'),
            _buildPercentageCalculation(context,
                percentageType: 'Excused Percentage',
                calculation: '(Excused Days / Total Working Days) * 100',
                color: MyColors.colorViolet,
                termLetter: 'E'),
            _buildPercentageCalculation(context,
                percentageType: 'Holiday Percentage',
                calculation: '(Holiday Days / Total Days in Month) * 100',
                color: MyColors.activeOrange,
                termLetter: 'H'),
            _buildPercentageCalculation(context,
                percentageType: 'Working Percentage',
                calculation: '(Working Days / Total Days in Month) * 100',
                color: MyColors.activeBlue,
                termLetter: 'W'),
            const SizedBox(height: MySizes.lg),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: MySizes.xl, vertical: MySizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySizes.buttonRadius),
                  ),
                ),
                child: Text('Close',
                    style:
                    MyTextStyle.bodyLarge.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermExplanation(BuildContext context,
      {required String term,
        required String description,
        required Color color,
        required String termLetter}) {
    return Container(
      margin: const EdgeInsets.only(bottom: MySizes.sm),
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
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

  Widget _buildCalculationExplanation(BuildContext context,
      {required String title,
        required String calculation,
        required String description,
        required Color color,
        required String termLetter}) {
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

  Widget _buildPercentageCalculation(BuildContext context,
      {required String percentageType,
        required String calculation,
        required Color color,
        required String termLetter}) {
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