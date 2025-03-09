// lib/app/modules/onboarding/onboarding_screen.dart

import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/sizes.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key}); // Added Key? key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView for onboarding screens
            Obx(() => controller.currentPage.value != 3
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: MySizes.lg, top: MySizes.lg),
                      child: TextButton(
                        onPressed: () {
                          controller.pageController.jumpToPage(4);
                          const Duration(milliseconds: 400);
                          Curves.easeInOut;
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                itemCount: controller.onboardingData.length,
                itemBuilder: (context, index) => OnboardingPage(
                  image: controller.onboardingData[index]["image"]!,
                  title: controller.onboardingData[index]["title"]!,
                  description: controller.onboardingData[index]["description"]!,
                ),
              ),
            ),
            // Smooth Page Indicator
            SmoothPageIndicator(
              controller: controller.pageController,
              count: controller.onboardingData.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: MyColors.activeBlue,
                dotColor: MyColors.activeBlue.withOpacity(0.25),
              ),
            ),
            SizedBox(
              height: Get.width * 0.1,
            ),
            Obx(() => controller.currentPage.value <
                    controller.onboardingData.length - 1
                ? MyButton(
                    text: 'Next',
                    onPressed: () {
                      controller.nextPage();
                    },
                    width: Get.width * 0.5,
                  )
                : const SizedBox()),
            SizedBox(
              height: Get.width * 0.1,
            )
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SVG Image with responsive sizing
        SizedBox(
          height: title == "Get Started With Us!"
              ? MediaQuery.of(context).size.width * 0.9
              : MediaQuery.of(context).size.width * 1.1,
          width: Get.width,
          child: SvgPicture.asset(
            image,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(MySizes.md),
          child: Column(
            children: [
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.sm),
              // Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              if (title == "Get Started With Us!")
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      // Login Button
                      MyButton(
                        onPressed: () => Get.toNamed(AppRoutes.loginRoute),
                        text: "Login",
                      ),
                      const SizedBox(height: MySizes.md),
                      // Register Button
                      MyButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.createUserRoute);
                        },
                        text: 'Create Account',
                        textColor: MyColors.activeBlue,
                        isOutlined: true,
                        borderSide: const BorderSide(
                            width: 1, color: MyColors.activeBlue),
                      ),
                      const SizedBox(
                        height: MySizes.md,
                      ),
                      MyButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.createUserRoute);
                        },
                        text: 'Continue as a Guest',
                        isOutlined: true,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
