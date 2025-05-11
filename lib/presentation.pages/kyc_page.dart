import 'package:flutter/material.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/widgets/document_camera_frame/ui/page/document_camera_frame.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});
  static String route = "/kyc";

  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  bool isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var trueHeight = scrSize(context).width / (9 / 16);
    if (trueHeight > scrSize(context).height) {
      trueHeight = scrSize(context).height;
    }
    return isInit
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: trueHeight,
              child: DocumentCameraFrame(
                // Document frame dimensions
                frameWidth: 300,
                frameHeight: 300 / (8.5 / 5.6),

                // Callback when the document is captured
                onCaptured: (imgPath) {
                  debugPrint('Captured image path: $imgPath');
                },

                // Callback when the document is saved
                onSaved: (imgPath) {
                  debugPrint('Saved image path: $imgPath');
                },

                // Callback when the retake button is pressed
                onRetake: () {
                  debugPrint('Retake button pressed');
                },

                // Optional: Customize Capture button, Save button, etc. if needed
              ),
            ),
          ],
        )
        : const Center(child: LoadingWidget());
  }
}
