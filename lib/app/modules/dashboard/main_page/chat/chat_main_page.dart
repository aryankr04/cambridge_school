import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../../core/utils/helpers/helper_functions.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/theme/widget_themes/tab_bar_theme.dart';
import 'calls/calls.dart';
import 'chats/chats.dart';
import 'groups/groups.dart';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({Key? key}) : super(key: key);

  @override
  State<ChatMainPage> createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyDynamicColors.backgroundColorPrimaryDarkGrey,
          leading: const Icon(Icons.mark_chat_read_outlined,
              color: MyDynamicColors.white),
          title: const Text(
            'Chatoo',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: MyDynamicColors.white),
          ),
          actions: const [
            Icon(Icons.search_rounded,color: Colors.white,),
            SizedBox(width: MySizes.lg),
            Icon(Icons.more_vert,color: Colors.white,),
            SizedBox(
              width: MySizes.lg,
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Theme(
              data: Theme.of(context).copyWith(
                tabBarTheme: MyTabBarTheme.defaultTabBarTheme,
              ),
              child: TabBar(
                controller: tabController,
                labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
                unselectedLabelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Chats'),
                  Tab(text: 'Groups'),
                  Tab(text: 'Status'),
                  Tab(text: 'Calls'),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  // Chats Screen
                  Chats(),

                  // Groups Screen
                  // Groups(),
                  //
                  // // Status Screen
                  // Status(),
                  //
                  // // Calls Screen
                  // Calls()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
