import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class ScanToastBus {
  static final ValueNotifier<ScanToastData?> toast =
      ValueNotifier<ScanToastData?>(null);

  static Timer? _timer;

  static void show({
    String? title,
    required String content,
    ScanToastPosition position = ScanToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
  }) {
    _timer?.cancel();

    toast.value = ScanToastData(
      title: title,
      content: content,
      position: position,
      duration: duration,
    );

    _timer = Timer(duration, () {
      toast.value = null;
    });
  }

  static void hide() {
    _timer?.cancel();
    toast.value = null;
  }

  static void dispose() {
    _timer?.cancel();
    toast.dispose();
  }
}

enum ScanToastPosition { top, center, bottom }

class ScanToastData {
  final String? title;
  final String content;
  final ScanToastPosition position;
  final Duration duration;

  const ScanToastData({
    this.title,
    required this.content,
    this.position = ScanToastPosition.bottom,
    this.duration = const Duration(seconds: 2),
  });
}
