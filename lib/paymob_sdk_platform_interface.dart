import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'paymob_sdk_method_channel.dart';
import 'utils/paymob_params.dart';
import 'utils/paymob_checkout_status.dart';

abstract class PaymobSdkPlatform extends PlatformInterface {
  /// Constructs a PaymobSdkPlatform.
  PaymobSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static PaymobSdkPlatform _instance = MethodChannelPaymobSdk();

  /// The default instance of [PaymobSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelPaymobSdk].
  static PaymobSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PaymobSdkPlatform] when
  /// they register themselves.
  static set instance(PaymobSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<PaymobCheckoutStatus?> startPayment(PaymobParams params);
}
