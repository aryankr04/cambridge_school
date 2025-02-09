import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_student0_controller.dart';

class StudentStep8FormController extends GetxController {
  final GlobalKey<FormState> step8FormKey = GlobalKey<FormState>();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isObscure = true.obs;
}
