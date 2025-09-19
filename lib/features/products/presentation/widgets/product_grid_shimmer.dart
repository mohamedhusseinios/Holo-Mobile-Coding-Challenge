import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            child: Column(
              children: const [
                Expanded(child: ColoredBox(color: Colors.white30)),
                SizedBox(height: 12),
                ColoredBox(
                  color: Colors.white30,
                  child: SizedBox(height: 16, width: 100),
                ),
                SizedBox(height: 8),
                ColoredBox(
                  color: Colors.white30,
                  child: SizedBox(height: 12, width: 60),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
