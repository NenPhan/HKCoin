import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppSkeleton extends StatelessWidget {
  final List<SkeletonBlock> blocks;

  const AppSkeleton({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Column(children: blocks.map(_buildBlock).toList()),
    );
  }

  Widget _buildBlock(SkeletonBlock block) {
    return Container(
      margin: block.margin,
      padding: block.padding,
      decoration: BoxDecoration(
        color: block.hasBackground ? Colors.white : Colors.transparent,
        borderRadius: block.borderRadius,
      ),
      child: Column(children: block.rows.map(_buildRow).toList()),
    );
  }

  Widget _buildRow(SkeletonRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: row.alignment,
        children:
            row.items.map((item) {
              Widget box = Container(
                height: item.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: item.borderRadius,
                ),
              );

              if (item.expand) {
                box = Expanded(child: box);
              } else if (item.width != null) {
                box = SizedBox(width: item.width, child: box);
              }

              return Padding(
                padding: EdgeInsets.only(right: row.spacing),
                child: box,
              );
            }).toList(),
      ),
    );
  }
}

class SkeletonItem {
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final bool expand;

  const SkeletonItem({
    this.width,
    required this.height,
    this.expand = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });
}

class SkeletonRow {
  final List<SkeletonItem> items;
  final double spacing;
  final MainAxisAlignment alignment;

  const SkeletonRow({
    required this.items,
    this.spacing = 8,
    this.alignment = MainAxisAlignment.start,
  });
}

class SkeletonBlock {
  final List<SkeletonRow> rows;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final bool hasBackground;

  const SkeletonBlock({
    required this.rows,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.hasBackground = true,
  });
}
