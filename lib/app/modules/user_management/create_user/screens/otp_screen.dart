import 'dart:async';

import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends GetView<OtpController> {
  // Convert to GetView
  final String verificationId;
  final String mobileNo;
  final Function(String) onOtpEntered;

  const OtpScreen(
      {super.key,
      required this.verificationId,
      required this.onOtpEntered,
      required this.mobileNo});

  @override
  Widget build(BuildContext context) {
    Get.put(OtpController(
        verificationId: verificationId,
        onOtpEntered: onOtpEntered)); // Initialize controller

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.headlineTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Verification",
            style: MyTextStyles.headlineSmall
                .copyWith(color: MyColors.headlineTextColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                child: SvgPicture.asset(
                    'assets/images/illustrations/verify_otp.svg'),
              ),
              const SizedBox(height: MySizes.lg),
              Text(
                "Enter Verification Code",
                style: MyTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MyColors.headlineTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.sm),
              Text(
                textAlign: TextAlign.center,
                "We've sent a 6-digit OTP to +91 $mobileNo. Enter it below to verify your account.",
                style: MyTextStyles.bodySmall.copyWith(),
              ),
              const SizedBox(height: MySizes.xl+16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MySizes.lg),
                child: PinFieldAutoFill(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  codeLength: 6,
                  decoration: BoxLooseDecoration(
                    strokeWidth: 2,
                    gapSpace: 10,
                    textStyle: MyTextStyles.headlineSmall
                        .copyWith(color: MyColors.headlineTextColor),
                    strokeColorBuilder: FixedColorBuilder(
                        MyColors.subtitleTextColor.withOpacity(0.5)),
                    bgColorBuilder: const FixedColorBuilder(Colors.transparent),
                  ),
                  currentCode: controller.currentOtp.value,
                  onCodeSubmitted: (code) {},
                  onCodeChanged: (code) {
                    if (code != null && code.length == 6) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.currentOtp.value = code;
                    }
                  },
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwSections+16),
              MyButton(
                text: 'Verify OTP',
                onPressed: () {
                  if (controller.currentOtp.value.length == 6) {
                    controller.onOtpEntered(controller.currentOtp.value);
                  }
                },
              ),
              const SizedBox(height: MySizes.sm+4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't get the OTP?",
                      style: MyTextStyles.bodyMedium.copyWith(fontSize: 14,color: MyColors.captionTextColor)),
                  Obx(
                    () => TextButton(
                      onPressed: controller.isResendEnabled.value
                          ? controller.onResendPressed
                          : null,
                      child: Text(
                        controller.isResendEnabled.value
                            ? "Resend OTP"
                            : "Resend OTP in ${controller.resendTimer.value} seconds",
                        style: MyTextStyles.bodyMedium.copyWith(
                          color: controller.isResendEnabled.value
                              ? MyColors.activeBlue
                              : MyColors.subtitleTextColor,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpController extends GetxController with CodeAutoFill {
  final String verificationId;
  final Function(String) onOtpEntered;

  OtpController({required this.verificationId, required this.onOtpEntered});

  TextEditingController otpController = TextEditingController();
  RxString currentOtp = "".obs;
  String? appSignatureID;
  bool _isDisposed = false;
  bool _isListening = false;

  final RxBool isResendEnabled = false.obs;
  final RxInt resendTimer = 15.obs;

  @override
  void onInit() {
    super.onInit();
    SmsAutoFill().getAppSignature.then((signature) {
      appSignatureID = signature;
    });
    _startListening();
    _startResendTimer();
    listenForCode(); // Start listening for code immediately
  }

  @override
  void onClose() {
    _isDisposed = true;
    otpController.dispose();
    SmsAutoFill().unregisterListener();
    super.onClose();
  }

  Future<void> _startListening() async {
    if (_isListening) return;

    _isListening = true;

    try {
      await SmsAutoFill().listenForCode();
    } catch (e) {
      print("Error listening for code: $e");
    } finally {
      _isListening = false;
    }
  }

  void _startResendTimer() {
    isResendEnabled.value = false;
    resendTimer.value = 15;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      resendTimer.value--;

      if (resendTimer.value <= 0) {
        timer.cancel();
        if (!_isDisposed) {
          isResendEnabled.value = true;
        }
      }
    });
  }

  void onResendPressed() {
    _startListening();
    _startResendTimerExtended();
  }

  void _startResendTimerExtended() {
    isResendEnabled.value = false;
    resendTimer.value = 30;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      resendTimer.value--;

      if (resendTimer.value <= 0) {
        timer.cancel();
        if (!_isDisposed) {
          isResendEnabled.value = true;
        }
      }
    });
  }

  @override
  void codeUpdated() {
    currentOtp.value = code ?? ''; // Update observable variable
    if (code != null && code!.length == 6) {
      onOtpEntered(code!);
    }
  }
}
