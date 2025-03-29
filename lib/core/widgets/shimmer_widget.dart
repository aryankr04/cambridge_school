import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  final int itemCount;
  final int? gridCrossAxisCount; // For grid layouts
  final double? itemWidth;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final BorderRadius? itemBorderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection shimmerDirection;
  final BoxShape itemShape; // Circle, Rectangle or custom
  final Widget Function(BuildContext, int)? itemBuilder;
  final Axis scrollDirection;

  // Customizable constructor
  const MyShimmer({
    super.key,
    required this.itemCount,
    this.gridCrossAxisCount,
    this.itemWidth,
    this.itemHeight,
    this.itemPadding,
    this.itemBorderRadius,
    this.baseColor,
    this.highlightColor,
    this.shimmerDirection = ShimmerDirection.ttb,
    this.itemShape = BoxShape.rectangle,
    this.itemBuilder,
    this.scrollDirection = Axis.vertical,
  });


  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      direction: shimmerDirection,
      period: const Duration(milliseconds: 1000),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (gridCrossAxisCount != null) {
      return GridView.builder(
        scrollDirection: scrollDirection,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCrossAxisCount!,
          childAspectRatio: (itemWidth != null && itemHeight != null) ? itemWidth! / itemHeight! : 1.0,  // added childAspectRatio
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (itemBuilder != null) {
            return itemBuilder!(context, index);
          }
          return _buildShimmerItem();
        },
      );
    } else {
      return ListView.builder(
        scrollDirection: scrollDirection,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (itemBuilder != null) {
            return itemBuilder!(context, index);
          }
          return _buildShimmerItem();
        },
      );
    }
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: itemPadding ?? EdgeInsets.zero,
      child: Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: baseColor ?? Colors.grey.shade300,
          borderRadius: itemBorderRadius ?? BorderRadius.zero,
          shape: itemShape,
        ),
      ),
    );
  }
}

class MyShimmers extends StatelessWidget {
  final String text;
  final double height;
  final EdgeInsetsGeometry? itemPadding;

  const MyShimmers(
      {super.key, required this.text, required this.height, this.itemPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: itemPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          MyShimmer(
            itemCount: 1,
            itemWidth: double.infinity,
            itemHeight: height,
            itemBorderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
          ),
        ],
      ),
    );
  }
}