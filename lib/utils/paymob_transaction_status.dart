enum PaymobTransactionStatus {
  successful('Successfull'),
  rejected('Rejected'),
  pending('Pending'),
  unknown('Unknown');

  final String value;
  const PaymobTransactionStatus(this.value);

  static PaymobTransactionStatus fromValue(String value) {
    return PaymobTransactionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymobTransactionStatus.unknown,
    );
  }
}
