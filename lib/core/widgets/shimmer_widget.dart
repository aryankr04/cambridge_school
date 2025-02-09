import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class MyShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection shimmerDirection;
  final bool isCircular;

  // Constructor to accept customization parameters
  const MyShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor = MyColors.softGrey,
    this.highlightColor = MyColors.white,
    this.shimmerDirection = ShimmerDirection.ttb,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    // Define the shape based on the `isCircular` parameter or the `borderRadius`
    final shape = isCircular
        ? BoxShape.circle
        : BoxShape.rectangle;

    return Shimmer.fromColors(
      baseColor: baseColor, // The base color of the shimmer
      highlightColor: highlightColor, // The highlight color of the shimmer
      direction: shimmerDirection, // Direction of the shimmer
      period: const Duration(milliseconds: 2000), // Shimmer animation duration
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius ?? BorderRadius.zero,
          shape: shape, // Shape is either circle or rectangle
        ),
      ),
    );
  }
}
