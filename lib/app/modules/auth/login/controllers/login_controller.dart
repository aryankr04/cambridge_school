import 'package:cambridge_school/core/utils/helpers/helper_functions.dart';
import 'package:cambridge_school/core/widgets/icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final RxBool isObscure = true.obs;

  final RxBool isLoading = false.obs;

  Future<void> login() async {}

  Future<void> _attemptAutoLogin(
      String? email, String? password, SharedPreferences prefs) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      await prefs.setBool('isLoggedIn', true);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., invalid credentials)
      print('Error during automatic login: ${e.message}');
      Get.offAllNamed('/login');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

}
