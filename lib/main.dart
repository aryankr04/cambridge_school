
import 'package:cambridge_school/app/modules/attendance/attendance_record/attendance_record_screen.dart';
import 'package:cambridge_school/navigation_screen.dart';
import 'package:cambridge_school/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/attendance/mark_attendance/user_attendance_model.dart';
import 'app/modules/leave/leave_request/leave_request_screen.dart';
import 'app/modules/routine0/routine_controller.dart';
import 'app/modules/user_management/create_user/models/user_model.dart';
import 'core/utils/theme/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("🔥 Firebase initialized successfully!");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _getAppTheme(context),
      getPages: AppRoutes.routes,
      home: NavigationScreen(),
      //home: RoutineManagementScreen(),
    );
  }
}

// Function to get the appropriate theme
ThemeData _getAppTheme(BuildContext context) {
  final Brightness brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.light
      ? MyAppTheme.lightTheme
      : MyAppTheme.darkTheme;
}

// Optimized function to fetch user details with better debugging
Future<UserModel?> _fetchUserDetails(String userId) async {
  debugPrint("🟢 Fetching user details for: $userId");

  try {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!doc.exists) {
      debugPrint("❌ User document not found.");
      return null;
    }

    final data = doc.data();
    debugPrint("✅ User document found: $data");

    return data != null ? UserModel.fromMap(data) : null;
  } catch (e) {
    debugPrint("🚨 Error fetching user details: $e");
    return null;
  }
}
