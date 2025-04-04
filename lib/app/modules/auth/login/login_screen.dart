import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/button.dart';
import '../../../../core/widgets/text_field.dart';
import 'login_controller.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Start point

    // First wave trough
    path.quadraticBezierTo(
      size.width * 0.25, size.height - 80, // Control point for peak
      size.width * 0.5, size.height - 40, // End point (trough)
    );

    // Second wave trough
    path.quadraticBezierTo(
      size.width * 0.75, size.height, // Control point for peak
      size.width, size.height - 40, // End point (trough)
    );

    path.lineTo(size.width, 0); // Right edge
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Login extends StatelessWidget {
  Login({super.key});

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff1191FD), Color(0xff5E59F2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      )
                    ]),
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logos/csd.png'),
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text('Cambridge School Dumraon',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    color: MyDynamicColors.whiteTextColor,
                                    fontSize: 26))),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: MySizes.lg, right: MySizes.lg, bottom: MySizes.lg),
            child: Column(
              children: [
                const SizedBox(
                  height: MySizes.lg,
                ),
                const Text("Welcome back you've been missed!",
                    style: MyTextStyle.headlineMedium),
                const SizedBox(
                  height: MySizes.lg,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Login',
                      style: MyTextStyle.headlineLarge.copyWith(
                          color: MyColors.activeBlue,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: MySizes.lg,
                ),
                MyTextField(
                  labelText: 'Mobile No',
                  prefixText: '+91  ',
                  prefixTextStyle: MyTextStyle.inputField,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                  controller: Get.find<LoginController>().usernameController,
                ),

                const SizedBox(
                  height: MySizes.sm,
                ),
                Obx(
                  () => controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MyButton(
                          text: 'Login',
                          onPressed: () {
                            controller.login();
                          },
                        ),
                ),
                const SizedBox(
                  height: MySizes.lg,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.createUserRoute);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Doesn't have an account?",
                          style: MyTextStyle.labelMedium.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        Text(' Create an account',
                            style: MyTextStyle.bodyLarge.copyWith(
                              color: MyColors.activeBlue,
                            )),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
