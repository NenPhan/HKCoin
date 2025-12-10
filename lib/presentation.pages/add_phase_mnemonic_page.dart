import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/create_wallet_controller.dart';
import 'package:hkcoin/presentation.pages/qr_scan_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';

class AddMnemonicPage extends StatelessWidget {
  const AddMnemonicPage({super.key});
  static String route = "/add-mnemonic";

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateWalletController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BaseAppBar(title: "Account.wallet.Enter"),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: _buildFormContent(controller, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(
    CreateWalletController controller,
    BuildContext context,
  ) {
    return Form(
      key: controller.formKey,
      child: SpacingColumn(
        spacing: 15,
        children: [
          const SizedBox(height: 20),
          _buildMnemonicTextField(controller),
          _buildActionButtons(controller, context),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.detectedInputType.value ==
                CreateWalletType.Mnemonic) {
              return Text(
                context.tr("Account.wallet.Detected.Mnemonic"),
                style: const TextStyle(color: Colors.green),
              );
            } else if (controller.detectedInputType.value ==
                CreateWalletType.PrivateKey) {
              return Text(
                context.tr("Account.wallet.Detected.PrivateKey"),
                style: const TextStyle(color: Colors.green),
              );
            } else if (controller.mnemonicController.text.isNotEmpty) {
              return Text(
                context.tr("Account.wallet.Detected.NotDetermined"),
                style: const TextStyle(color: Colors.orange),
              );
            }
            return const SizedBox.shrink();
          }),
          _buildSubmitButton(controller),
        ],
      ),
    );
  }

  Widget _buildMnemonicTextField(CreateWalletController controller) {
    return MainTextField(
      controller: controller.mnemonicController,
      label: 'Mnemonic',
      hintText: "Account.wallet.Enter.PlaceHoled",
      maxLines: 8,
      minLines: 6,
      validator:
          (value) =>
              value?.trim().isEmpty ?? true
                  ? Get.context?.tr("Account.wallet.Enter.Mnemonic.Required")
                  : null,
    );
  }

  Widget _buildActionButtons(
    CreateWalletController controller,
    BuildContext context,
  ) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller.mnemonicController,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;

        return FutureBuilder<ClipboardData?>(
          future: Clipboard.getData(Clipboard.kTextPlain),
          builder: (context, snapshot) {
            final clipboardText = snapshot.data?.text ?? '';
            final hasClipboard = clipboardText.trim().isNotEmpty;

            return Row(
              children: [
                _buildPasteButton(controller, hasClipboard, clipboardText),
                const SizedBox(width: 10),
                _buildQRScanButton(controller, context),
                const SizedBox(width: 10),
                _buildClearButton(controller, hasText),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPasteButton(
    CreateWalletController controller,
    bool hasClipboard,
    String clipboardText,
  ) {
    return IconButton(
      onPressed:
          hasClipboard
              ? () => controller.mnemonicController.text = clipboardText
              : null,
      icon: const Icon(Icons.paste, color: Colors.white, size: 18),
      tooltip: Get.context?.tr('Common.Paste'),
      style: IconButton.styleFrom(
        backgroundColor: hasClipboard ? Colors.white24 : Colors.white12,
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildQRScanButton(
    CreateWalletController controller,
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () => _navigateToQRScanPage(controller, context),
      icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 18),
      tooltip: 'Quét QR',
      style: IconButton.styleFrom(
        backgroundColor: Colors.white24,
        shape: const CircleBorder(),
      ),
    );
  }

  void _navigateToQRScanPage(
    CreateWalletController controller,
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => QRScanPage(
              showDialogOnScan: false,
              onScanResult: (result) {
                controller.mnemonicController.text = result;
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }

  Widget _buildClearButton(CreateWalletController controller, bool hasText) {
    return TextButton.icon(
      onPressed: hasText ? () => controller.mnemonicController.clear() : null,
      icon: const Icon(Icons.clear, color: Colors.white, size: 18),
      label: Text(
        Get.context?.tr("Common.Delete") ?? "",
        style: const TextStyle(color: Colors.white),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildSubmitButton(CreateWalletController controller) {
    return Obx(
      () => MainButton(
        isLoading: controller.isLoadingSubmit.value,
        width: double.infinity,
        text: "Common.Save",
        onTap: () async {
          //if (controller.validate()) {
          // Đảm bảo loading hiển thị ngay lập tức
          controller.isLoadingSubmit.value = true;
          await Future.delayed(Duration.zero);

          controller.submitAddToken(CreateWalletType.Mnemonic);
          //}
        },
      ),
    );
  }
}
