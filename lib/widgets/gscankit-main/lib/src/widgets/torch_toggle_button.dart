import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TorchToggleButton extends StatelessWidget {
  final bool isTorchOn;
  final VoidCallback onPressed;
  final IconData flashOnIcon;

  /// Custom icon for the flashlight when off
  final IconData flashOffIcon;
  const TorchToggleButton({
    super.key,
    required this.isTorchOn,
    required this.onPressed,
    this.flashOnIcon = CupertinoIcons.bolt_fill,
    this.flashOffIcon = CupertinoIcons.bolt,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: isTorchOn ? Colors.black : Colors.white,
        foregroundColor: isTorchOn ? Colors.white : Colors.black,
      ),
      icon: Icon(isTorchOn ? flashOnIcon : flashOffIcon),
      onPressed: onPressed,
    );
  }
}
