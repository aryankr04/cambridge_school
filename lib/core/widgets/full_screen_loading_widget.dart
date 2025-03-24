import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MyFullScreenLoading {
  static final RxBool _isLoading = false.obs;

  static void show({String loadingText = 'Processing'}) async {
    if (_isLoading.value) return; // Prevent multiple dialogs

    _isLoading.value = true; // Mark loading as started

    await Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button dismissal
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(MySizes.md),
              child: Padding(
                padding: const EdgeInsets.all(MySizes.lg),
                child: IntrinsicWidth( // Ensures minimum required width
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/animations/book_loading.json',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: MySizes.md),
                      Row(
                        mainAxisSize: MainAxisSize.min, // Avoid unnecessary space
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loadingText,
                            style: MyTextStyle.headlineSmall.copyWith(
                              color: MyColors.activeBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const AnimatedText('.....'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black45, // Softer overlay
    );


    // Reset loading state AFTER dialog is closed
    _isLoading.value = false;
  }

  static void hide() {
    if (_isLoading.value) {
      if (Get.isDialogOpen!) {
        Get.back(); // Close the dialog
      }
      _isLoading.value = false; // Reset loading state
    }
  }
}

class AnimatedText extends StatefulWidget {
  final String text;

  const AnimatedText(this.text, {super.key});

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _characterCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _characterCount.value),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: MyColors.activeBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        );
      },
    );
  }
}