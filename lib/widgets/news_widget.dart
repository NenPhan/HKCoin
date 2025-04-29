import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/news.dart';
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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                widget.isLoading ? 10 : widget.news.length,
                (index) {
                  News? newsItem;
                  if (!widget.isLoading) {
                    newsItem = widget.news[index];
                  }

                  return SizedBox(
                    width: (cons.maxWidth - 10) / 2,
                    child:
                        widget.isLoading
                            ? const ShimmerContainer(height: 200)
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.grey[900],
                                child: SpacingColumn(
                                  children: [
                                    Image.network(
                                      newsItem?.imageUrl ?? "",
                                      fit: BoxFit.fitWidth,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(
                                        scrSize(context).width * 0.03,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            newsItem?.name ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: textTheme(
                                              context,
                                            ).bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            newsItem?.shortDescription ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: textTheme(
                                              context,
                                            ).bodySmall?.copyWith(
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
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
