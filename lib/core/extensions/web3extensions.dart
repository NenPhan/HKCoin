import 'dart:math';
import 'package:web3dart/web3dart.dart';

BigInt preciseAmountToWei(double amount, int decimals) {
  // Chuyển đổi an toàn bằng cách sử dụng chuỗi từ đầu
  final String amountStr = amount.toString();

  // Tách phần nguyên và phần thập phân
  final parts = amountStr.split('.');

  if (parts.length == 1) {
    // Không có phần thập phân
    return BigInt.parse(parts[0]) * BigInt.from(10).pow(decimals);
  }

  // Xử lý phần thập phân
  String integerPart = parts[0];
  String fractionalPart = parts[1];

  // Nếu số chữ số thập phân nhiều hơn decimals, cắt bớt
  if (fractionalPart.length > decimals) {
    fractionalPart = fractionalPart.substring(0, decimals);
  }
  // Nếu ít hơn, thêm số 0
  else {
    fractionalPart = fractionalPart.padRight(decimals, '0');
  }

  // Ghép phần nguyên và phần thập phân đã xử lý
  return BigInt.parse(integerPart + fractionalPart);
}

extension DoublePrecisionExtensions on double {
  BigInt toWei({int decimals = 18, bool isBNB = false}) {
    if (isBNB) {
      return EtherAmount.fromUnitAndValue(EtherUnit.ether, this).getInWei;
    }
    // Sử dụng giải pháp chính xác tuyệt đối qua chuỗi
    return preciseAmountToWei(this, decimals);
  }
}

extension StringWeiConversion on String {
  /// Converts string numeric value to wei with specified decimals
  /// [decimals] - Number of decimal places (default 18)
  /// [isBNB] - Whether to use EtherAmount conversion for BNB
  BigInt toWei({int decimals = 18, bool isBNB = false}) {
    if (isBNB) {
      return EtherAmount.fromUnitAndValue(
        EtherUnit.ether,
        double.parse(this),
      ).getInWei;
    }
    return _preciseToWei(this, decimals);
  }

  BigInt _preciseToWei(String amountStr, int decimals) {
    final parts = amountStr.split('.');
    if (parts.length == 1) {
      return BigInt.parse(parts[0]) * BigInt.from(10).pow(decimals);
    }

    final integerPart = parts[0];
    var fractionalPart = parts[1];

    if (fractionalPart.length > decimals) {
      fractionalPart = fractionalPart.substring(0, decimals);
    } else {
      fractionalPart = fractionalPart.padRight(decimals, '0');
    }

    return BigInt.parse(integerPart + fractionalPart);
  }
}

extension DynamicWeiConversion on dynamic {
  /// Converts numeric value to wei with specified decimals
  /// Handles String, num (int/double), and BigInt inputs
  /// [decimals] - Number of decimal places (default 18)
  /// [isBNB] - Whether to use EtherAmount conversion for BNB
  BigInt toWei({int decimals = 18, bool isBNB = false}) {
    if (isBNB) {
      return EtherAmount.fromUnitAndValue(
        EtherUnit.ether,
        _toDouble(this),
      ).getInWei;
    }

    return _convertToWei(this, decimals);
  }

  /// Internal conversion to double
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    if (value is BigInt) return value.toDouble();
    throw ArgumentError('Invalid numeric type');
  }

  /// Internal precise wei conversion
  static BigInt _convertToWei(dynamic value, int decimals) {
    if (value is BigInt) {
      return value * BigInt.from(10).pow(decimals);
    }

    final str = value is String ? value : value.toString();
    final parts = str.split('.');

    if (parts.length == 1) {
      return BigInt.parse(parts[0]) * BigInt.from(10).pow(decimals);
    }

    final integerPart = parts[0];
    var fractionalPart = parts[1];

    fractionalPart =
        fractionalPart.length > decimals
            ? fractionalPart.substring(0, decimals)
            : fractionalPart.padRight(decimals, '0');

    return BigInt.parse(integerPart + fractionalPart);
  }
}

//  double fromWeiToBNB(double weiAmount, {int decimals = 18}) {
//     return weiAmount / (BigInt.from(10).pow(decimals)).toDouble();
//   }
extension WeiConversionExtensions on double {
  /// Converts wei amount back to BNB/token value
  /// [weiAmount] - The amount in wei/smallest unit
  /// [decimals] - Number of decimal places (default 18 for BNB/BEP20)
  static double weitobnb(double weiAmount, {int decimals = 18}) {
    // Handle very large wei amounts precisely
    if (weiAmount > 1e18) {
      final divisor = BigInt.from(10).pow(decimals);
      return weiAmount.toDouble() / divisor.toDouble();
    }

    // More precise calculation for smaller amounts
    return weiAmount / pow(10, decimals);
  }

  /// Converts wei amount back to BNB (alias for fromWei)
  static double fromWeiToBNB(double weiAmount, {int decimals = 18}) {
    return weitobnb(weiAmount, decimals: decimals);
  }
}

extension WeiDoubleConversion on double {
  /// Converts wei amount (as double) to BNB/token value
  /// Usage: bnb.getInWei.toDouble().fromWeiToBNB()
  /// or: bnb.getInWei.toDouble().fromWeiToBNB(decimals: 8)
  double fromWeiToBNB({int decimals = 18}) {
    // For maximum precision with very large numbers
    if (abs() > 1e15) {
      final bigWei = BigInt.from(round());
      final bigDivisor = BigInt.from(10).pow(decimals);
      final bigResult = bigWei / bigDivisor;
      return bigResult.toDouble() +
          (bigWei % bigDivisor).toDouble() / bigDivisor.toDouble();
    }

    // Standard calculation for normal ranges
    return this / pow(10, decimals);
  }
}

extension WeiBigIntConversion on BigInt {
  /// Converts wei amount (as BigInt) to BNB/token value
  /// Usage: bnb.getInWei.fromWeiToBNB()
  /// or: bnb.getInWei.fromWeiToBNB(decimals: 8)
  double fromWeiToBNB({int decimals = 18}) {
    final divisor = BigInt.from(10).pow(decimals);
    final whole = (this ~/ divisor).toDouble();
    final fractional = (this % divisor).toDouble() / divisor.toDouble();
    return whole + fractional;
  }
}
