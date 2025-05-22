// update_dialog.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hkcoin/data.models/check_update.dart';
import 'package:url_launcher/url_launcher.dart';

void showUpdateDialog(
  BuildContext context, {
  required CheckUpdateResult updateResult,
}) {
  showDialog(
    context: context,
    barrierDismissible: !updateResult.updateAvailable,
    builder: (context) => AlertDialog(
      title: Text(tr('Admin.Common.Update')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (updateResult.name != null) Text(updateResult.name!),
          if (updateResult.releaseNotes != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(updateResult.releaseNotes!),
            ),
        ],
      ),
      actions: [
        if (!updateResult.updateAvailable)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('Common.OK')),
          ),
        if (updateResult.updateAvailable && updateResult.downloadUrl != null)
          TextButton(
            onPressed: () async {
              if (await canLaunch(updateResult.downloadUrl!)) {
                await launch(updateResult.downloadUrl!);
              }
              Navigator.pop(context);
            },
            child: Text(tr('Common.Download')),
          ),
      ],
    ),
  );
}