class BlockChainTransaction {
  final String hash;
  final String from;
  final String to;
  final BigInt value;
  final DateTime timestamp;
  final String? status;
  final BigInt? gasUsed;
  final BigInt? gasPrice;

  BlockChainTransaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.timestamp,
    this.status,
    this.gasUsed,
    this.gasPrice,
  });

  factory BlockChainTransaction.fromJson(Map<String, dynamic> json) {
    return BlockChainTransaction(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      value: BigInt.tryParse(json['value']?.toString() ?? '0') ?? BigInt.zero,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['timeStamp']?.toString() ?? '0')!.toInt() * 1000 ?? 0,
      ),
      status: json['txreceipt_status'] == '1' ? 'Success' : 'Failed',
      gasUsed: BigInt.tryParse(json['gasUsed']?.toString() ?? '0'),
      gasPrice: BigInt.tryParse(json['gasPrice']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'from': from,
      'to': to,
      'value': value.toString(),
      'timestamp': timestamp.millisecondsSinceEpoch,
      'status': status,
      'gasUsed': gasUsed?.toString(),
      'gasPrice': gasPrice?.toString(),
    };
  }
}