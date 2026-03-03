import 'dart:developer';

import 'package:flutter/services.dart';

import 'paymob_sdk_platform_interface.dart';
import 'utils/paymob_params.dart';
import 'utils/paymob_checkout_status.dart';

export 'utils/paymob_params.dart';
export 'utils/paymob_checkout_status.dart';

class PaymobSdk {
  Future<PaymobCheckoutStatus?> startPayment(PaymobParams params) async {
    try {
      final result = await PaymobSdkPlatform.instance.startPayment(params);
      return result;
    } on PlatformException {
      log('Failed to start payment', error: 'PlatformException');
      rethrow;
    }
  }
}
