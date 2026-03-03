## 0.0.1

* Initial release of the Paymob Flutter SDK.
* Added `PaymobSdk.startPayment()` to launch the Paymob payment flow on Android and iOS.
* Added `PaymobParams` for configuring the payment session with `publicKey`, `clientSecret`, and optional UI customization (`appName`, `buttonBackgroundColor`, `buttonTextColor`).
* Added `saveCardDefault` and `showSaveCard` options in `PaymobParams` to control card-saving behavior.
* Added `PaymobCheckoutStatus` enum with `successful`, `rejected`, `pending`, and `unknown` states to represent checkout outcomes.
* Supports a callback-based result via the `onCheckoutStatus` handler in `startPayment()`.
