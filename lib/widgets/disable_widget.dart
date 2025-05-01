import 'package:flutter/cupertino.dart';

class DisableWidget extends StatelessWidget {
  const DisableWidget({super.key, this.disable = true, required this.child});
  final bool disable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disable,
      child: Opacity(opacity: 0.7, child: child),
    );
  }
}
