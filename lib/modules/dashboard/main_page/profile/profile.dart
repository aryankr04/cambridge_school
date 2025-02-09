import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/detail_card_widget.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/theme/widget_themes/tab_bar_theme.dart';
import '../home/home.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Theme child;

  _SliverAppBarDelegate({required this.child});

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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late TabController tabController;
  bool isPrivate = false;
  late PageController _pageController;
  final int _currentPage = 1;
  late Animation<double> _animation;
  bool isFront = true; // To track which card is shown
  late AnimationController _controller;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9, // Show part of next/previous card
      initialPage: _currentPage,
    );
    _controller = AnimationController(
      vsync: this, // Use `this` as vsync for multiple controllers
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    tabController.dispose();
    _pageController.dispose();
    _controller.dispose(); // Dispose the animation controller as well
    super.dispose();
  }

  void flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
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
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(MySizes.lg),
                  child: GestureDetector(
                    onTap: flipCard,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(
                                _animation.value * 3.14), // Rotate the card
                          child: _animation.value < 0.5
                              ? _buildProfileHeader(context)
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(3.14),
                                  child: buildBackCard(),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  child: Theme(
                    data: ThemeData(
                      tabBarTheme:
                          MyTabBarTheme.defaultTabBarTheme.copyWith(
                        indicatorColor: MyDynamicColors.activeBlue,
                        unselectedLabelColor: Colors.grey,
                        labelColor: MyDynamicColors.activeBlue,
                        dividerColor: MyDynamicColors.borderColor,
                        dividerHeight: 0.5,
                        splashFactory: NoSplash.splashFactory,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    child: const TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        tabs: [
                          Tab(
                            text: 'Personal',
                          ),
                          Tab(
                            text: 'Contact',
                          ),
                          Tab(
                            text: 'Academics',
                          ),
                          Tab(
                            text: 'Fee',
                          ),
                          Tab(
                            text: 'Parents',
                          ),
                          Tab(
                            text: 'Transportation',
                          ),
                          Tab(
                            text: 'School',
                          ),
                          Tab(
                            text: 'Favorites',
                          )
                        ]),
                  ),
                ),
                pinned: true,
                floating: true,
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: MySizes.lg),
            child: TabBarView(
              children: [
                buildPersonalDetails(context),
                buildContactDetails(context),
                buildAcademicsDetails(context),
                buildFeeDetails(context),
                buildParentsDetails(context),
                buildTransportDetails(context),
                buildSchoolDetails(context),
                buildFavoritesDetails(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildFavoritesDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.sm,
          ),
          Text(
            'Favorites',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Subject', 'Computer'),
          buildTextColumn('Sport', 'Cricket'),
          buildTextColumn('Teacher', 'Amit Shukla'),
          buildTextColumn('Food', 'Chicken Biryani'),
          buildTextColumn('Goal', 'Engineer'),
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Hobbies',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: MyLists.hobbyOptions
                .asMap() // Convert the list to a map to get indices
                .entries
                .map((entry) => MyLabelChip(
                      text: entry.value, // Access the text value
                      color: MyColors
                          .colorList[entry.key % MyColors.colorList.length],
                      // color: SchoolColors.activeBlue,
                    ))
                .toList(),
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Interests',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: MyLists.hobbyOptions
                .asMap() // Convert the list to a map to get indices
                .entries
                .map((entry) => MyLabelChip(
                      text: entry.value, // Access the text value
                      color: MyColors
                          .colorList[entry.key % MyColors.colorList.length],
                      //color: SchoolColors.activeBlue,
                    ))
                .toList(),
          ),
          const SizedBox(
            height: MySizes.md,
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildFeeDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Title
          Text('Fee Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: MySizes.md),

          // Fee Summary Card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyDetailCard(
                action: MyLabelChip(text: 'Incomplete'),
                title: 'Fee Summary',
                icon: Icons.currency_rupee_rounded,
                color: Colors.orange,
                list: [
                  ListTileDetails(
                      field: 'Total Fees',
                      value: '₹50,000',
                      icon: const Icon(Icons.money)),
                  ListTileDetails(
                      field: 'Paid',
                      value: '₹30,000',
                      icon: const Icon(Icons.check)),
                  ListTileDetails(
                      field: 'Remaining Fee',
                      value: '₹20,000',
                      icon: const Icon(Icons.hourglass_bottom)),
                ],
                widget: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: MySizes.sm, horizontal: MySizes.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: 0.6,
                          color: MyColors.activeGreen,
                          backgroundColor:
                              MyColors.activeGreen.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(MySizes.cardRadiusMd)),
                        ),
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                      Text(
                        "60% Paid",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: MyColors.activeGreen),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MySizes.lg),

          // Fee Breakdown Section
          Text(
            "Installments",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: MySizes.md),
          const SizedBox(height: 24),

          // Pay Now Button
        ],
      ),
    );
  }

  Widget buildContactDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.sm,
          ),
          Text(
            'Contact Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Mobile No', '9431098856'),
          buildTextColumn('Email', 'aryankumarimpossible@gmail.com'),
          buildTextColumn('Aadhaar No.', '1234 5678 9123'),
          buildTextColumn('Address', 'Chowk Road Dumraon'),
          buildTextColumn('Pincode', '802119'),
          buildTextColumn('City', 'Dumraon'),
          buildTextColumn('District', 'Buxar'),
          buildTextColumn('State/UT', 'Bihar'),
          const SizedBox(
            height: MySizes.md,
          ),
        ],
      ),
    );
  }


  SingleChildScrollView buildTransportDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.sm,
          ),
          Text(
            'Transportation Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Bus No.', 'KA01HF0007'),
          buildTextColumn('Route', 'Dumraon - Buxar'),
          buildTextColumn('Driver', 'Sunil Kumar'),
          buildTextColumn('Pickup Time', '07:30 AM'),
          buildTextColumn('Drop Time', '01:30 PM'),
        ],
      ),
    );
  }

  SingleChildScrollView buildParentsDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.sm,
          ),
          Text(
            'Father Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Father', 'Anand Kumar'),
          buildTextColumn("Father's Mobile No", '8757012040'),
          buildTextColumn("Father's Occupation", 'Businessman'),
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Mother Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Mother', 'Lalita Devi'),
          buildTextColumn("Mother's Mobile No", '8757012040'),
          buildTextColumn("Mother's Occupation", 'Businessman'),
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Guardian Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Guardian', 'Lalita Devi'),
          buildTextColumn('Relationship to Guardian', 'Lalita Devi'),
          buildTextColumn("Guardian's Mobile No", '8757012040'),
          buildTextColumn(
              "Guardian's Address", 'Fair Field Colony, Digha, Patna'),
          buildTextColumn("Guardian's Occupation", 'Businessman'),
        ],
      ),
    );
  }

  SingleChildScrollView buildSchoolDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.sm,
          ),
          Text(
            'School Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('School', 'Cambridge School Dumraon'),
          buildTextColumn('Admission Date', '13 April 2012'),
          buildTextColumn('House/Team Allocation', 'Tagore House'),
          buildTextColumn('Admission No', '43689321'),
        ],
      ),
    );
  }

  SingleChildScrollView buildAcademicsDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Attendance Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              attendanceCardWithIndicator(
                  name: 'Present',
                  value: 17,
                  total: 22,
                  color: MyDynamicColors.activeGreen),
              attendanceCardWithIndicator(
                  name: 'Absent',
                  value: 5,
                  total: 22,
                  color: MyDynamicColors.activeRed),
              attendanceCardWithIndicator(
                  name: 'Holidays',
                  value: 4,
                  total: 30,
                  color: MyDynamicColors.activeOrange),
            ],
          ),
          const SizedBox(
            height: MySizes.lg,
          ),
          Text(
            'Subjects',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children:
                ['Computer', 'Science', 'Social Science', 'Maths', 'English']
                    .asMap() // Convert the list to a map to get indices
                    .entries
                    .map((entry) => MyLabelChip(
                          text: entry.value, // Access the text value
                          color: MyColors.colorList[entry.key %
                              MyColors.colorList
                                  .length], // Use modulo for cycling colors
                        ))
                    .toList(),
          ),
          const SizedBox(
            height: MySizes.lg,
          ),
          Text(
            'Overall Performance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  MyCard(
                    hasShadow: false,
                    isCircular: true,
                    alignment: Alignment.center,
                    height: Get.width * 0.15,
                    width: Get.width * 0.15,
                    padding: const EdgeInsets.all(0),
                    color: MyColors.activeOrange.withOpacity(0.1),
                    border:
                        Border.all(color: MyColors.activeOrange, width: 2),
                    child: Text(
                      '1st',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: MyColors.activeOrange),
                    ),
                  ),
                  const SizedBox(
                    height: MySizes.sm - 4,
                  ),
                  const Text(
                    'Rank',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.subtitleTextColor),
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 32,
                        animateFromLastPercent: true,
                        progressColor: MyColors.activeBlue,
                        backgroundColor:
                            MyColors.activeBlue.withOpacity(0.1),
                        animation: true,
                        animationDuration: 1000,
                        circularStrokeCap: CircularStrokeCap.round,
                        lineWidth: 6,
                        percent: 0.42,
                        center: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          child: Text(
                            '${(0.42 * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: MySizes.sm - 6),
                      const Text(
                        'Percentage',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MyColors.subtitleTextColor),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  MyCard(
                    hasShadow: false,
                    isCircular: true,
                    alignment: Alignment.center,
                    height: Get.width * 0.15,
                    width: Get.width * 0.15,
                    padding: const EdgeInsets.all(0),
                    color: MyColors.activeGreen.withOpacity(0.1),
                    border:
                        Border.all(color: MyColors.activeGreen, width: 2),
                    child: Text(
                      'B+',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: MyColors.activeGreen),
                    ),
                  ),
                  const SizedBox(
                    height: MySizes.sm - 4,
                  ),
                  const Text(
                    'Grade',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.subtitleTextColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: MySizes.lg,
          ),
          Text(
            'Examination Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          MyDetailCard(
            title: "Final Exam",
            icon: Icons.assignment,
            subtitle: "Total Marks: 500",
            action: const MyLabelChip(
              text: 'Pass',
              color: MyColors.activeGreen,
            ),
            list: [
              ListTileDetails(
                  field: 'Total Marks Obtained',
                  value: '382',
                  icon: const Icon(Icons.numbers)),
              ListTileDetails(
                  field: 'Percentage',
                  value: '78.25',
                  icon: const Icon(Icons.percent_rounded)),
              ListTileDetails(
                  field: 'Rank',
                  value: '2nd',
                  icon: const Icon(Icons.show_chart_rounded)),
            ],
            color: MyColors.activeBlue,
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildPersonalDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MySizes.sm,
          ),
          Text(
            'Basic Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Date of Birth', '4th July 2003'),
          buildTextColumn('Nationality', 'Indian'),
          buildTextColumn('Religion', 'Hindu'),
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Language Spoken',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: MyLists.languageOptions
                .asMap() // Convert the list to a map to get indices
                .entries
                .map((entry) => MyLabelChip(
                      text: entry.value, // Access the text value
                      color: MyColors
                          .colorList[entry.key % MyColors.colorList.length],
                      //color: SchoolColors.activeBlue,
                    ))
                .toList(),
          ),
          const SizedBox(
            height: MySizes.lg,
          ),
          Text(
            'Physical & Health Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.sm,
          ),
          buildTextColumn('Gender', 'Male'),
          buildTextColumn('Blood Group', 'B+'),
          buildTextColumn('Height', '5 ft 6 inch'),
          buildTextColumn('Weight', '60KG'),
          buildTextColumn('Vision Condition', 'Wear Glasses'),
          buildTextColumn('Physical Disability', 'No'),
          const SizedBox(
            height: MySizes.md,
          ),
          Text(
            'Medical Conditions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: MySizes.md,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: ['Asthma', 'Diabetes', 'Heart Condition']
                .asMap() // Convert the list to a map to get indices
                .entries
                .map((entry) => MyLabelChip(
                      text: entry.value, // Access the text value
                      color: MyColors.colorList[entry.key %
                          MyColors.colorList
                              .length], // Use modulo for cycling colors
                    ))
                .toList(),
          ),
          const SizedBox(
            height: MySizes.lg,
          ),
        ],
      ),
    );
  }

  final String qrData = "https://your-link.com";

  Widget buildBackCard() {
    return Container(
      padding: const EdgeInsets.all(MySizes.lg + 24),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius:
            const BorderRadius.all(Radius.circular(MySizes.cardRadiusMd)),
        gradient: const LinearGradient(
          colors: [Color(0xff1191FD), Color(0xff5E59F2)],
        ),
      ),
      child: Column(
        children: [
          Center(
              child: QrImageView(
            data: 'aryankr_04',
            version: QrVersions.auto,
            size: 260,
            gapless: false,
            backgroundColor: MyDynamicColors.white,
            dataModuleStyle: const QrDataModuleStyle(
                color: MyColors.primaryColor,
                dataModuleShape: QrDataModuleShape.circle),
            eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle, color: MyColors.primaryColor),
            embeddedImage: const AssetImage('assets/logos/avatar.png'),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(80, 80),
            ),
          )),
          const SizedBox(
            height: MySizes.sm,
          ),
          Text('@aryankr_04',
              style: Theme.of(Get.context!).textTheme.headlineMedium?.copyWith(
                    color: MyDynamicColors.white,
                  )),
          const SizedBox(
            height: MySizes.lg,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                  vertical: MySizes.sm + 4, horizontal: MySizes.md),
              decoration: BoxDecoration(
                color: MyDynamicColors.white,
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Scan QR",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: MyDynamicColors.activeBlue)),
                  const SizedBox(
                    width: MySizes.md,
                  ),
                  const Icon(
                    Icons.document_scanner_rounded,
                    color: MyColors.activeBlue,
                    size: 22,
                  )
                ],
              ),
            ),
          ),
          // Text('Aryan Kumar',
          //     style: Theme.of(Get.context!).textTheme.headlineMedium?.copyWith(color: SchoolDynamicColors.white,))
        ],
      ),
    );
  }

  // Builds the Profile Header section with avatar and general details
  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildProfileCard(context),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 52.5,
            backgroundColor: Colors.white,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logos/avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 65, // Adjust this value to overlap the CircleAvatar
            left: 0,
            right: -320,
            child: CircleAvatar(
              radius: 52.5,
              backgroundColor: Colors.white.withOpacity(0.1),
            )),
        Positioned(
            top: -20, // Adjust this value to overlap the CircleAvatar
            left: -350,
            right: 0,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            )),
        Positioned(
            top: 60, // Adjust this value to overlap the CircleAvatar
            left: -310,
            right: 0,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.1),
            )),
        Positioned(
          top: 40, // Adjust this value to overlap the CircleAvatar
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 52.5,
            backgroundColor: Colors.white,
            child: Container(
              width: 100, // Diameter of the CircleAvatar
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logos/avatar.png'),
                  fit: BoxFit
                      .contain, // Ensures the image covers the circle without distortion
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Builds the profile card with details
  Widget _buildProfileCard(BuildContext context) {
    return MyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildCardCoverEditButton(),
          const SizedBox(height: 60),
          _buildProfileText('Aryan Kumar', 'aryankr_04'),
          const SizedBox(height: MySizes.md),
          _buildInfoRow(['12', 'C', '10', '122473'],
              ['Class', 'Sec', 'Roll no.', 'Adm No.']),
          const MyDottedLine(
            dashLength: 4,
            dashGapLength: 4,
            lineThickness: 1,
            dashColor: Colors.grey,
          ),
          _buildInfoRow(['934M', '76', '463B', '237'],
              ['Followers', 'Following', 'Likes', 'Posts']),
          const SizedBox(height: MySizes.md),
          _buildFollowMessageButtons(),
        ],
      ),
    );
  }

  Widget _buildCardCoverEditButton() {
    return Container(
      height: 100,
      alignment: Alignment.topRight,
      padding:
          const EdgeInsets.only(right: MySizes.md, top: MySizes.md),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MySizes.cardRadiusMd),
          topRight: Radius.circular(MySizes.cardRadiusMd),
        ),
        gradient: LinearGradient(
          colors: [Color(0xff1191FD), Color(0xff5E59F2)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MyButton(
              text: 'Edit',
              onPressed: () {},
              height: Get.width * 0.08,
              width: Get.width * 0.25,
              backgroundColor: Colors.white,
              hasShadow: false,
              textStyle: Theme.of(context).textTheme.bodyLarge,
              // textColor: SchoolColors.subtitleTextColor,
              icon: const Icon(
                color: MyColors.darkerGrey,
                Icons.edit,
                size: 18,
              )),
        ],
      ),
    );
  }

  Widget _buildProfileText(String name, String username) {
    return Column(
      children: [
        Text(name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: MyDynamicColors.headlineTextColor)),
        Text(username,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: MyDynamicColors.subtitleTextColor)),
      ],
    );
  }

  Widget _buildInfoRow(List<String> values, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(values.length, (index) {
          return _buildTextColumn2(context, values[index], labels[index]);
        }),
      ),
    );
  }

  Widget _buildTextColumn2(BuildContext context, String text1, String text2) {
    return Column(
      children: [
        Text(text1, style: Theme.of(context).textTheme.titleLarge),
        Text(text2,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: MyColors.subtitleTextColor)),
      ],
    );
  }

  // Follow and Message buttons
  Widget _buildFollowMessageButtons() {
    return Padding(
      padding: const EdgeInsets.all(MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!isPrivate)
            Expanded(
              child: MyButton(
                text: 'Follow',
                onPressed: () {},
                borderSide: const BorderSide(color: MyColors.activeBlue),
                borderRadius: MySizes.cardRadiusMd,
              ),
            ),
          if (!isPrivate) const SizedBox(width: 24),
          Expanded(
              child: MyButton(
            isOutlined: true,
            text: 'Message',
            textColor: MyColors.activeBlue,
            onPressed: () {},
            borderSide: const BorderSide(color: MyColors.activeBlue),
            borderRadius: MySizes.cardRadiusMd,
          )),
        ],
      ),
    );
  }

  // Generic Text Column builder
  Widget buildTextColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(SchoolSizes.cardRadiusXs),
                color: MyDynamicColors.backgroundColorTintLightGrey,
                shape: BoxShape.circle),
            child: Icon(Icons.person,
                size: 20, color: MyDynamicColors.primaryIconColor),
          ),
          const SizedBox(
            width: MySizes.md,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(title, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
