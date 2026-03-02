import 'dart:ui';

class PaymobParams {
  final String publicKey;
  final String clientSecret;
  final String? appName;
  final Color? buttonBackgroundColor;
  final Color? buttonTextColor;
  final bool? saveCardDefault;
  final bool? showSaveCard;

  const PaymobParams({
    required this.publicKey,
    required this.clientSecret,
    this.appName,
    this.buttonBackgroundColor,
    this.buttonTextColor,
    this.saveCardDefault,
    this.showSaveCard,
  });

  Map<String, dynamic> toMap() => {
    "publicKey": publicKey,
    "clientSecret": clientSecret,
    "appName": appName,
    "buttonBackgroundColor": buttonBackgroundColor?.toARGB32(),
    "buttonTextColor": buttonTextColor?.toARGB32(),
    "saveCardDefault": saveCardDefault,
    "showSaveCard": showSaveCard,
  };
}
