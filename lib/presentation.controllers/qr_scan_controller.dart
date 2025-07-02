import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hkcoin/presentation.pages/checkout_complete_page.dart';
import 'package:hkcoin/presentation.pages/register_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScannerController {
  QRScannerController({this.showDialogOnScan = true});

  final bool showDialogOnScan;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  String _scanResult = '';
  ValueNotifier<bool> isCameraInitialized = ValueNotifier(false);
  ValueNotifier<String> scanResult = ValueNotifier('');
  ValueNotifier<bool> isProcessing = ValueNotifier(false);
  ValueNotifier<bool> isFlashOn = ValueNotifier(false);
  ValueNotifier<double> aspectRatio = ValueNotifier(1.0);
  BuildContext? _context;
  bool _isDisposed = false;

  Future<void> initializeCamera(BuildContext context) async {
    try {
      _context = context;
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        scanResult.value = 'No cameras available';
        return;
      }
      _currentCameraIndex = 0;
      await _initializeCameraController();
    } catch (e) {
      scanResult.value = 'Camera initialization error: $e';
      isCameraInitialized.value = false;
    }
  }

  Future<void> _initializeCameraController() async {
    try {
      if (_isDisposed) return;
      _cameraController?.dispose();
      _cameraController = CameraController(
        _cameras[_currentCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      aspectRatio.value = _cameraController!.value.aspectRatio;
      isCameraInitialized.value = true;
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      if (!_cameraController!.value.isStreamingImages && _context != null) {
        await _cameraController!.startImageStream(
          (image) => _processCameraImage(image, context: _context!),
        );
      }
      if (!_isDisposed) isCameraInitialized.value = true;
    } catch (e) {
      if (!_isDisposed) {
        isCameraInitialized.value = false;
        scanResult.value = 'Camera setup error: $e';
      }
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    isCameraInitialized.value = false;
    await _initializeCameraController();
  }

  Future<void> toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    try {
      _isFlashOn = !_isFlashOn;
      isFlashOn.value = _isFlashOn;
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      scanResult.value = 'Flash toggle error: $e';
    }
  }

  Future<void> _processCameraImage(
    CameraImage image, {
    required BuildContext context,
  }) async {
    if (_isProcessing || _isDisposed) return;
    _isProcessing = true;
    isProcessing.value = true;

    try {
      final inputImage = await _convertCameraImage(image);
      final barcodes = await _barcodeScanner
          .processImage(inputImage)
          .timeout(const Duration(seconds: 2), onTimeout: () => []);

      if (barcodes.isNotEmpty) {
        _scanResult = barcodes.first.displayValue ?? 'No data';
        scanResult.value = _scanResult;
        if (showDialogOnScan) {
          await handleScannedResult(context, _scanResult);
        }
      }
    } catch (e) {
      if (!_isDisposed) {
        _scanResult = 'Error scanning QR code: $e';
        scanResult.value = _scanResult;
      }     
    } finally {
      _isProcessing = false;
      if (!_isDisposed) isProcessing.value = false;
    }
  }

  Future<InputImage> _convertCameraImage(CameraImage image) async {
  final WriteBuffer allBytes = WriteBuffer();
  for (Plane plane in image.planes) {
    allBytes.putUint8List(plane.bytes);
  }
  final bytes = allBytes.done().buffer.asUint8List();

  final Size imageSize = Size(
    image.width.toDouble(),
    image.height.toDouble(),
  );

  final imageRotation =
      InputImageRotationValue.fromRawValue(
              _cameras[_currentCameraIndex].sensorOrientation) ??
          InputImageRotation.rotation0deg;

  final inputImageData = InputImageMetadata(
    size: imageSize,
    rotation: imageRotation,
    format: InputImageFormat.nv21, // Hoặc InputImageFormat.yuv420 tùy thiết bị
    bytesPerRow: image.planes[0].bytesPerRow,
  );

  return InputImage.fromBytes(
    bytes: bytes,
    metadata: inputImageData,
  );
}

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) {
        scanResult.value = 'No image selected';
        return;
      }

      isProcessing.value = true;
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        _scanResult = barcodes.first.displayValue ?? 'No data';
        scanResult.value = _scanResult;
        await handleScannedResult(context, _scanResult);
      } else {
        _scanResult = 'No QR code found in image';
        scanResult.value = _scanResult;
        _showResultDialog(context, _scanResult);
      }
    } catch (e) {
      _scanResult = 'Error processing image: $e';
      scanResult.value = _scanResult;
      _showResultDialog(context, _scanResult);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> handleScannedResult(BuildContext context, String result) async {
    try {
      if (_isDeeplinkUrl(result)) {
        final uri = Uri.parse(result);
        await checkDeeplink(uri);
        return;
      }
      else if (_isValidUrl(result)) {
        await _handleExternalUrl(context, result);
        return;
      } 
      else if (showDialogOnScan) {
        _showResultDialog(context, result);
      }
    } catch (e) {
      return;
    }
  }

  bool _isDeeplinkUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return ((uri.path.contains('register') && uri.queryParameters.containsKey('refcode')) || 
              (uri.path.contains('ipay') && uri.queryParameters.containsKey('orderid')));
    } catch (e) {
      return false;
    }
  }

  Future<void> checkDeeplink(Uri uri) async {
    String? destinationPath;
    var query = '';

    switch (uri.scheme) {
      case "https":
      case "http":
        if (uri.path.contains("register")) {
          destinationPath = "register";
        } else if (uri.path.contains("ipay")) {
          destinationPath = "ipay";
        }
        query = uri.query;
        break;

      case "vn.app.hkcoin":
        destinationPath = uri.host + uri.path;
        query = uri.query;
      default:
        break;
    }

    if (destinationPath != null) {      
      try {
        // if (_context != null) {
        //   Navigator.of(_context!).pop();          
        // } else {          
        //   Get.back(); // Fallback: Sử dụng Get.back() nếu _context không khả dụng
        // }
        stopScanning();
        //dispose();
        await handleLink(destinationPath, query);
        //dispose();
      } catch (e) {}
    }
  }

  Future<void> handleLink(String destinationPath, String query) async {
    switch (destinationPath) {
      case "register":
        Get.toNamed(RegisterPage.route, arguments: _toQueryMap(query));
        break;
      case "ipay":      
        var queryMap = _toQueryMap(query);       
        final orderid = queryMap['orderid'] ?? '';   
        Get.toNamed(CheckoutCompletePage.route, arguments: orderid);
        break;
      default:
    }
  }

  Map<String, dynamic> _toQueryMap(String query) {
    Map<String, dynamic> map = {};
    List<String> items = query.split("&");
    for (var i = 0; i < items.length; i++) {
      String key = items[i].split("=").first;
      String value = items[i].split("=").last;
      map.addEntries({key: value}.entries);
    }
    return map;
  }

  Future<void> _handleExternalUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showResultDialog(context, 'Cannot launch URL: $url');
      }
    } catch (e) {
      _showResultDialog(context, 'Error launching URL: $e');
    }
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme.isNotEmpty &&
          (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  void _showResultDialog(BuildContext context, String result) {
    try {
      stopScanning();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Scan Result'),
          content: SingleChildScrollView(
            child: SelectableText(result),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: result));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
                Navigator.pop(context);
                startScanning(context: context);
              },
              child: const Text('Copy'),
            ),
          ],
        ),
      );
    } catch (ex) {}
  }

  void startScanning({required BuildContext context}) {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_cameraController!.value.isStreamingImages) {
      _context = context;
      _cameraController!.startImageStream(
        (image) => _processCameraImage(image, context: context),
      );
      scanResult.value = '';
    }
  }

  void stopScanning() {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        _cameraController!.value.isStreamingImages) {
      _cameraController!.stopImageStream();
      _cameraController!.dispose();
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        _cameraController!.stopImageStream();
      }
      _cameraController!.dispose();
      _cameraController = null;
    }
    stopScanning();
    //_cameraController?.dispose();
    _barcodeScanner.close();
    isCameraInitialized.dispose();
    scanResult.dispose();
    isProcessing.dispose();
    isFlashOn.dispose();
    aspectRatio.dispose();
    _context = null;
    debugPrint('QRScannerController disposed');
  }

  CameraController? get cameraController => _cameraController;
}