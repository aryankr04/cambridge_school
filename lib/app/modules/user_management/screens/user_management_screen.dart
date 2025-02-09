import 'package:cambridge_school/app/modules/user_management/models/user_model.dart';
import 'package:cambridge_school/app/modules/user_management/repositories/user_management_repository.dart';
import 'package:cambridge_school/app/modules/user_management/screens/student_user_list.dart';
import 'package:cambridge_school/app/modules/user_management/widgets/user_card_widget.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/dropdown_field.dart';
import 'package:cambridge_school/core/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/theme/widget_themes/tab_bar_theme.dart';
import '../../../../core/widgets/dialog_dropdown.dart';
import '../../../../core/widgets/search_field.dart';
import '../models/class_repository_model.dart';

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

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  final RxString selectedClass = ''.obs;
  final RxString selectedSection = ''.obs;
  final RxList<UserModelMain> students = <UserModelMain>[].obs;

  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {}

  Widget _buildStickyHeader(String text, {double indent = 8.0}) {
    return Container(
      padding: EdgeInsets.fromLTRB(indent, 8.0, 8.0, 4.0),
      color: Colors.grey[200], // Or any color you want for the header
      width: double.infinity, // Make it span the width
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(MySizes.lg),
                  child: MySearchField(
                    hintText: 'Search users...',
                    onSelected: (String value) {},
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
                    child: TabBar(
                      controller: tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
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
                        ]),
                  ),
                ),
                pinned: true,
                floating: true,
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              StudentListScreen(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
            ],
          ),
        ),
      ),
    );
  }
}
