import 'package:flutter/material.dart';

class MyProfileImage extends StatelessWidget {
  final String imageUrl; // Image URL or asset path
  final double? radius; // Radius for circular profile image
  final BoxFit boxFit; // BoxFit for scaling the image
  final Color? borderColor; // Border color for the profile image
  final double? borderWidth; // Border width for the profile image
  final BoxShadow? boxShadow; // Box shadow for the profile image
  final String? placeholder; // Placeholder image while loading
  final bool isAsset; // Flag to indicate whether the image is an asset or URL
  final Color? backgroundColor; // Background color of the profile picture if no image is provided

  const MyProfileImage({
    super.key,
    required this.imageUrl,
    this.radius = 40.0, // Default radius for profile image
    this.boxFit = BoxFit.cover,
    this.borderColor = Colors.blue,
    this.borderWidth = 2.0,
    this.boxShadow,
    this.placeholder = 'assets/placeholder.png', // Default placeholder if not specified
    this.isAsset = false, // If true, the image will be loaded from assets
    this.backgroundColor = Colors.grey, // Background color if image is missing
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // If it's an asset image
    if (isAsset) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: Image.asset(
          imageUrl,
          width: radius! * 2, // 2x radius for width and height
          height: radius! * 2,
          fit: boxFit,
          errorBuilder: (context, error, stackTrace) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child: const Icon(Icons.error, color: Colors.white),
            );
          },
        ),
      );
    } else {
      // If it's a network image, use FadeInImage for loading
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: FadeInImage.assetNetwork(
          placeholder: placeholder!, // Use a placeholder while the image loads
          image: imageUrl,
          width: radius! * 2, // 2x radius for width and height
          height: radius! * 2,
          fit: boxFit,
          imageErrorBuilder: (context, error, stackTrace) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              child: const Icon(Icons.error, color: Colors.white),
            );
          },
        ),
      );
    }

    // Apply border and shadow styling
    return Container(
      width: radius! * 2,
      height: radius! * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor!,
          width: borderWidth!,
        ),
        boxShadow: boxShadow != null ? [boxShadow!] : [],
      ),
      child: imageWidget,
    );
  }
}
