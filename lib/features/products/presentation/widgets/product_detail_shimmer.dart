import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AspectRatio(
              aspectRatio: 1,
              child: ColoredBox(color: Colors.white30),
            ),
            SizedBox(height: 24),
            ColoredBox(
              color: Colors.white30,
              child: SizedBox(height: 24, width: 220),
            ),
            SizedBox(height: 16),
            ColoredBox(
              color: Colors.white30,
              child: SizedBox(height: 16, width: 140),
            ),
            SizedBox(height: 16),
            ColoredBox(
              color: Colors.white30,
              child: SizedBox(height: 18, width: double.infinity),
            ),
            SizedBox(height: 12),
            ColoredBox(
              color: Colors.white30,
              child: SizedBox(height: 18, width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
