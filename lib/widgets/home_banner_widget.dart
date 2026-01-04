import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/data.models/product.dart';
import 'package:hkcoin/data.models/slide.dart';
import 'package:hkcoin/presentation.controllers/home_body_controller.dart';
import 'package:hkcoin/presentation.pages/product_detail_page.dart';
import 'package:hkcoin/widgets/app_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSlideWidget extends StatefulWidget {
  const HomeSlideWidget({
    super.key,
    this.isLoading = false,
    required this.slides,
  });
  final bool isLoading;
  final List<Slide> slides;

  @override
  State<HomeSlideWidget> createState() => _HomeSlideWidgetState();
}

class _HomeSlideWidgetState extends State<HomeSlideWidget> {
  PageController controller = PageController(viewportFraction: 1);

  @override
  void initState() {
    if (widget.slides.length > 1) {
      controller = PageController(viewportFraction: 0.9);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || widget.slides.isEmpty) {
      return const WalletInfoShimmer();
    }
    return SizedBox(
      height: 180,
      child: PageView(
        controller: controller,
        allowImplicitScrolling: true,
        padEnds: false,

        children: List.generate(widget.slides.length, (index) {
          String url = widget.slides[index].image?.thumbUrl ?? "";
          return GestureDetector(
            onTap: () {
              if (widget.slides[index].route != null) {
                if (widget.slides[index].route!.routeName == "/product") {
                  var homeBodyController = Get.find<HomeBodyController>();
                  Product? product = homeBodyController.products
                      .firstWhereOrNull(
                        (e) => e.id == widget.slides[index].route!.routeId,
                      );
                  if (product != null) {
                    Get.toNamed(
                      ProductDetailPage.route,
                      arguments: ProductDetailPageParam(product: product),
                    );
                  }
                } else {
                  Get.toNamed(
                    widget.slides[index].route!.routeName ?? "",
                    arguments: widget.slides[index].route!.routeId,
                  );
                }
              } else {
                _launchUrl(widget.slides[index].slideUrl);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  // width: 150,
                  // height: 150,
                  child: AppImage(
                    url: _getSafeImageUrl(url), // ⭐ URL hợp lệ
                    aspectRatio: 16 / 9,
                    fit: BoxFit.cover,
                    hideOnError: true,
                    lazyLoad: false,
                    enableBorderRadius: false,
                  ),
                  // Base64ImageView(
                  //   base64: imgBase64,
                  //   fit: BoxFit.cover,
                  //   width: double.infinity,
                  // ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // Xử lý khi không thể mở URL
        _showSnackBar('Could not launch $url', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getSafeImageUrl(String imageUrl) {
    if (imageUrl.startsWith("http")) return imageUrl;
    if (imageUrl.startsWith("//")) return "https:$imageUrl";
    if (imageUrl.startsWith("/")) return "https://api.hakacoin.net$imageUrl";
    return "https://$imageUrl";
  }
}

class WalletInfoShimmer extends StatelessWidget {
  const WalletInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Row(children: [Expanded(child: _column(size))]),
    );
  }

  Widget _column(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== ROW 1: TITLE =====
        _box(width: size.width, height: size.width * .42),
      ],
    );
  }

  Widget _box({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
