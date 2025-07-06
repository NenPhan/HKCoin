// Widget để hiển thị giao diện quét QR
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/presentation.controllers/qr_scan_controller.dart';

class QRScannerWidget extends StatefulWidget {
  final QRScannerController controller;
  final Function(String)? onScanResult;

  const QRScannerWidget({Key? key, required this.controller, this.onScanResult})
    : super(key: key);

  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.initializeCamera(context);
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // Ứng dụng chuyển vào nền, dừng luồng camera
      widget.controller.stopScanning();
    } else if (state == AppLifecycleState.resumed) {
      // Ứng dụng trở lại, khởi động lại luồng camera
      widget.controller.startScanning(context: context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => widget.controller.pickImageFromGallery(context),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: widget.controller.switchCamera,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.controller.isFlashOn,
            builder: (context, isFlashOn, child) {
              return IconButton(
                icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
                onPressed: widget.controller.toggleFlash,
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (!widget.controller.isProcessing.value) {
            widget.controller.startScanning(
              context: context,
            ); // Khởi động lại quét khi bấm
          }
        },
        child: Stack(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.controller.isCameraInitialized,
              builder: (context, initialized, child) {
                if (!initialized ||
                    widget.controller.cameraController == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(widget.controller.cameraController!),
                );
              },
            ),
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.amber, width: 2),
                //   borderRadius: BorderRadius.circular(8),
                // ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: _buildCornerDecoration(),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: math.pi / 2,
                        child: _buildCornerDecoration(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Transform.rotate(
                        angle: -math.pi / 2,
                        child: _buildCornerDecoration(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: math.pi,
                        child: _buildCornerDecoration(),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: 250 * _animation.value,
                          left: 0,
                          right: 0,
                          child: Container(height: 2, color: Colors.amber[900]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ValueListenableBuilder<String>(
                valueListenable: widget.controller.scanResult,
                builder: (context, result, child) {
                  if (result.isNotEmpty && widget.onScanResult != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onScanResult!(result);
                      // widget.controller.handleScannedResult(context, result);
                    });
                  }
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      result.isEmpty ? 'Scanning...' : result,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerDecoration() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFFF6F00), width: 2),
          left: BorderSide(color: Color(0xFFFF6F00), width: 2),
        ),
      ),
    );
  }
}
