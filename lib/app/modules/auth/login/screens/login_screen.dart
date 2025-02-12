import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:cambridge_school/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/login_controller.dart';

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
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Login',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontSize: 28, fontWeight: FontWeight.w500))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Enter your mobile number to get login',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: MyColors.captionTextColor)),
                ),
                const SizedBox(
                  height: MySizes.spaceBtwSections,
                ),
                MyTextField(
                  labelText: 'Mobile No',
                  prefixText: '+91  ',
                  prefixTextStyle: MyTextStyles.inputField,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                  controller: Get.find<LoginController>().usernameController,
                ),
                // const SizedBox(
                //   height: MySizes.lg,
                // ),
                // Obx(
                //   () => MyTextField(
                //     labelText: 'Password',
                //     controller: controller.passwordController,
                //     keyboardType: TextInputType.visiblePassword,
                //     obscureText: controller.isObscure.value,
                //     prefixIcon: const Icon(Icons.lock),
                //     suffixIcon: IconButton(
                //       onPressed: () {
                //         controller.isObscure.value =
                //             !controller.isObscure.value;
                //       },
                //       icon: Icon(
                //         controller.isObscure.value
                //             ? Icons.visibility_off
                //             : Icons.visibility,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: MySizes.sm),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     child: Text(
                //       'Forgot Password',
                //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                //           color: MyDynamicColors.primaryColor,
                //           fontWeight: FontWeight.w600),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: MySizes.spaceBtwSections,
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
                  height: MySizes.spaceBtwSections,
                ),
                MyButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.createUser);
                  },
                  text: 'Create Account',
                  textColor: MyColors.activeBlue,
                  isOutlined: true,
                  borderSide:
                      const BorderSide(width: 1, color: MyColors.activeBlue),
                ),
                const SizedBox(
                  height: MySizes.lg,
                ),
                // Row(
                //   children: [
                //     const Expanded(
                //         child: MyDottedLine(
                //       dashColor: MyColors.captionTextColor,
                //     )),
                //     Text(' OR ',
                //         style: Theme.of(context)
                //             .textTheme
                //             .labelLarge
                //             ?.copyWith(color: MyColors.captionTextColor)),
                //     const Expanded(
                //         child: MyDottedLine(
                //       dashColor: MyColors.captionTextColor,
                //     )),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Not a school member? ',
                //       style: MyTextStyles.labelSmall
                //           .copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                //     ),
                //     TextButton(
                //         onPressed: () {},
                //         child: const Text('Continue as a Guest'))
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
