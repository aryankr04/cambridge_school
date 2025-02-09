import 'package:carousel_slider/carousel_slider.dart'; // Correct import
import 'package:flutter/material.dart';

import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';


class MyCarouselSliderWithIndicator extends StatefulWidget {
  final List<dynamic> images;

  const MyCarouselSliderWithIndicator({
    super.key,
    required this.images,
  });

  @override
  _MyCarouselSliderWithIndicatorState createState() =>
      _MyCarouselSliderWithIndicatorState();
}

class _MyCarouselSliderWithIndicatorState
    extends State<MyCarouselSliderWithIndicator> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  Widget _buildImage(dynamic image) {
    if (image is String) {
      // If the image is a URL
      return Image.network(image, fit: BoxFit.fill);
    } else if (image is AssetImage) {
      // If the image is an asset
      return SizedBox(
        width: double.infinity,
        height: MySizes.imageCarouselHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
          child: Image(image: image, fit: BoxFit.cover),
        ),
      );
    } else {
      throw ArgumentError('Invalid image type');
    }
  }

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
            (index) => Container(
          width: _currentIndex == index ? 7 : 6,
          height: _currentIndex == index ? 7 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? MyDynamicColors.white
                : MyDynamicColors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          color: MyDynamicColors.backgroundColorWhiteLightGrey,
          child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: MySizes.imageCarouselHeight,
              enableInfiniteScroll: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: widget.images
                .map<Widget>((dynamic item) => _buildImage(item))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        _buildCarouselIndicator(),
      ],
    );
  }
}
