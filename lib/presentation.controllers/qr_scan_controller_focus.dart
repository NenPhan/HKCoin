import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

// Controller để quản lý logic quét QR
class QRScannerController {
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
  ValueNotifier<bool> isFocused = ValueNotifier(false);
  ValueNotifier<Offset> frameOffset = ValueNotifier(Offset.zero);
  ValueNotifier<Size> frameSize = ValueNotifier(
    const Size(300, 300),
  ); // Increased default size
  ValueNotifier<Rect?> qrBoundingBox = ValueNotifier<Rect?>(null);
  bool _isScanning = false;
  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _currentCameraIndex = 0;
      await _initializeCameraController();
    }
  }

  Future<void> _initializeCameraController() async {
    _cameraController?.dispose();
    _cameraController = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    isCameraInitialized.value = true;
    if (_isFlashOn) {
      await _cameraController!.setFlashMode(FlashMode.torch);
    } else {
      await _cameraController!.setFlashMode(FlashMode.off);
    }
    _cameraController!.startImageStream(_processCameraImage);
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    isCameraInitialized.value = false;
    await _initializeCameraController();
  }

  Future<void> toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    _isFlashOn = !_isFlashOn;
    isFlashOn.value = _isFlashOn;
    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || !_isScanning) return;
    _isProcessing = true;
    isProcessing.value = true;

    try {
      final inputImage = _convertCameraImage(image);
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first;
        final boundingBox = barcode.boundingBox;
        final screenWidth = image.width.toDouble();
        final screenHeight = image.height.toDouble();

        // Tính kích thước và vị trí của mã QR
        final qrLeft = boundingBox.left.toDouble();
        final qrTop = boundingBox.top.toDouble();
        final qrWidth = boundingBox.width.toDouble();
        final qrHeight = boundingBox.height.toDouble();
        final qrRight = qrLeft + qrWidth;
        final qrBottom = qrTop + qrHeight;

        // Lưu vị trí mã QR để vẽ viền
        qrBoundingBox.value = Rect.fromLTWH(qrLeft, qrTop, qrWidth, qrHeight);

        // Đặt khung quét để bao quanh mã QR với padding
        const padding = 30.0; // Increased padding
        final newWidth = qrWidth + padding;
        final newHeight = qrHeight + padding;
        final offsetX = qrLeft - padding / 2;
        final offsetY = qrTop - padding / 2;

        final maxOffsetX = screenWidth - newWidth;
        final maxOffsetY = screenHeight - newHeight;
        frameOffset.value = Offset(
          offsetX.clamp(0, maxOffsetX),
          offsetY.clamp(0, maxOffsetY),
        );
        frameSize.value = Size(newWidth, newHeight);

        // Kiểm tra focus với điều kiện nới lỏng hơn
        const sizeTolerance = 0.5; // Further relaxed tolerance
        final isSizeFit =
            qrWidth >= 150 * sizeTolerance &&
            qrWidth <= 400 * 2.0 &&
            qrHeight >= 150 * sizeTolerance &&
            qrHeight <= 400 * 2.0;
        final isPositionFit =
            qrLeft >= offsetX - 50 &&
            qrRight <= offsetX + newWidth + 50 &&
            qrTop >= offsetY - 50 &&
            qrBottom <= offsetY + newHeight + 50;
        isFocused.value = isSizeFit && isPositionFit;

        // Debugging logs
        // print('QR Box: $qrBoundingBox');
        //print('Frame Size: ${frameSize.value}, Frame Offset: ${frameOffset.value}');
        //print('isSizeFit: $isSizeFit, isPositionFit: $isPositionFit, isFocused: ${isFocused.value}');

        // Chỉ đọc kết quả khi đã focus
        if (isFocused.value) {
          _scanResult = barcode.displayValue ?? 'No data';
          scanResult.value = _scanResult;
        } else {
          _scanResult = '';
          scanResult.value = '';
        }
      } else {
        isFocused.value = false;
        _scanResult = '';
        scanResult.value = '';
        frameOffset.value = Offset.zero;
        frameSize.value = const Size(300, 300);
        qrBoundingBox.value = null;
        print('No barcodes detected');
      }
    } catch (e) {
      _scanResult = 'Error: $e';
      scanResult.value = _scanResult;
      isFocused.value = false;
      frameOffset.value = Offset.zero;
      frameSize.value = const Size(300, 300);
      qrBoundingBox.value = null;
      print('Error processing image: $e');
    } finally {
      _isProcessing = false;
      isProcessing.value = false;
    }
  }

  InputImage _convertCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    // Handle camera rotation
    final rotation =
        _cameraController!.description.sensorOrientation == 90
            ? InputImageRotation.rotation90deg
            : InputImageRotation.rotation0deg;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
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
      }
    } catch (e) {
      _scanResult = 'Error: $e';
      scanResult.value = _scanResult;
      _showResultDialog(context, _scanResult);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> handleScannedResult(BuildContext context, String result) async {
    if (_isRegisterRefCodeUrl(result)) {
      await _handleRegisterRefCode(context, result);
    } else if (_isValidUrl(result)) {
      await _handleExternalUrl(context, result);
    } else {
      _showResultDialog(context, result);
    }
  }

  bool _isRegisterRefCodeUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.path.contains('register') &&
          uri.queryParameters.containsKey('refcode');
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleRegisterRefCode(BuildContext context, String url) async {
    // final uri = Uri.parse(url);
    // final refCode = uri.queryParameters['refcode'] ?? '';

    Navigator.of(
      context,
      rootNavigator: true,
    ).popUntil((route) => route.isFirst);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => RegisterPage(refCode: refCode),
    //   ),
    // );
  }

  Future<void> _handleExternalUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showResultDialog(context, 'Không thể mở URL: $url');
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
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Scan result'),
            content: SelectableText(result),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: result));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Copied')));
                  Navigator.pop(context);
                },
                child: const Text('Copy'),
              ),
            ],
          ),
    );
  }

  void startScanning() {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_isScanning) {
      _isScanning = true;
      _cameraController!.startImageStream(_processCameraImage);
      scanResult.value = '';
      isFocused.value = false;
      frameOffset.value = Offset.zero;
      frameSize.value = const Size(300, 300);
      qrBoundingBox.value = null;
      print('Started scanning');
    }
  }

  void stopScanning() {
    if (_isScanning) {
      _isScanning = false;
      _cameraController?.stopImageStream();
      print('Stopped scanning');
    }
  }

  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    isCameraInitialized.dispose();
    scanResult.dispose();
    isProcessing.dispose();
    isFlashOn.dispose();
    isFocused.dispose();
    frameOffset.dispose();
    frameSize.dispose();
    qrBoundingBox.dispose();
    print('Controller disposed');
  }

  CameraController? get cameraController => _cameraController;
}
