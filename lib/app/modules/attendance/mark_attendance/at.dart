import 'package:cambridge_school/app/modules/attendance/mark_attendance/user_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AttendanceInsightsPage extends StatelessWidget {
  final UserAttendance attendanceData;

   AttendanceInsightsPage({Key? key, required this.attendanceData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Insights'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildPieChart(),
            const SizedBox(height: 20),
            _buildLineChart(),
            const SizedBox(height: 20),
            _buildWeeklyBarChart(),
            const SizedBox(height: 20),
            _buildStreaksInfo(),
            const SizedBox(height: 20),
            _buildConsistencyInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final summary = attendanceData.calculateAttendanceSummary();
    return Card(
      color: Colors.blueAccent,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: summary.entries.map((entry) {
            return Text(
              '${entry.key}: ${entry.value}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final pieData = attendanceData.getPieChartData();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Attendance Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieData.entries.map((entry) {
                    return PieChartSectionData(
                      color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
                      value: entry.value,
                      title: '${entry.key} (${entry.value.toInt()})',
                      radius: 60,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final lineData = attendanceData.getLineChartData();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Daily Attendance Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: lineData.entries.map((entry) {
                        return FlSpot(
                          DateFormat('yyyy-MM-dd').parse(entry.key).millisecondsSinceEpoch.toDouble(),
                          entry.value,
                        );
                      }).toList(),
                      isCurved: true,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
                      color: Colors.blue
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyBarChart() {
    final weeklyData = attendanceData.getWeeklyAttendanceData();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Weekly Attendance Bar Chart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: weeklyData.entries.map((entry) {
                    return BarChartGroupData(
                      x: int.parse(entry.key.split(' ').last),
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: Colors.green,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreaksInfo() {
    final streaks = attendanceData.getStreaks('P');
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Streaks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...streaks.map((streak) => Text(
              'From ${DateFormat('yyyy-MM-dd').format(streak['start'])} '
                  'to ${DateFormat('yyyy-MM-dd').format(streak['end'])}: '
                  '${streak['length']} days',
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildConsistencyInfo() {
    final consistency = attendanceData.getAttendanceConsistency();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Attendance Consistency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Consistency Score: ${consistency.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
