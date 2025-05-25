class WalletModel {
  final int withdrawable;
  final int nonWithdrawable;
  final int total;

  WalletModel({
    required this.withdrawable,
    required this.nonWithdrawable,
    required this.total,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    withdrawable: json['withdrawable'] ?? 0,
    nonWithdrawable: json['nonWithdrawable'] ?? 0,
    total: json['total'] ?? 0,
  );
}
