import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/widgets/spacing.dart';
import 'package:hkcoin/presentation.controllers/WithDrawalRequestController.dart';
import 'package:hkcoin/presentation.pages/withdrawal_investment_page.dart';
import 'package:hkcoin/presentation.pages/withdrawal_profit_page.dart';
import 'package:hkcoin/presentation.pages/withdrawalrequest_histories_page.dart';
import 'package:hkcoin/widgets/base_app_bar.dart';

class CustomerDownlinesPage extends StatefulWidget {
  const CustomerDownlinesPage({super.key});
  static String route = "/customer-downlines";
  @override
  State<CustomerDownlinesPage> createState() => _CustomerDownlinesPageState();
}

class _CustomerDownlinesPageState extends State<CustomerDownlinesPage>
    with SingleTickerProviderStateMixin {
  final WithDrawalRequestController controller = Get.put(
    WithDrawalRequestController(),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return GetBuilder<WithDrawalRequestController>(
      id: "customer-downlines-page",
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BaseAppBar(title: "Account.Downlines.Customers"),
                // Wallet info section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ), 
                      _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ), 
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ), 
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),   
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),  
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),  
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),  
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),  
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),   
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),     
                          _buildAssetItemCircle(
                            title: "Nguyễn Văn Kiên",
                            amount: "1,000,000 VND",
                            icon: Icons.money,
                            onSubmitted: () {
                              // setState(() {
                              //   _isSelected = !_isSelected; // Toggle selection
                              // });
                              // Add your submit logic here
                              log("Submit");
                            },
                          ),                       
                    ],
                  ),
                ),             
              ],
            ),
          ),
        );
      },
    );
  }
   Widget _buildAssetItem({
    required String title,
    required String amount,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        //subtitle: Text(amount),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
  Widget _buildAssetItemCircle({
  required String title,
  required String amount,
  required IconData icon,
  VoidCallback? onSubmitted,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade700,
            ],
            center: Alignment.center,
            radius: 0.8,
          ),
        ),
        child: Icon(icon, size: 22, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      //subtitle: Text(amount),
      trailing: const Icon(Icons.chevron_right),
      onTap: onSubmitted,
    ),
    
  );
}
}
