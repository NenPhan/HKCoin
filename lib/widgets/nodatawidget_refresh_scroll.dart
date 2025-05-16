import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final IconData? icon;
  final String message;
  final Future<void> Function()? onRefresh;
  final String buttonText;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;
  final bool enableRefreshIndicator;

  const NoDataWidget({
    super.key,
    this.icon = Icons.info_outline,
    this.message = 'No data found',
    this.onRefresh,
    this.buttonText = 'Retry',
    this.iconSize = 60.0,
    this.iconColor,
    this.textStyle,
    this.enableRefreshIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: textStyle ??
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
              ),
              if (onRefresh != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onRefresh,
                  child: Text(buttonText),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return enableRefreshIndicator && onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: content,
          )
        : content;
  }
}