//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/news.dart';
import 'package:hkcoin/presentation.pages/news_details_page.dart';
import 'package:hkcoin/widgets/shimmer_container.dart';

class NewsListWidget extends StatefulWidget {
  const NewsListWidget({
    super.key,
    required this.news,
    required this.isLoading,
  });
  final List<News> news;
  final bool isLoading;

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        return SpacingColumn(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("Common.Entity.NewsItem"),
              style: textTheme(context).titleSmall,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    widget.isLoading ? 10 : widget.news.length,
                    (index) {
                      if (widget.isLoading) {
                        return SizedBox(
                          width: itemWidth,
                          child: const ShimmerContainer(height: 200),
                        );
                      }                      
                      final newsItem = widget.news[index];                      
                      return SizedBox(
                        width: itemWidth,
                        child: GestureDetector(
                          onTap: () {                                                      
                            Get.toNamed(
                              NewsDetailPage.route,
                              arguments: newsItem.id
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey[900],
                              child: SpacingColumn(
                                children: [
                                  Image.network(
                                    newsItem.imageUrl,
                                    fit: BoxFit.cover,
                                    width: itemWidth,
                                    height: itemWidth * 0.66, // 2:3 aspect ratio
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                      scrSize(context).width * 0.03,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          newsItem.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: textTheme(context)
                                              .bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          newsItem.shortDescription,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: textTheme(context)
                                              .bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
