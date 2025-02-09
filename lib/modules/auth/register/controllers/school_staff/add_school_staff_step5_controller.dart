import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolStaffStep5FormController extends GetxController {
  final GlobalKey<FormState> step5FormKey = GlobalKey<FormState>();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isObscure = true.obs;
  final RxInt remainingTime = 15.obs;
  Timer? countdownTimer;
  final TextEditingController otpEditingController = TextEditingController();
  final RxString messageOtpCode = ''.obs;
  String verificationId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() async {
    super.onInit();
    //print(await SmsAutoFill().getAppSignature);
    //await SmsAutoFill().listenForCode();
  }

  @override
  void onReady() {
    super.onReady();
    startCountdown();
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    otpEditingController.dispose();
    super.onClose();
  }

  void startCountdown() {
    remainingTime.value = 15;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> sendOtp(String phoneNumber) async {
    phoneNumber = formatPhoneNumber(phoneNumber);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Error", e.message!);
      },
      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        startCountdown();
        Get.snackbar("Success", "OTP sent to $phoneNumber");
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp
      );
      await _auth.signInWithCredential(credential);
      Get.snackbar("Success", "OTP verified successfully!");
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP. Please try again.");
    }
  }

  void resendOtp(String phoneNumber) {
    sendOtp(phoneNumber);
  }

  bool isFormValid() {
    return step5FormKey.currentState?.validate() ?? false;
  }
  String formatPhoneNumber(String phoneNumber) {
    // Check if the number already starts with +91, if not, add it
    if (!phoneNumber.startsWith('+91')) {
      return '+91$phoneNumber';
    }
    return phoneNumber;
  }

}
