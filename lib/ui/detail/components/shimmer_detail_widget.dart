import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerStoryDetail extends StatelessWidget {
  const ShimmerStoryDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              height: 160.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              height: 42.0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
