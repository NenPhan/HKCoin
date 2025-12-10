import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/localization/localization_bridge.dart';
import 'package:hkcoin/localization/localization_context_extension.dart';
import 'package:hkcoin/presentation.controllers/locale_controller.dart';

class LanguageSelectorPro extends StatelessWidget {
  const LanguageSelectorPro({
    super.key,
    this.textColor,     // ⭐ Màu chữ truyền từ ngoài
    this.arrowColor,    // ⭐ Màu icon dropdown (nếu null → dùng textColor)
  });

  final Color? textColor;
  final Color? arrowColor;

  static const Color _defaultCopper = Color(0xFFC48A3F);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    if (localeController.listLanguage.isEmpty) return const SizedBox();

    final currentLang = localeController.currentLanguage;
    final bool isSingle = localeController.listLanguage.length == 1;

    // ⭐ Màu chữ & màu icon dropdown
    final Color finalTextColor = textColor ?? _defaultCopper;
    final Color finalArrowColor = arrowColor ?? finalTextColor;

    return GestureDetector(
      onTap: isSingle ? null : () => _openSheet(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _flagImage(currentLang.flagImageFileName, size: 22),
          const SizedBox(width: 8),

          Text(
            currentLang.name ?? "",
            style: TextStyle(
              color: finalTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          if (!isSingle)
            Icon(Icons.keyboard_arrow_down, color: finalArrowColor),
        ],
      ),
    );
  }

  Widget _flagImage(String? url, {double size = 26}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.network(
        url ?? "",
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.flag, color: Colors.grey[400], size: size),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    if (localeController.listLanguage.length < 2) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _LanguageProSheet(
              textColor: textColor,   // ⭐ truyền xuống sheet
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 320),
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutExpo);

        return Transform.translate(
          offset: Offset(0, 200 * (1 - curved.value)),
          child: Opacity(opacity: curved.value, child: child),
        );
      },
    );
  }
}

class _LanguageProSheet extends StatelessWidget {
  final LocaleController localeController = Get.find<LocaleController>();

  final Color? textColor;
  static const Color _defaultCopper = Color(0xFFC48A3F);

  _LanguageProSheet({super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    final currentIso = localeController.localeIsoCode;

    final Color finalTextColor = textColor ?? _defaultCopper;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.88),
                Colors.black.withOpacity(0.65),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            border: Border.all(color: Colors.white12, width: 0.5),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  context.tr("Admin.Configuration.Languages.Select"),
                  style: TextStyle(
                    color: finalTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ...localeController.listLanguage.map((lang) {
                final iso = localeController.normalizeIso(lang.isoCode!);
                final locale = iso.toLocaleFromIsoCode();
                final bool isSelected = iso == currentIso;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? finalTextColor.withOpacity(0.20)
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? finalTextColor : Colors.transparent,
                      width: 1.2,
                    ),
                  ),

                  child: ListTile(
                    leading: _flagImage(lang.flagImageFileName, size: 30),
                    title: Text(
                      lang.name ?? "",
                      style: TextStyle(
                        color: isSelected ? finalTextColor : Colors.white,
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      lang.isDefault == true ? "Default" : iso,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 13,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle,
                            color: finalTextColor, size: 26)
                        : const Icon(Icons.circle_outlined,
                            color: Colors.white38),
                    onTap: () async {
                      Navigator.pop(context);
                      await LocalizationBridge.instance
                          .changeLocale(context, locale);
                    },
                  ),
                );
              }),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flagImage(String? url, {double size = 28}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url ?? "",
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.flag_outlined, color: Colors.grey[600], size: size),
      ),
    );
  }
}
