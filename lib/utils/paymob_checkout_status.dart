enum PaymobCheckoutStatus {
  successful('Successfull'),
  rejected('Rejected'),
  pending('Pending'),
  unknown('Unknown');

  final String value;
  const PaymobCheckoutStatus(this.value);

  static PaymobCheckoutStatus fromValue(String value) {
    return PaymobCheckoutStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymobCheckoutStatus.unknown,
    );
  }
}
