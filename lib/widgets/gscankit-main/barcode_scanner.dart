library barcode_scanner;

/// Re-export mobile_scanner core types
export 'package:mobile_scanner/mobile_scanner.dart'
    show
        MobileScannerController,
        BarcodeCapture,
        Barcode,
        TorchState,
        MobileScannerException;

/// Main scanner widget
export 'lib/gscankit.dart';

/// Gallery button type
export 'lib/src/widgets/gallery_button.dart' show GalleryButtonType;

export 'lib/src/widgets/torch_toggle_button.dart' show TorchToggleButton;
export 'lib/qr_result_handler.dart'
    show QrResultHandler, ScanResultAction, UniversalQrHandler, ScanPurpose;

/// Overlay & UI config
export 'lib/src/overlay/overlay.dart'
    show
        GscanOverlayConfig,
        ScannerScanArea,
        ScannerBorder,
        ScannerBorderPulseEffect,
        ScannerOverlayBackground,
        ScannerLineAnimation;
