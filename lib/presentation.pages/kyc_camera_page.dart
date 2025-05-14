import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/widgets/document_camera_frame/ui/page/document_camera_frame.dart';
import 'package:hkcoin/widgets/loading_widget.dart';

class KycCameraPage extends StatefulWidget {
  const KycCameraPage({super.key});
  static String route = "/kyc-camera";

  @override
  State<KycCameraPage> createState() => _KycCameraPageState();
}

class _KycCameraPageState extends State<KycCameraPage> {
  bool isInit = true;
  PhotoRatio photoRatio = PhotoRatio.cid;

  @override
  void initState() {
    if (Get.arguments is PhotoRatio) {
      photoRatio = Get.arguments as PhotoRatio;
    }
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
                frameWidth: photoRatio == PhotoRatio.cid ? 300 : 300,
                frameHeight:
                    (photoRatio == PhotoRatio.cid
                        ? 300 / (8.5 / 5.6)
                        : 300 / (4 / 6)),

                // Callback when the document is captured
                onCaptured: (imgPath) {
                  debugPrint('Captured image path: $imgPath');
                },

                // Callback when the document is saved
                onSaved: (imgPath) {
                  debugPrint('Saved image path: $imgPath');
                  Get.back(result: imgPath);
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

enum PhotoRatio { portrait, cid }
