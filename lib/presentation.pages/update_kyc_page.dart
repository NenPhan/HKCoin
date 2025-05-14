import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/update_kyc_controller.dart';
import 'package:hkcoin/presentation.pages/kyc_camera_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/custom_drop_down_button.dart';
import 'package:hkcoin/widgets/disable_widget.dart';
import 'package:hkcoin/widgets/loading_widget.dart';
import 'package:hkcoin/widgets/main_button.dart';
import 'package:hkcoin/widgets/main_text_field.dart';
import 'package:image_picker/image_picker.dart';

class UpdateKycPage extends StatefulWidget {
  const UpdateKycPage({super.key});
  static String route = "/update-kyc";

  @override
  State<UpdateKycPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<UpdateKycPage> {
  final UpdateKycController controller = Get.put(UpdateKycController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateKycController>(
      id: "update-kyc-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Account.KYC.Title"),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (controller.isLoading) {
                        return const LoadingWidget();
                      } else {
                        // switch ("PortraitUpload") {
                        switch (controller.kycStatus?.nextStep) {
                          case "Infomation" || "Complete":
                            return _buildUpdateInfo();
                          case "FrontUpload":
                            return _buildUpdatePhoto(0);
                          case "BackUpload":
                            return _buildUpdatePhoto(1);
                          case "PortraitUpload":
                            return _buildUpdatePhoto(2);
                          default:
                            return const SizedBox();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildUpdateInfo() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: scrSize(context).width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildAlert(
              controller.verifyKyc
                  ? "Account.KYC.Veryfied"
                  : controller.kycStatus?.message ?? "",
            ),
            Form(
              key: controller.formKey,
              child: SpacingColumn(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    tr("Account.YourPersonalDetails"),
                    style: textTheme(context).bodyMedium,
                  ),
                  MainTextField(
                    controller: controller.fNameController,
                    label: tr("Account.KYC.Fields.FirstName"),
                    onChanged: (p0) => controller.validate(),
                  ),
                  MainTextField(
                    controller: controller.lNameController,
                    label: tr("Account.KYC.Fields.LastName"),
                    onChanged: (p0) => controller.validate(),
                  ),
                  MainTextField(
                    controller: controller.phoneController,
                    label: tr("Account.KYC.Fields.Phone"),
                    onChanged: (p0) => controller.validate(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr("Account.IdentificationCard").toUpperCase(),
                    style: textTheme(context).bodyMedium,
                  ),
                  CustomDropDownButton(
                    items: controller.listCountry,
                    isRequired: true,
                    selectedValue: controller.selectedCountry,
                    title: "Account.KYC.Fields.Country",
                    onChanged: (p0) {
                      controller.selectedCountry = p0;
                      controller.validate();
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: MainTextField(
                          controller: controller.cidController,
                          label: tr(
                            "Account.KYC.Fields.IdentificationCardNumber",
                          ),
                          onChanged: (p0) => controller.validate(),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomDropDownButton(
                          items: controller.iCardTypes,
                          isRequired: true,
                          selectedValue: controller.selectedICardType,
                          onChanged: (p0) {
                            controller.selectedICardType = p0;
                            controller.validate();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Visibility(
                visible: !controller.verifyKyc,
                child: MainButton(
                  isLoading: controller.isLoadingSaveButton.value,
                  enable: controller.canSave.value,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: textTheme(context).titleLarge?.fontSize,
                  ),
                  text: "Common.Save",
                  onTap: () async {
                    controller.updateKycInfo();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildUpdatePhoto(int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: scrSize(context).width * 0.03,
        ),
        child: SpacingColumn(
          spacing: 20,
          children: [
            const SizedBox(),
            _buildAlert(controller.kycStatus?.message ?? ""),
            UploadPhotoButton(
              name: "ACCOUNT.KYC.CARD.BEFORE.TITLE",
              enable: index == 0,
              isUploaded: index > 0,
              onChanged: (file) async {
                await controller.kycValidatePhoto(name: "FrontId", file: file);
              },
            ),
            UploadPhotoButton(
              name: "ACCOUNT.KYC.CARD.BACKSIDE.TITLE",
              enable: index == 1,
              isUploaded: index > 1,
              onChanged: (file) async {
                await controller.kycValidatePhoto(name: "BackId", file: file);
              },
            ),
            UploadPhotoButton(
              name: "Account.KYC.Card.Fields.MediaFilePortrait",
              enable: index == 2,
              onChanged: (file) async {
                await controller.kycValidatePhoto(name: "Portrait", file: file);
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildAlert(String alert) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: scrSize(context).width * 0.15,
              color: Colors.indigo[700],
              child: const Center(
                child: Icon(Icons.priority_high_rounded, color: Colors.white),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(scrSize(context).width * 0.03),
                color: Colors.white,
                child: Text(
                  tr(alert),
                  style: textTheme(
                    context,
                  ).bodyMedium?.copyWith(color: Colors.indigo[900]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadPhotoButton extends StatefulWidget {
  const UploadPhotoButton({
    super.key,
    required this.name,
    this.isUploaded = false,
    this.enable = true,
    required this.onChanged,
  });
  final String name;
  final bool isUploaded;
  final bool enable;
  final Future Function(File) onChanged;

  @override
  State<UploadPhotoButton> createState() => _UploadPhotoButtonState();
}

class _UploadPhotoButtonState extends State<UploadPhotoButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scrSize(context).width,
      child: DisableWidget(
        disable: !widget.enable,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: widget.enable ? 20 : 40,
            horizontal: scrSize(context).width * 0.03,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: 2, color: Colors.grey[800]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SpacingColumn(
            spacing: 20,
            children: [
              SpacingRow(
                spacing: 10,
                children: [
                  Expanded(
                    child: Text(
                      tr(widget.name),
                      overflow: TextOverflow.ellipsis,
                      style: textTheme(context).titleSmall,
                    ),
                  ),
                  if (isLoading) const LoadingWidget(),
                  if (widget.isUploaded && !isLoading)
                    const Icon(
                      Icons.check_circle,
                      size: 25,
                      color: Colors.green,
                    ),
                ],
              ),
              if (widget.enable && !isLoading)
                SpacingColumn(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MainButton(
                      icon: const Icon(
                        Icons.photo_camera,
                        size: 25,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        var result = await Get.toNamed(
                          KycCameraPage.route,
                          arguments:
                              widget.name.toLowerCase().contains("portrait")
                                  ? PhotoRatio.portrait
                                  : PhotoRatio.cid,
                        );
                        if (result is String) {
                          await widget.onChanged(File(result));
                        }
                        isLoading = false;
                        if (mounted) setState(() {});
                      },
                      text: 'Camera',
                    ),
                    MainButton(
                      icon: const Icon(
                        Icons.photo,
                        size: 25,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        var file = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null) {
                          widget.onChanged(File(file.path));
                        }
                        isLoading = false;
                        setState(() {});
                      },
                      text: 'Pick a file',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
