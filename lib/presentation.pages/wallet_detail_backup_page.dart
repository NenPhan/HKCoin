import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/config/app_theme.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/core/utils/encryptor.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';
import 'package:hkcoin/widgets/main_button.dart';

class WalletDetailPageParam {
  final BlockchangeWalletInfo wallet;

  WalletDetailPageParam({required this.wallet});
}

class WalletDetailBackupPage extends StatefulWidget {
  const WalletDetailBackupPage({super.key});
  static String route = "/wallet-detail-backup";

  @override
  State<WalletDetailBackupPage> createState() => _WalletDetailBackupPageState();
}

class _WalletDetailBackupPageState extends State<WalletDetailBackupPage> {
  late BlockchangeWalletInfo wallet;
  List<String> mnemonicWords = [];

  @override
  void initState() {
    super.initState();
    if (Get.arguments is WalletDetailPageParam) {
      wallet = (Get.arguments as WalletDetailPageParam).wallet;
      // Decrypt mnemonic if available
      if (wallet.encryptedMnemonic?.isNotEmpty ?? false) {
        final mnemonicString = decryptText(wallet.encryptedMnemonic!, '');
        mnemonicWords = mnemonicString.split(' '); // Split into list
      }
    }
  }

  // Build a list of buttons from mnemonic words with index
  List<Widget> buildMnemonicButtons() {
    return mnemonicWords.asMap().entries.map((entry) {
      final index = entry.key + 1; // Start index from 1
      final word = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1), // Reduced outer padding
        child: TextButton(
          onPressed: () {                        
          },
          style: TextButton.styleFrom(            
            backgroundColor: Colors.blue[50],
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Reduced inner padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Slightly smaller radius
            ),
            minimumSize: const Size(0, 0), // Allow smaller size
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap area            
          ),
          child: Text(
            '$index. $word', // Display index before word
            style: const TextStyle(fontSize: 14), // Reduced font size
            textAlign: TextAlign.left,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildSubmitButton(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(scrSize(context).width * 0.03),
            child: SpacingColumn(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const BaseAppBar(title: "Account.Wallet.Detail.Backup"),
                Text(
                  tr("Account.Wallet.Detail.Backup.Mnemonic.Title"),                  
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Mnemonic buttons
               GridView.count(
                  crossAxisCount: 3, // 3 columns
                  shrinkWrap: true, // Fit content height
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                  mainAxisSpacing: 4, // Compact vertical spacing
                  crossAxisSpacing: 4, // Compact horizontal spacing
                  childAspectRatio: 3, // Wider aspect ratio for compact height
                  children: buildMnemonicButtons(),
                ),
                // Recommendation section
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      tr("Account.Wallet.Detail.Backup.Mnemonic.Recommendation"),                      
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  tr("Account.Wallet.Detail.Backup.Mnemonic.Recommendation.Content"),                  
                  style: const TextStyle(fontSize: 14),
                ),
                // Avoid section
                Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      tr("Account.Wallet.Detail.Backup.Mnemonic.Avoid"),          
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Bullet list
                Html(
                  data: tr("Account.Wallet.Detail.Backup.Mnemonic.Avoid.Content"),
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      color: textTheme(context).bodyLarge?.color,
                      fontFamily: textTheme(context).bodyLarge?.fontFamily,
                      margin: Margins.zero, // Remove default margins
                    ),
                  },
                ),                                         
              ],
            ),
          ),
        ),
      ),
    );
  }  
  Widget _buildSubmitButton(BuildContext context) {
    return MainButton(
      width: double.infinity,
      text: tr("Common.Ok"),
      onTap: () {        
        Get.back(); // Navigate back to previous screen
      },
    );
  }
}