import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FacebookShimmer extends StatelessWidget {
  const FacebookShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(3, (index) => _shimmerItem(width)),
        ),
      ),
    );
  }

  Widget _shimmerItem(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row avatar + 2 lines
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBlock(width * 0.45, 12),
                    const SizedBox(height: 6),
                    _shimmerBlock(width * 0.30, 12),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Body lines
            _shimmerBlock(width * 0.95, 12),
            const SizedBox(height: 8),
            _shimmerBlock(width * 0.85, 12),
            const SizedBox(height: 8),
            _shimmerBlock(width * 0.75, 12),

            const SizedBox(height: 16),

            // Huge image block
            Container(
              height: 200,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBlock(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
