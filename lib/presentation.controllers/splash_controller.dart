import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/deep_link_manager.dart';
import 'package:hkcoin/core/firebase_service.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/data.models/services/store_service.dart';
import 'package:hkcoin/localization/localization_service.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';
import 'package:hkcoin/presentation.pages/home_page.dart';
import 'package:hkcoin/presentation.pages/login_page.dart';

/// ================= SPLASH STAGE =================
enum SplashStage {
  idle,
  loadStore,
  applyLanguage,
  initFirebase,
  initDeeplink,
  finalize,
  navigate,
}

/// ================= SPLASH STEP =================
class SplashStep {
  final SplashStage stage;
  final String message;
  final double weight;
  final Curve curve;
  final Future<void> Function() action;

  // timeout + retry
  final Duration timeout;
  final int maxRetry;
  final bool canFail;
  final Future<void> Function()? onTimeout;
  final Future<void> Function(Object error)? onError;

  const SplashStep({
    required this.stage,
    required this.message,
    required this.weight,
    required this.action,
    this.curve = Curves.easeOut,
    this.timeout = const Duration(seconds: 8),
    this.maxRetry = 1,
    this.canFail = false,
    this.onTimeout,
    this.onError,
  });
}

/// ================= SPLASH CONTROLLER =================
class SplashController extends GetxController {
  // UI state
  final RxDouble progress = 0.0.obs;
  final RxString status = "".obs;
  final RxBool showLogo = false.obs;
  final Rx<SplashStage> stage = SplashStage.idle.obs;

  bool _bootstrapped = false;
  late final List<SplashStep> _steps;

  @override
  void onReady() {
    super.onReady();
    if (_bootstrapped) return;
    _bootstrapped = true;

    _initSteps();
    _runStateMachine();
  }

  // ================= INIT STEPS =================
  void _initSteps() {
    _steps = [
      SplashStep(
        stage: SplashStage.loadStore,
        message: tr("Common.Config.Loading.Configuration"),
        weight: 0.35,
        curve: Curves.easeOutCubic,
        timeout: const Duration(seconds: 10),
        maxRetry: 2,
        action: () async {
          await Get.find<StoreService>().loadStore();
        },
      ),

      SplashStep(
        stage: SplashStage.applyLanguage,
        message: tr("Common.Config.Loading.Language"),
        weight: 0.15,
        timeout: const Duration(seconds: 3),
        action: applyLanguage,
      ),

      SplashStep(
        stage: SplashStage.initFirebase,
        message: tr("Common.Config.Loading.Service"),
        weight: 0.25,
        curve: Curves.easeOutQuart,
        timeout: const Duration(seconds: 8),
        maxRetry: 1,
        canFail: true, // 🔥 fail mềm
        onError: (e) async {
          debugPrint("Firebase init failed: $e");
        },
        action: initializeFirebaseService,
      ),

      SplashStep(
        stage: SplashStage.initDeeplink,
        message: tr("Common.Config.Loading.Deeplink"),
        weight: 0.15,
        timeout: const Duration(seconds: 5),
        canFail: true, // 🔥 fail mềm
        action: DeeplinkManager.checkInitLink,
      ),

      SplashStep(
        stage: SplashStage.finalize,
        message: tr("Common.Config.Loading.Complate"),
        weight: 0.10,
        curve: Curves.easeInOut,
        action: () async {
          await Future.delayed(const Duration(milliseconds: 300));
        },
      ),
    ];
  }

  // ================= STATE MACHINE =================
  Future<void> _runStateMachine() async {
    showLogo.value = true;

    for (final step in _steps) {
      stage.value = step.stage;
      status.value = step.message;

      final double start = progress.value;
      final double end = (start + step.weight).clamp(0.0, 1.0);

      // easing chạy song song
      final easingFuture = _easeProgress(
        from: start,
        to: end,
        curve: step.curve,
        duration: const Duration(milliseconds: 900),
      );

      try {
        await _runWithRetry(step: step);
      } catch (e) {
        // ❌ fail cứng → dừng splash
        debugPrint("Splash step failed: ${step.stage} | $e");
        status.value = tr("Common.Error.SystemInitFailed");
        return;
      }

      await easingFuture;
    }

    stage.value = SplashStage.navigate;
    _navigate();
  }

  // ================= RUN WITH TIMEOUT + RETRY =================
  Future<void> _runWithRetry({required SplashStep step}) async {
    int attempt = 0;

    while (true) {
      try {
        attempt++;
        await step.action().timeout(step.timeout);
        return; // ✅ success
      } on TimeoutException {
        if (attempt > step.maxRetry) {
          if (step.onTimeout != null) {
            await step.onTimeout!();
          }
          if (step.canFail) return;
          rethrow;
        }
      } catch (e) {
        if (attempt > step.maxRetry) {
          if (step.onError != null) {
            await step.onError!(e);
          }
          if (step.canFail) return;
          rethrow;
        }
      }
    }
  }

  // ================= EASING PROGRESS =================
  Future<void> _easeProgress({
    required double from,
    required double to,
    required Curve curve,
    required Duration duration,
  }) async {
    const int fps = 60;
    final int frames = (duration.inMilliseconds / (1000 / fps)).round().clamp(
      1,
      120,
    );

    for (int i = 1; i <= frames; i++) {
      final t = i / frames;
      final eased = curve.transform(t);
      progress.value = from + (to - from) * eased;
      await Future.delayed(const Duration(milliseconds: 16));
    }

    progress.value = to;
  }

  // ================= NAVIGATION =================
  void _navigate() {
    final token = Storage().getToken;
    if (token != null) {
      Get.offAllNamed(HomePage.route);
    } else {
      Get.offAllNamed(LoginPage.route);
    }
  }

  // ================= LANGUAGE =================
  Future<void> applyLanguage() async {
    final localeController = Get.find<LocaleController>();
    await localeController.initLocale();

    final locale = localeController.locale;
    await LocalizationService.instance.changeLocale(locale);
    Get.updateLocale(locale);
  }
}
