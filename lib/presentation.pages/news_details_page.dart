import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/data.models/news_detail.dart';
import 'package:hkcoin/presentation.controllers/news_detail_controller.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/app_image.dart';
import 'package:hkcoin/widgets/facebook_shimmer.dart';
import 'package:hkcoin/widgets/html_image_extension.dart';
import 'package:hkcoin/widgets/scroll_to_top_button.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key});
  static String route = "/newsitem";

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final NewsDetailController controller = Get.put(NewsDetailController());
  final ScrollController _scrollController = ScrollController(); // ✅ THÊM
  bool isNightMode = true;
  double contentFontSize = 16;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: isNightMode ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.data == null) {
            return const FacebookShimmer();
          }

          if (controller.data == null) {
            return Center(
              child: Text(
                "No news details available",
                style: textTheme(context).bodyMedium,
              ),
            );
          }

          final news = controller.data!;
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseAppBar(
                      title: "NewsDetails.Title",
                      actionWidget: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            _fontButton("A-", () {
                              setState(() {
                                if (contentFontSize > 12) contentFontSize -= 2;
                              });
                            }),
                            const SizedBox(width: 4),
                            _fontButton("A+", () {
                              setState(() {
                                if (contentFontSize < 28) contentFontSize += 2;
                              });
                            }),
                            //const SizedBox(width: 4),
                            // _nightModeButton(), // NEW BUTTON
                          ],
                        ),
                      ),
                      actionAlignment: Alignment.centerRight,
                    ),
                    // ---------------- IMAGE ----------------
                    if (news.imageContent?.thumbUrl != null) ...[
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: AppImage(
                          url: _getSafeImageUrl(
                            news.imageContent,
                          ), // ⭐ URL hợp lệ
                          aspectRatio: 16 / 9,
                          fit: BoxFit.cover,
                          hideOnError: true,
                          lazyLoad: false,
                          enableBorderRadius: false,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // ---------------- TITLE + FONT BUTTONS ----------------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              style: textTheme(context).titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: contentFontSize + 4,
                                color:
                                    isNightMode ? Colors.white : Colors.black,
                              ),
                              child: Text(news.name),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (news.shortDescription.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                width: 3,
                                color:
                                    isNightMode
                                        ? Colors.white.withOpacity(0.35)
                                        : Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.6),
                              ),
                            ),
                          ),
                          child: Text(
                            news.shortDescription,
                            style: textTheme(context).bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color:
                                  isNightMode
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.75),
                            ),
                          ),
                        ),
                      ),

                    // ---------------- HTML CONTENT ----------------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.035),
                      child: Html(
                        data: news.fullDescription,
                        style: {
                          "*": Style.fromTextStyle(
                            textTheme(context).bodyMedium!.copyWith(
                              fontSize: contentFontSize,
                              height: 1.5,
                              color:
                                  isNightMode
                                      ? Colors.white70
                                      : textTheme(context).bodyMedium!.color,
                            ),
                          ).copyWith(display: Display.block),
                          "p": Style(
                            margin: Margins.only(bottom: 12),
                            display: Display.block,
                          ),
                        },

                        extensions: [
                          buildHtmlImageExtension(maxWidth: (width * 0.89)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
              ScrollToTopButton(
                controller: _scrollController,
                label: "Common.ToTop",
                backgroundColor: Colors.black.withOpacity(0.7),
                textColor: Colors.white,
                iconColor: Colors.white,
                scale: 1.05,
              ),
            ],
          );
        }),
      ),
    );
  }

  // ---------------- FONT SIZE BUTTON ----------------
  Widget _fontButton(String type, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.4),
            width: 0.8,
          ),
        ),
        child: Text(
          type,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _nightModeButton() {
    return GestureDetector(
      onTap: () {
        setState(() => isNightMode = !isNightMode);
      },
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isNightMode
                  ? Colors.amber.withOpacity(0.25)
                  : Colors.black.withOpacity(0.20),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.8),
        ),
        child: Icon(
          isNightMode ? Icons.light_mode : Icons.dark_mode,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ---------------- URL FIXER ----------------
String _getSafeImageUrl(ImageContent? imageContent) {
  if (imageContent == null || imageContent.thumbUrl == null) return "";
  final url = imageContent.thumbUrl!;
  if (url.startsWith("http")) return url;
  if (url.startsWith("//")) return "https:$url";
  if (url.startsWith("/")) return "https://api.hakacoin.net$url";
  return "https://$url";
}

// class NewsDetailPage extends StatefulWidget {
//   const NewsDetailPage({super.key});
//   static String route = "/newsitem";

//   @override
//   State<NewsDetailPage> createState() => _NewsDetailPageState();
// }

// class _NewsDetailPageState extends State<NewsDetailPage> {
//   final NewsDetailController controller = Get.put(NewsDetailController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: LoadingWidget());
//           }
//           if (controller.data == null) {
//             return Center(
//               child: Text(
//                 'No news details available',
//                 style: textTheme(context).bodyMedium,
//               ),
//             );
//           }
//           final newsDetail = controller.data!;
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const BaseAppBar(title: "NewsDetails.Title"),
//                 if (newsDetail.imageContent?.thumbUrl != null)
//                   Hero(
//                     tag: "news${newsDetail.id}",
//                     child: Image.network(
//                       _getSafeImageUrl(newsDetail.imageContent),
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(scrSize(context).width * 0.03),
//                   margin: EdgeInsets.all(scrSize(context).width * 0.03),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: SpacingColumn(
//                     spacing: 10,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         newsDetail.name,
//                         style: textTheme(context).titleLarge?.copyWith(
//                           fontSize: scrSize(context).width * 0.08,
//                         ),
//                       ),
//                       if (newsDetail.shortDescription.isNotEmpty)
//                         Text(
//                           newsDetail.shortDescription,
//                           style: textTheme(context).bodyMedium,
//                         ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(scrSize(context).width * 0.01),
//                   margin: EdgeInsets.all(scrSize(context).width * 0.01),
//                   child: SpacingColumn(
//                     spacing: 0,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       if (newsDetail.fullDescription.isNotEmpty)
//                         Html(
//                           data: newsDetail.fullDescription,
//                           style: {
//                             '*': Style(
//                               fontSize: FontSize(
//                                 textTheme(context).bodyMedium!.fontSize!,
//                               ),
//                               color: textTheme(context).bodyMedium!.color,
//                             ),
//                             'img': Style(
//                               margin: Margins.symmetric(vertical: 0),
//                             ),
//                           },
//                           extensions: [
//                             TagExtension(
//                               tagsToExtend: {"img"},
//                               builder: (context) {
//                                 final src = context.attributes['src'];
//                                 if (src == null || src.isEmpty) {
//                                   return const SizedBox.shrink();
//                                 }

//                                 return LayoutBuilder(
//                                   builder: (context, constraints) {
//                                     return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 0,
//                                       ),
//                                       child: ConstrainedBox(
//                                         constraints: BoxConstraints(
//                                           maxWidth: constraints.maxWidth,
//                                         ),
//                                         child: Image.network(
//                                           src,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Text(
//                                                     'Cant not loading image!',
//                                                   ),
//                                           loadingBuilder: (
//                                             context,
//                                             child,
//                                             loadingProgress,
//                                           ) {
//                                             if (loadingProgress == null) {
//                                               return child;
//                                             }
//                                             return const Center(
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// String _getSafeImageUrl(ImageContent? imageContent) {
//   if (imageContent == null || imageContent.thumbUrl == null) {
//     return ''; // Return empty string or placeholder URL
//   }

//   final url = imageContent.thumbUrl!;

//   // Handle cases where URL is already complete
//   if (url.startsWith('http://') || url.startsWith('https://')) {
//     return url;
//   }

//   // Handle protocol-relative URLs (//example.com/image.jpg)
//   if (url.startsWith('//')) {
//     return 'https:$url';
//   }

//   // Handle relative paths (/images/photo.jpg)
//   if (url.startsWith('/')) {
//     return 'https://sanbox.hakacoin.net$url'; // Replace with your base URL
//   }

//   // Default case - assume it needs https:// prefix
//   return 'https://$url';
// }
