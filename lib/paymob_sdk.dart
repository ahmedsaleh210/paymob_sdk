import 'dart:developer';

import 'package:flutter/services.dart';

import 'paymob_sdk_platform_interface.dart';
import 'utils/paymob_checkout_status.dart';
import 'utils/paymob_params.dart';

export 'utils/paymob_checkout_status.dart';
export 'utils/paymob_params.dart';

class PaymobSdk {
  Future<PaymobCheckoutStatus?> startPayment(
    PaymobParams params, {
    void Function(PaymobCheckoutStatus status)? onCheckoutStatus,
  }) async {
    try {
      final result = await PaymobSdkPlatform.instance.startPayment(params);
      if (result != null) {
        onCheckoutStatus?.call(result);
      }
      return result;
    } on PlatformException {
      log('Failed to start payment', error: 'PlatformException');
      rethrow;
    }
  }
}
