import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/carousel_slider_with_indicator.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

List<dynamic> imageUrls = const [
  // 'https://source.unsplash.com/random/800x600',
  // 'https://loremflickr.com/320/240',
  // 'https://picsum.photos/400/300',
  // 'https://picsum.photos/300/400',
  // 'https://picsum.photos/250/350',
  // 'https://picsum.photos/350/250',
  // 'https://picsum.photos/400/400',
  // 'https://picsum.photos/500/300',
  AssetImage('assets/images/banners/back_to_school.jpg'),
  AssetImage('assets/images/banners/group_study_3.jpg'),
  AssetImage('assets/images/banners/international_day_education.jpg'),
  AssetImage('assets/images/banners/Its_time_to_school.jpg'),
  AssetImage('assets/images/banners/school2.jpg'),
  AssetImage('assets/images/banners/school_3.jpg'),
  AssetImage('assets/images/banners/studying.jpg'),
  AssetImage('assets/images/banners/welcome_back_to_school.jpg'),
  AssetImage('assets/images/banners/winter_landscape.jpg'),
];

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff1191FD), Color(0xff5E59F2)],
              end: Alignment.centerRight,
              begin: Alignment.topLeft),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff1191FD), Color(0xff5E59F2)],
                        end: Alignment.bottomRight,
                        begin: Alignment.topLeft),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: MySizes.lg,
                        right: MySizes.lg,
                        top: MySizes.lg,
                        bottom: MySizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardHeader(),
                        const SizedBox(height: MySizes.lg),
                        Text(
                          'Hey Aryan Student,',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontSize: 22,
                                  color: MyDynamicColors.white,
                                  height: 0),
                        ),
                        Text(
                          'Unlock Success with our innovative school app',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: MyDynamicColors.white
                                      ?.withOpacity(0.5),
                                  fontSize: 15),
                        ),
                        const SizedBox(height: MySizes.sm),
                        MyCarouselSliderWithIndicator(images: imageUrls),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(MySizes.lg),
                  decoration: const BoxDecoration(
                    color: MyDynamicColors.lightGrey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(MySizes.lg),
                        topRight: Radius.circular(MySizes.lg)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: MySizes.md),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          attendanceCardWithIndicator(name: 'Present', value: 17, total: 22, color: MyDynamicColors.activeGreen),
                          attendanceCardWithIndicator(name: 'Absent', value: 5, total: 22, color: MyDynamicColors.activeRed),
                          attendanceCardWithIndicator(name: 'Holidays', value: 4, total: 30, color: MyDynamicColors.activeOrange),
                        ],
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      ),
                      School(),
                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      ),
                      RankOverview(),

                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      ),
                      //AttendanceOverview(),
                      Study(),
                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      ),
                      Others(),
                      const SizedBox(
                        height: MySizes.spaceBtwSections,
                      ),
                      FeeDetails()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget attendanceCardWithIndicator({
  //   required String name,
  //   required int value,
  //   required double percentage,
  //   required Color color,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //         vertical: SchoolSizes.md, horizontal: SchoolSizes.md - 5),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(
  //           0.1), // Use color with some transparency for background
  //       borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusMd),
  //     ),
  //     child: Column(
  //       children: [
  //         CircularPercentIndicator(
  //           radius: 30,
  //           animateFromLastPercent: true,
  //           progressColor: color,
  //           backgroundColor: color.withOpacity(0.1),
  //           animation: true,
  //           animationDuration: 1000,
  //           circularStrokeCap: CircularStrokeCap.round,
  //           lineWidth: 4,
  //           percent: percentage / 100,
  //           center: CircleAvatar(
  //             radius: 25,
  //             backgroundColor: Colors.white,
  //             child: Text(
  //               '${percentage.toStringAsFixed(1)}%',
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.black, // Use a contrasting color
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: SchoolSizes.sm,
  //         ),
  //         Text(
  //           name,
  //           style: const TextStyle(
  //             fontSize: 13,
  //             fontWeight: FontWeight.w500,
  //             color: SchoolColors.subtitleTextColor,
  //           ),
  //         ),
  //         Text(
  //           '$value Days',
  //           style: const TextStyle(
  //               fontSize: 17,
  //               fontWeight: FontWeight.w600,
  //               color: SchoolColors
  //                   .headlineTextColor, // Text color for the main value
  //               height: 0),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<dynamic> getGreeting() async {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget FeeDetails() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(MySizes.md),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            color: MyDynamicColors.backgroundColorWhiteDarkGrey,
            borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
            border: Border.all(
                width: 0.25,
                color: MyDynamicColors.borderColor.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Fee Details',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const MyLabelChip(
                    text: 'View Details',
                    color: MyColors.activeBlue,
                  ),
                ],
              ),
              const SizedBox(height: MySizes.md),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(MySizes.sm),
                    decoration: BoxDecoration(
                      color: MyDynamicColors.activeBlue.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(MySizes.cardRadiusXs),
                    ),
                    child: Icon(
                      Icons.currency_rupee,
                      color: MyDynamicColors.activeBlue,
                    ),
                  ),
                  const SizedBox(
                    width: MySizes.md,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Fee Due',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '₹ 18500',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyDynamicColors.activeBlue),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  var present = 73.63;
  var absent = 26.45;
  Widget AttendanceOverview() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(MySizes.md),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            color: MyDynamicColors.backgroundColorWhiteDarkGrey,
            borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
            border: Border.all(
                width: 0.25,
                color: MyDynamicColors.borderColor.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Attendance',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'View',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: MyDynamicColors.activeBlue, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: MySizes.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 32,
                        animateFromLastPercent: true,
                        progressColor: MyDynamicColors.activeGreen,
                        backgroundColor:
                            MyDynamicColors.activeGreen.withOpacity(0.1),
                        animation: true,
                        circularStrokeCap: CircularStrokeCap.round,
                        lineWidth: 6,
                        percent: present / 100,
                        center: Text(
                          '${(present).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: MyDynamicColors
                                .headlineTextColor, // Adjust the color as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Presents',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 15),
                          ),
                          Text(
                            '23 Days',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: MyDynamicColors.activeGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 32,
                        animateFromLastPercent: true,
                        progressColor: MyDynamicColors.activeRed,
                        backgroundColor:
                            MyDynamicColors.activeRed.withOpacity(0.1),
                        animation: true,
                        circularStrokeCap: CircularStrokeCap.round,
                        lineWidth: 6,
                        percent: absent / 100,
                        center: Text(
                          '${(absent).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: MyDynamicColors
                                .headlineTextColor, // Adjust the color as needed
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Absents',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 15),
                          ),
                          Text(
                            '3 Days',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: MyDynamicColors.activeRed),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: MySizes.lg),
      ],
    );
  }

  Widget RankOverview() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(MySizes.md),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            color: MyDynamicColors.backgroundColorWhiteDarkGrey,
            borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
            border: Border.all(
                width: 0.25,
                color: MyDynamicColors.borderColor.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Leaderboard',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const MyLabelChip(
                    text: 'View all',
                    color: MyColors.activeBlue,
                  )
                ],
              ),
              const SizedBox(
                height: MySizes.md,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRankRow(
                      icon: Icons.public,
                      iconColor: MyColors.activeBlue,
                      label: 'All India Rank',
                      value: '323765'),
                  _buildRankRow(
                      icon: Icons.home_work_outlined,
                      iconColor: MyColors.activeOrange,
                      label: 'School Rank',
                      value: '426'),
                ],
              ),
              const SizedBox(
                height: MySizes.md + 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRankRow(
                      icon: Icons.class_,
                      iconColor: MyColors.activeRed,
                      label: 'Class Rank',
                      value: '23'),
                  _buildRankRow(
                      icon: Icons.offline_bolt,
                      iconColor: MyColors.activeGreen,
                      label: 'Total Points',
                      value: '56562'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(MySizes.sm),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(MySizes.cardRadiusXs),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: MySizes.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: MyColors.subtitleTextColor),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColors.headlineTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget DashboardHeader() {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
              child: CircleAvatar(
                backgroundColor: MyDynamicColors.white.withOpacity(0.1),
                child: const Icon(Icons.menu_rounded,
                    size: MySizes.iconMd, color: MyDynamicColors.white),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyDynamicColors.white.withOpacity(0.1),
                  child: const Icon(
                    Icons.search_rounded,
                    size: MySizes.iconMd,
                    color: MyDynamicColors.white,
                  ),
                ),
                const SizedBox(
                  width: MySizes.lg,
                ),
                CircleAvatar(
                  backgroundColor: MyDynamicColors.white.withOpacity(0.1),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: MySizes.iconMd,
                    color: MyDynamicColors.white,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget School() {
    return Container(
      padding: const EdgeInsets.all(MySizes.md),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        color: MyDynamicColors.backgroundColorWhiteDarkGrey,
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
        border: Border.all(
            width: 0.25,
            color: MyDynamicColors.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'School',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: MySizes.sm),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SchoolIcon(
                icon: Icons.assignment_rounded,
                text: 'Homework',
                color: MyDynamicColors.colorBlue,
                // destination: StudentHomework(),
              ),
              SchoolIcon(
                icon: Icons.date_range,
                text: 'Attendance',
                color: MyDynamicColors.colorOrange,
                // destination: Attendance(),
              ),
              SchoolIcon(
                icon: Icons.assignment,
                text: 'Noticeboard',
                color: MyDynamicColors.colorYellow,
                // destination: Noticeboard(),
              ),
              SchoolIcon(
                icon: Icons.book,
                text: 'Syllabus',
                color: MyDynamicColors.colorGreen,
                // destination: Syllabus(),
              ),
            ],
          ),
          const SizedBox(height: MySizes.lg),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SchoolIcon(
                icon: Icons.receipt_outlined,
                text: 'Routine',
                color: MyDynamicColors.colorSkyBlue,
                // destination: MyRoutine(),
              ),
              SchoolIcon(
                icon: Icons.directions_bus_filled,
                text: 'Track Bus',
                color: MyDynamicColors.colorPink,
                // destination: TrackBus(),
              ),
              SchoolIcon(
                icon: Icons.ondemand_video,
                text: 'Online Class',
                color: MyDynamicColors.colorTeal,
                // destination: OnlineClasses(),
              ),
              SchoolIcon(
                icon: Icons.assignment_turned_in_rounded,
                text: 'Take Leave',
                color: MyDynamicColors.colorRed,
                // destination: TakeLeave(),
              ),
            ],
          ),
          const SizedBox(height: MySizes.lg),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SchoolIcon(
                icon: Icons.monetization_on_outlined,
                text: 'Fees',
                color: MyDynamicColors.colorPurple,
                // destination: Fees(),
              ),
              SchoolIcon(
                icon: Icons.laptop_chromebook_rounded,
                text: 'Online Exam',
                color: MyDynamicColors.colorViolet,
              ),
              SchoolIcon(
                icon: Icons.library_books_rounded,
                text: 'Result',
                color: MyDynamicColors.colorOrange,
                // destination: Result(),
              ),
              SizedBox(
                width: 65,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Study() {
    return Container(
      padding: const EdgeInsets.all(MySizes.md),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        color: MyDynamicColors.backgroundColorWhiteDarkGrey,
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
        border: Border.all(
            width: 0.25,
            color: MyDynamicColors.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Study',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: MySizes.md),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SchoolIcon(
                icon: Icons.menu_book_rounded,
                text: 'Notes',
                color: MyDynamicColors.colorBlue,
              ),
              SchoolIcon(
                icon: Icons.ondemand_video_rounded,
                text: 'Video Lecture',
                color: MyDynamicColors.colorRed,
              ),
              SchoolIcon(
                icon: Icons.quiz,
                text: 'Quiz',
                color: MyDynamicColors.colorYellow,
              ),
              SchoolIcon(
                icon: Icons.collections_bookmark,
                text: 'Practice',
                color: MyDynamicColors.colorOrange,
              ),
            ],
          ),
          const SizedBox(height: MySizes.lg),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SchoolIcon(
                icon: Icons.library_books_rounded,
                text: 'Library',
                color: MyDynamicColors.colorGreen,
              ),
              SchoolIcon(
                icon: Icons.abc_rounded,
                text: 'Learn English',
                color: MyDynamicColors.colorViolet,
              ),
              SizedBox(
                width: 70,
              ),
              SizedBox(
                width: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Others() {
    return Container(
      padding: const EdgeInsets.all(MySizes.md),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        color: MyDynamicColors.backgroundColorWhiteDarkGrey,
        borderRadius: BorderRadius.circular(MySizes.cardRadiusMd),
        border: Border.all(
            width: 0.25,
            color: MyDynamicColors.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child:
                Text('Other', style: Theme.of(context).textTheme.headlineSmall),
          ),
          const SizedBox(height: MySizes.md),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SchoolIcon(
                icon: Icons.download,
                text: 'Downloads',
                color: MyDynamicColors.colorBlue,
              ),
              SchoolIcon(
                icon: Icons.timer,
                text: 'To Do List',
                color: MyDynamicColors.colorRed,
              ),
              SizedBox(
                width: 70,
              ),
              SizedBox(
                width: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SchoolIcon extends StatelessWidget {
  final dynamic icon; // Accepts both IconData and SvgPicture
  final String? text;
  final Color? color;
  final Widget? destination;

  const SchoolIcon({
    Key? key,
    required this.icon,
    this.text,
    this.color,
    this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            // borderRadius:
            //     BorderRadius.circular(12), // Update with your desired radius
              shape: BoxShape.circle
          ),
          child: InkWell(
            onTap: () {
              if (destination != null) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => destination!));
              }
            },
            child: Container(
              width: 50,
              height: 50,
              padding: icon is SvgPicture
                  ? const EdgeInsets.all(MySizes.md)
                  : const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: color!.withOpacity(0.1),
                  // gradient: LinearGradient(
                  //     colors: [Color(0xff1191FD), Color(0xff5E59F4)],begin: Alignment.topLeft,end: Alignment.bottomRight),
                  shape: BoxShape.circle

              ),
              child: icon is IconData // Check if the icon is IconData
                  ? Icon(
                icon as IconData,
                size: 24,
                color: color,
              )
                  : (icon is SvgPicture) // Check if the icon is SvgPicture
                  ? SizedBox(
                width: 30,
                height: 30,
                child: icon as SvgPicture,
              )
                  : Container(), // Return empty container if neither IconData nor SvgPicture
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          text ?? '',
          style: Theme.of(context)
              .textTheme
              .labelLarge, // Update with your desired text style
        ),
      ],
    );
  }
}
Widget attendanceCardWithIndicator({
  required String name,
  required int value,
  required int total,
  required Color color,
}) {
  double percentage = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;

  return MyCard(
    padding: const EdgeInsets.symmetric(
        vertical: MySizes.sm + 2, horizontal: MySizes.md - 2),
    hasShadow: true,
    elevation: 1,
    border: Border.all(color: MyColors.borderColor,width: 0.5),
    child: Column(
      children: [
        CircularPercentIndicator(
          radius: 36,
          animateFromLastPercent: true,
          progressColor: color,
          backgroundColor: color.withOpacity(0.1),
          animation: true,
          animationDuration: 1000,
          circularStrokeCap: CircularStrokeCap.round,
          lineWidth: 6,
          percent: percentage,
          center: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              '${(percentage * 100).toStringAsFixed(1)}%',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: MySizes.sm),
        Text(
          '$value/$total',
          style: const TextStyle(
              height: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyColors.headlineTextColor),
        ),
        // SizedBox(height: SchoolSizes.sm - 6),
        Text(
          name,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: MyColors.subtitleTextColor),
        ),
      ],
    ),
  );
}