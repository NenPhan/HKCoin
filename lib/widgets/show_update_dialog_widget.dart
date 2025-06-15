// update_dialog.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/data.models/check_update.dart';
import 'package:url_launcher/url_launcher.dart';

void showUpdateDialog(
  BuildContext context, {
  required CheckUpdateResult updateResult,
}) {
  showDialog(
    context: context,
    barrierDismissible:
        !updateResult.isForceUpdate!, // Chặn đóng khi là cập nhật bắt buộc
    builder:
        (context) => WillPopScope(
          onWillPop:
              () async =>
                  !updateResult
                      .isForceUpdate!, // Chặn nút back khi là cập nhật bắt buộc
          child: AlertDialog(
            title: Text(context.tr('Common.Update.Available')),
            content: SingleChildScrollView(
              // Thêm scroll cho nội dung dài
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (updateResult.name != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        updateResult.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (updateResult.releaseNotes != null)
                    Html(
                      data: updateResult.releaseNotes!,
                      style: {
                        '*': Style(
                          fontSize: FontSize(
                            textTheme(context).bodyMedium!.fontSize!,
                          ),
                          color: textTheme(context).bodyMedium!.color,
                        ),
                        'img': Style(margin: Margins.symmetric(vertical: 0)),
                      },
                      extensions: [
                        TagExtension(
                          tagsToExtend: {"img"},
                          builder: (context) {
                            final src = context.attributes['src'];
                            if (src == null || src.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth,
                                    ),
                                    child: Image.network(
                                      src,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text(
                                                'Cant not loading image!',
                                              ),
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Text(
                    '${context.tr('Common.CurrentVersion')}: ${updateResult.currentVersion ?? context.tr('Common.Unknown')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${context.tr('Common.NewVersion')}: ${updateResult.version ?? context.tr('Common.Unknown')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            actions: [
              // Luôn hiển thị nút Close trừ khi là cập nhật bắt buộc
              if (!updateResult.isForceUpdate!)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.tr('Common.Close')),
                ),

              // Nút Download khi có bản cập nhật
              if (updateResult.updateAvailable &&
                  updateResult.downloadUrl != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    if (await canLaunchUrl(
                      Uri.parse(updateResult.downloadUrl!),
                    )) {
                      await launchUrl(Uri.parse(updateResult.downloadUrl!));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('Common.CannotOpenLink')),
                        ),
                      );
                    }
                    if (!updateResult.isForceUpdate!) Navigator.pop(context);
                  },
                  child: Text(
                    context.tr('Common.Download'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
  );
}
