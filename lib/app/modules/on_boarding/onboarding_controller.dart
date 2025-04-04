
// lib/app/modules/onboarding/onboarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/login/login_screen.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/illustrations/high_school.svg",
      "title": "Your Complete School Hub",
      "description":
      "Welcome to your school app! Access everything you need in one place—grades, schedules, and announcements.",
    },
    {
      "image": "assets/images/illustrations/college_project.svg",
      "title": "Engage & Achieve Together",
      "description":
      "Stay updated on assignments, communicate easily, and achieve success with collaborative learning.",
    },
    {
      "image": "assets/images/illustrations/success.svg",
      "title": "Built for Success & Privacy",
      "description":
      "A secure platform you can trust. Privacy and safety come first for all your school data.",
    },
    {
      "image": "assets/images/illustrations/mobile_login.svg",
      "title": "Get Started With Us!",
      "description":
      "Ready to get started? Log in or register to join our school community!",
    },
  ];

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.off(() => Login()); // Navigate to Login page
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    pageController.jumpToPage(onboardingData.length - 1);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
