import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/data.models/news_detail.dart';
import 'package:hkcoin/presentation.controllers/news_detail_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key});
  static String route = "/news-detail";

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {  
    final NewsDetailController controller = Get.put(
    NewsDetailController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.data == null) {
            return Center(
              child: Text(
                'No news details available',
                style: textTheme(context).bodyMedium,
              ),
            );
          }
          final newsDetail = controller.data!;                
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseAppBar(title: "NewsDetails.Title"),
                if (newsDetail.imageContent?.thumbUrl != null)
                  Hero(
                    tag: "news${newsDetail.id}",
                    child: Image.network(
                       _getSafeImageUrl(newsDetail.imageContent),                   
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(scrSize(context).width * 0.03),
                  margin: EdgeInsets.all(scrSize(context).width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SpacingColumn(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        newsDetail.name,
                        style: textTheme(context).titleLarge?.copyWith(
                              fontSize: scrSize(context).width * 0.08,
                            ),
                      ),
                      if (newsDetail.shortDescription.isNotEmpty)
                        Text(
                          newsDetail.shortDescription,
                          style: textTheme(context).bodyMedium,
                        ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(scrSize(context).width * 0.01),
                  margin: EdgeInsets.all(scrSize(context).width * 0.01),
                  child: SpacingColumn(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (newsDetail.fullDescription.isNotEmpty)                      
                      Html(
                        data: newsDetail.fullDescription,
                        style: {
                          '*': Style(
                            fontSize: FontSize(textTheme(context).bodyMedium!.fontSize!),
                            color: textTheme(context).bodyMedium!.color,
                          ),
                          'img': Style(
                            margin: Margins.symmetric(vertical: 10),
                          ),
                        },
                        extensions: [
                          TagExtension(
                            tagsToExtend: {"img"},
                            builder: (context) {
                              final src = context.attributes['src'];
                              if (src == null || src.isEmpty) return const SizedBox.shrink();

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Image.network(
                                      src,
                                      width: constraints.maxWidth, // full width
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Text('Cant not loading image!'),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      )
                      
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
String _getSafeImageUrl(ImageContent? imageContent) {
  if (imageContent == null || imageContent.thumbUrl == null) {
    return ''; // Return empty string or placeholder URL
  }

  final url = imageContent.thumbUrl!;
  
  // Handle cases where URL is already complete
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  
  // Handle protocol-relative URLs (//example.com/image.jpg)
  if (url.startsWith('//')) {
    return 'https:$url';
  }
  
  // Handle relative paths (/images/photo.jpg)
  if (url.startsWith('/')) {
    return 'https://sanbox.hakacoin.net$url'; // Replace with your base URL
  }
  
  // Default case - assume it needs https:// prefix
  return 'https://$url';
}