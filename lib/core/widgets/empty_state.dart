import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants/text_styles.dart';

class MyEmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String message;
  final TextStyle? textStyle;
  final double svgSize;

  const MyEmptyStateWidget({
    super.key,
    required this.type,
    required this.message,
    this.textStyle,
    this.svgSize = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.md),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              type.assetPath,
              width: svgSize,
              height: svgSize,
            ),
            Text(
              message,
              style: textStyle ??
                  MyTextStyle.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
enum EmptyStateType {
  noData('assets/images/illustrations/empty_state_illustration/e_commerce_3.svg'),
  noInternet('assets/images/illustrations/empty_state_illustration/connectivity_1.svg'),
  error('assets/images/illustrations/state_illustration/404_illustration.svg'),
  emptyCart('assets/images/illustrations/empty_state_illustration/connectivity_1.svg');

  final String assetPath;
  const EmptyStateType(this.assetPath);
}
