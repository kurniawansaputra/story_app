import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerStoryCard extends StatelessWidget {
  const ShimmerStoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context)
            .colorScheme
            .secondaryFixedDim
            .withAlpha((0.3 * 255).toInt()),
        highlightColor: Theme.of(context)
            .colorScheme
            .secondaryFixedDim
            .withAlpha((0.6 * 255).toInt()),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16.0),
          ),
          width: double.infinity,
          height: 160.0,
        ),
      ),
    );
  }
}
