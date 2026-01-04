import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/data.models/services/store_service.dart';
import 'package:hkcoin/gen/assets.gen.dart';
import 'package:hkcoin/presentation.controllers/splash_controller.dart';
import 'package:hkcoin/widgets/base64_image_view.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static String route = '/splash';

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find<SplashController>();
    final StoreService storeService = Get.find<StoreService>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColorDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ================= LOGO =================
            Obx(() {
              final store = storeService.store.value;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 650),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child:
                    controller.showLogo.value
                        ? _buildLogo(store)
                        : const SizedBox(
                          key: ValueKey("logo-placeholder"),
                          height: 120,
                        ),
              );
            }),

            const SizedBox(height: 28),

            // ================= PROGRESS BAR =================
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: controller.progress.value,
                  minHeight: 4,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }),

            const SizedBox(height: 14),

            // ================= PERCENT =================
            Obx(() {
              final percent =
                  (controller.progress.value * 100).clamp(0, 100).toInt();

              return Text(
                "$percent%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),

            const SizedBox(height: 6),

            // ================= STATUS =================
            Obx(() {
              return Text(
                controller.status.value,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= LOGO BUILDER =================
  Widget _buildLogo(store) {
    if (store?.iconLogoUrl != null && store!.iconLogoUrl!.isNotEmpty) {
      return Base64ImageView(
        key: const ValueKey("store-logo"),
        base64: store.iconLogoUrl,
        width: 120,
      );
    }

    return Hero(
      tag: "main-logo",
      child: Assets.icons.hkcLogoIcon.image(height: 60),
    );
  }
}
