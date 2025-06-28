import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/enums.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/blockchange_wallet_info.dart';
import 'package:hkcoin/data.models/network.dart';
import 'package:hkcoin/data.models/wallet.dart';
import 'package:hkcoin/data.repositories/wallet_repository.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class BlockchangeWalletController extends GetxController {
  final listNetwork = <Network>[].obs;
  final wallets = <BlockchangeWallet>[].obs;
  final walletInfos = <WalletsModel>[].obs;
  var selectedNetwork = Rxn<Network>();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingWallets = false.obs;
  BlockchangeWalletInfo? walletsInfo;
  final TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    getNetworks();
    getWalletInfo();
    super.onInit();
  }

  Future getNetworks() async {
    await handleEitherReturn(await WalletRepository().getNetworks(), (r) async {
      final uniqueNetworks = {for (var e in r) e.id: e}.values.toList();
      listNetwork.value = uniqueNetworks;
      try {
        final networkStore = await Storage().getNetWork();
        if (networkStore == null || listNetwork.isEmpty) {
          var network = listNetwork.firstWhere(
            (e) => e.networkDefault ?? false,
            orElse: () => listNetwork.first,
          );
          await Storage().saveNetWork(network);
          selectedNetwork.value = network;
          listNetwork.value.sort((a, b) {
            if (a.id == network.id) return -1;
            if (b.id == network.id) return 1;
            return 0;
          });
        } else {
          selectedNetwork.value = networkStore;
          listNetwork.value.sort((a, b) {
            if (a.id == networkStore.id) return -1;
            if (b.id == networkStore.id) return 1;
            return 0;
          });
        }
      } catch (e) {
        rethrow;
      }
    });
    update(["wallet-info-page"]);
  }

  Future filterNetworks(String query) async {
    if (query.isEmpty) {
      listNetwork.assignAll(listNetwork); // Nếu không có query, hiển thị tất cả
    } else {
      listNetwork.assignAll(
        listNetwork
            .where(
              (network) =>
                  network.name!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      ); // Lọc mạng theo tên
    }
  }

  Future<void> selectNetwork(Network network) async {
    selectedNetwork.value = network; // Cập nhật mạng được chọn
    await Storage().saveNetWork(network); // Lưu mạng đã chọn
    update(["blockchange-networks"]);
    await getWalletInfo();
    update(["blockchange-networks"]);
  }

  Future<void> selectWallet(BlockchangeWallet wallet) async {
    try {
      await handleEitherReturn(
        await WalletRepository().selectedWallet(
          BlockchangeWallet(id: wallet.id),
        ),
        (r) async {
          //Get.toNamed(WalletPage.route);
          //Get.back();
        },
      );
    } catch (e) {}
    update(["blockchange-networks"]);
    getWalletInfo();
    update(["wallet-info-page"]);
  }

  Future getWallets() async {
    isLoadingWallets.value = true;
    update(["blockchange-wallets"]);
    await handleEither(await WalletRepository().getWallets(), (r) async {
      //wallets.value = r;
      await fetchWalletsBalance(r);
    });

    isLoadingWallets.value = false;
    update(["blockchange-wallets"]);
  }

  Future getWalletInfo() async {
    isLoading.value = true;
    update(["wallet-info-page"]);
    await handleEither(await WalletRepository().getWalletInfo(), (r) {
      if (r != null) {
        walletsInfo = r;
        fetchWalletBalance(walletsInfo!);
      }
    });

    isLoading.value = false;
    update(["wallet-info-page"]);
  }

  Future fetchWalletBalance(BlockchangeWalletInfo wallets) async {
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }
    walletInfos.clear();
    wallets.walletAddressFormat = _formatAddress(wallets.walletAddress);
    final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
    double totalBalance = 0.0;
    double totalBalanceUSD = 0.0;
    for (var wallet in walletsInfo!.walletAddressModel!) {
      //final credentials = EthPrivateKey.fromHex(decryptText(wallet.privateKey!,""));
      //final address = await credentials.extractAddress();
      // Lấy số dư từ BNB (Binance Smart Chain)
      try {
        if (wallet.chain == Chain.BNB) {
          var bnb = await web3Client.getBalance(
            EthereumAddress.fromHex(wallet.walletAddress),
          );
          wallet.totalBalance = fromWeiToBNB(bnb.getInWei.toDouble());
          wallet.totalBalanceUSD = wallet.totalBalance! * await fetchBnbPrice();
          walletInfos.add(wallet);
          totalBalance += wallet.totalBalanceUSD!;
        } else if (wallet.chain != Chain.BNB) {
          final result = await getTokenBalance(
            wallet.walletAddress,
            wallet.contractAddress,
            web3Client,
          );
          wallet.totalBalance = result['balance'].toDouble();
          walletInfos.add(wallet);
          if (wallet.chain == Chain.USDT) {
            totalBalance += wallet.totalBalance!;
          }
        }
      } catch (e) {
        debugPrint('Lỗi khi lấy số dư BNB blc_controller: $e');        
      }
    }
    wallets.totalBalance = totalBalance;
    update(["wallet-info-page"]);
    wallets.balanceUSD = totalBalanceUSD;
    //wallet.unit = unit;
    web3Client.dispose();
  }

  Future fetchWalletsBalance(List<BlockchangeWallet> ws) async {
    final networkStore = await Storage().getNetWork() ?? selectedNetwork.value;
    if (networkStore == null) {
      Get.snackbar('Error', 'No network selected');
      return;
    }

    final web3Client = Web3Client(networkStore.rpcUrl!, http.Client());
    wallets.clear();
    for (var w in ws) {
      double walletTotalBalance = 0.0; // Tạo biến riêng cho từng ví
      for (var info in w.walletAddress!) {
        if (info.chain == Chain.BNB) {
          var bnb = await web3Client.getBalance(
            EthereumAddress.fromHex(info.address),
          );
          walletTotalBalance +=
              fromWeiToBNB(bnb.getInWei.toDouble()) *
              665; // Giả sử 665 là tỷ giá BNB/USD
        } else {
          if (info.chain == Chain.USDT) {
            final result = await getTokenBalance(
              info.address,
              info.contractAddress,
              web3Client,
            );
            walletTotalBalance += result['balance'].toDouble();
          }
        }
      }
      w.balance = walletTotalBalance;
      wallets.add(w);
    }
    wallets.refresh(); // Cập nhật UI nếu dùng GetX
    update(["blockchange-wallets"]);
    web3Client.dispose();
  }

  Future<double> fetchBnbPrice() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['binancecoin']['usd'].toDouble();
      } else {
        print('Lỗi lấy tỷ giá BNB: ${response.statusCode}');
        return 600.0; // Giá trị mặc định
      }
    } catch (e) {
      print('Lỗi lấy tỷ giá BNB: $e');
      return 600.0; // Giá trị mặc định
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  String _formatAddress(String? address) {
    if (address == null || address.length < 12) {
      return 'N/A';
    }
    return '${address.substring(0, 7)}...${address.substring(address.length - 5)}';
  }

  Future<Map<String, dynamic>> getTokenBalance(
    String walletAddress,
    String tokenAddress,
    Web3Client web3client,
  ) async {
    // ABI của token (chỉ cần các hàm balanceOf và decimals)
    const tokenAbi = '''[
      {
        "constant": true,
        "inputs": [{"name": "owner", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"name": "balance", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [{"name": "", "type": "uint8"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      }
    ]''';

    // Tạo contract instance
    final contract = DeployedContract(
      ContractAbi.fromJson(tokenAbi, 'BEP20Token'),
      EthereumAddress.fromHex(tokenAddress),
    );
    try {
      // Lấy số decimals
      final decimals = await web3client.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      final decimalsValue = decimals[0] as BigInt;

      // Lấy balance
      final balance = await web3client.call(
        contract: contract,
        function: contract.function('balanceOf'),
        params: [EthereumAddress.fromHex(walletAddress)],
      );
      final rawBalance = balance[0] as BigInt;

      // Tính toán số dư thực tế
      final balanceValue =
          rawBalance / BigInt.from(10).pow(decimalsValue.toInt());

      return {
        'balance': balanceValue.toDouble(),
        'decimals': decimalsValue.toInt(),
        'rawBalance': rawBalance.toString(),
      };
    } catch (e) {
      throw Exception('Failed to get token balance: $e');
    }
  }

  double fromWeiToBNB(double weiAmount, {int decimals = 18}) {
    return weiAmount / (BigInt.from(10).pow(decimals)).toDouble();
  }

  BigInt toWei(String value, {int decimals = 18}) {
    if (!value.contains('.')) {
      return BigInt.parse(value + '0' * decimals);
    }

    final parts = value.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Cắt hoặc đệm cho phần thập phân đủ độ dài
    String fullDecimal = (decimalPart + '0' * decimals).substring(0, decimals);

    return BigInt.parse(integerPart + fullDecimal);
  }

  String formatNumber(double number) {
    final formatter = NumberFormat(
      "#,##0.00",
      "en_US",
    ); // Locale Đức (dùng dấu . cho nghìn)
    return formatter.format(number);
  }
}
