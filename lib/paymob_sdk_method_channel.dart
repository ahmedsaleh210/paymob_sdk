import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:paymob_sdk/utils/paymob_params.dart';
import 'package:paymob_sdk/utils/paymob_transaction_status.dart';

import 'paymob_sdk_platform_interface.dart';

/// An implementation of [PaymobSdkPlatform] that uses method channels.
class MethodChannelPaymobSdk extends PaymobSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('paymob/payment_channel');

  @override
  Future<PaymobTransactionStatus?> startPayment(PaymobParams params) async {
    final result = await methodChannel.invokeMethod<String>(
      'payWithPaymob',
      params.toMap(),
    );
    return PaymobTransactionStatus.fromValue(result ?? 'Unknown');
  }
}
