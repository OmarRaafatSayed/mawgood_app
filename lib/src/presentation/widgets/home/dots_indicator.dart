import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DotsIndicatorMap extends StatelessWidget {
  const DotsIndicatorMap({
    super.key,
    required this.controller,
    required this.current,
    required this.sliderImages,
  });

  final CarouselSliderController controller;
  final int current;
  final List<Map<String, String>> sliderImages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderImages.asMap().entries.map((entry) {
        final isSelected = current == entry.key;
        return GestureDetector(
          onTap: () => controller.animateToPage(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 12.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DotsIndicatorList extends StatelessWidget {
  const DotsIndicatorList({
    super.key,
    required this.controller,
    required this.current,
    required this.sliderImages,
  });

  final CarouselSliderController controller;
  final int current;
  final List<String> sliderImages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderImages.asMap().entries.map((entry) {
        final isSelected = current == entry.key;
        return GestureDetector(
          onTap: () => controller.animateToPage(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 12.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
        );
      }).toList(),
    );
  }
}
