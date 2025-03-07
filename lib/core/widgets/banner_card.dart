import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyBannerCard extends StatelessWidget {
  final String title;
  final String? description;
  final String buttonText;
  final dynamic icon;
  final LinearGradient gradient;
  final VoidCallback onPressed;

  const MyBannerCard({
    super.key,
    required this.title,
    this.description,
    required this.buttonText,
    this.icon,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null)
              ...[
                if (icon is String)
                  SvgPicture.asset(
                    icon,
                    height: 60,
                    placeholderBuilder: (context) =>
                    const CircularProgressIndicator(),
                  )
                else if (icon is Icon)
                  icon
                else if (icon is Text)
                    icon,
                const SizedBox(width: MySizes.lg),
              ],
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: Get.width * 0.3,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: gradient.colors.first,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(buttonText, style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
