import 'package:flutter/material.dart';

import '../../document_camera_frame.dart';
import 'camera_switcher.dart';
import 'capture_button.dart';

class ActionButtons extends StatelessWidget {
  final double? captureOuterCircleRadius;
  final double? captureInnerCircleRadius;
  final Alignment? captureButtonAlignment;
  final EdgeInsets? captureButtonPadding;
  final EdgeInsets? saveButtonPadding;
  final EdgeInsets? retakeButtonPadding;
  final String? saveButtonText;
  final String? retakeButtonText;
  final TextStyle? saveButtonTextStyle;
  final TextStyle? retakeButtonTextStyle;
  final ButtonStyle? saveButtonStyle;
  final ButtonStyle? retakeButtonStyle;

  final double? saveButtonWidth;
  final double? saveButtonHeight;
  final double? retakeButtonWidth;
  final double? retakeButtonHeight;
  final ValueNotifier<String> capturedImageNotifier;
  final ValueNotifier<bool> isLoadingNotifier;
  final void Function(String imgPath) onSave;
  final VoidCallback? onRetake;
  final double width;
  final double height;
  final double frameWidth;
  final double frameHeight;
  final DocumentCameraController
  controller; // Replace with your controller type
  final Function(String imgPath) onCaptured;
  final Function(String imgPath) onSaved;

  final Function() onCameraSwitched;

  const ActionButtons({
    super.key,
    this.captureInnerCircleRadius,
    this.captureOuterCircleRadius,
    this.captureButtonAlignment,
    this.captureButtonPadding,
    this.saveButtonPadding,
    this.retakeButtonPadding,
    this.saveButtonText,
    this.retakeButtonText,
    this.saveButtonTextStyle,
    this.retakeButtonTextStyle,
    this.saveButtonStyle,
    this.retakeButtonStyle,
    this.saveButtonWidth,
    this.saveButtonHeight,
    this.retakeButtonWidth,
    this.retakeButtonHeight,
    required this.capturedImageNotifier,
    required this.isLoadingNotifier,
    required this.onSave,
    this.onRetake,
    required this.frameWidth,
    required this.frameHeight,
    required this.controller,
    required this.onCaptured,
    required this.onSaved,
    required this.onCameraSwitched,
    required this.width,
    required this.height,
  });

  Future<void> _captureImage(
    Function(String imgPath) onCaptured,
    BuildContext context,
  ) async {
    isLoadingNotifier.value = true;
    await controller.takeAndCropPicture(
      width,
      height,
      frameWidth,
      frameHeight,
      context,
    );

    capturedImageNotifier.value = controller.imagePath;

    onCaptured(controller.imagePath);

    isLoadingNotifier.value = false;
  }

  void _saveImage(Function(String imgPath) onSaved) {
    final imagePath = controller.imagePath;

    onSaved(imagePath);

    controller.resetImage();
  }

  void _retakeImage(VoidCallback? onRetake) {
    if (onRetake != null) {
      onRetake();
    }

    controller.retakeImage();

    capturedImageNotifier.value = controller.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: captureButtonAlignment ?? Alignment.bottomCenter,
      child: ValueListenableBuilder<String>(
        valueListenable: capturedImageNotifier,
        builder: (context, imagePath, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (imagePath.isEmpty)
                Padding(
                  padding:
                      captureButtonPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 32.0,
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 45, height: 45),
                      ValueListenableBuilder<bool>(
                        valueListenable: isLoadingNotifier,
                        builder: (context, isLoading, child) {
                          return CaptureButton(
                            onPressed: () async {
                              // Prevent action if already capturing
                              if (isLoading) return;

                              await _captureImage(onCaptured, context);
                            },
                            captureInnerCircleRadius: captureInnerCircleRadius,
                            captureOuterCircleRadius: captureOuterCircleRadius,
                          );
                        },
                      ),

                      // Camera Switch Button
                      CameraSwitcher(onTap: onCameraSwitched),
                    ],
                  ),
                )
              else ...[
                Padding(
                  padding:
                      saveButtonPadding ?? const EdgeInsets.only(bottom: 20.0),
                  child: ActionButton(
                    text: saveButtonText ?? 'Use this photo',
                    onPressed: () => _saveImage(onSaved),
                    style:
                        retakeButtonStyle ??
                        ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(width: 1, color: Colors.white),
                        ),
                    textStyle:
                        retakeButtonTextStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                    width: saveButtonWidth,
                    height: saveButtonHeight,
                  ),
                ),
                Padding(
                  padding:
                      retakeButtonPadding ??
                      const EdgeInsets.only(bottom: 20.0),
                  child: ActionButton(
                    text: retakeButtonText ?? 'Retake photo',
                    onPressed: () => _retakeImage(onRetake),
                    style:
                        retakeButtonStyle ??
                        ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(width: 1, color: Colors.white),
                        ),
                    textStyle:
                        retakeButtonTextStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                    width: retakeButtonWidth,
                    height: retakeButtonHeight,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
