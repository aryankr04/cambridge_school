import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  final String imageUrl; // Image URL or asset path
  final double? width; // Width of the image
  final double? height; // Height of the image
  final BoxFit boxFit; // BoxFit for scaling the image
  final BorderRadius? borderRadius; // Border radius to round the corners
  final Color? borderColor; // Border color for the image
  final double? borderWidth; // Border width for the image
  final BoxShadow? boxShadow; // Box shadow for the image
  final String? placeholder; // Placeholder image while loading
  final bool isAsset; // Flag to indicate whether the image is an asset or URL

  const MyImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.boxFit = BoxFit.cover,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.placeholder = 'assets/placeholder.png', // Default placeholder if not specified
    this.isAsset = false, // If true, the image will be loaded from assets
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // If it's an asset image
    if (isAsset) {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: boxFit,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        },
      );
    } else {
      // If it's a network image, use FadeInImage for loading
      imageWidget = FadeInImage.assetNetwork(
        placeholder: placeholder!, // Use a placeholder while the image loads
        image: imageUrl,
        width: width,
        height: height,
        fit: boxFit,
        imageErrorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        },
      );
    }

    // Apply styling (border, shadow, etc.)
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth!)
              : null,
          boxShadow: boxShadow != null ? [boxShadow!] : [],
        ),
        child: imageWidget,
      ),
    );
  }
}
