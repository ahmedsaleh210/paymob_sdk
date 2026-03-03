# Paymob Native SDK

A Flutter plugin that integrates the **Paymob** payment gateway into your Android and iOS applications. It wraps the native Paymob SDK and exposes a simple Dart API to launch the payment UI and receive the transaction result.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Prerequisites](#prerequisites)
- [Android Setup](#android-setup)
- [Usage](#usage)
  - [1. Create a Payment Intention (Backend)](#1-create-a-payment-intention-backend)
  - [2. Start Payment (Flutter)](#2-start-payment-flutter)
  - [3. Handle the Result](#3-handle-the-result)
- [API Reference](#api-reference)
  - [PaymobSdk](#paymodsdk)
  - [PaymobParams](#payмobparams)
  - [PaymobCheckoutStatus](#paymobcheckoutstatus)
- [Complete Example](#complete-example)
- [Security Notes](#security-notes)
- [Troubleshooting](#troubleshooting)

---

## Features

- Launch the Paymob native payment UI with a single method call.
- Customize the payment button appearance (background color, text color).
- Control the "Save Card" feature (show/hide, default state).
- Receive a typed transaction status upon completion.
- Supports **Android** and **iOS**.

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  paymob_sdk: <latest>
```

Then run:

```bash
flutter pub get
```

---

## Android Setup

### 1. Add JitPack Repository

In your `android/settings.gradle.kts`, add JitPack inside the `pluginManagement` repositories block:

```kotlin
pluginManagement {
    repositories {
        // ... your existing repositories
        maven { url = uri("https://jitpack.io") }
    }
}
```

### 2. Enable Data Binding

In your app's `android/app/build.gradle.kts`, enable **Data Binding** inside the `android` block:

```kotlin
android {
    // ... your existing config

    buildFeatures {
        dataBinding = true
    }
}
```

> ⚠️ Without this, the app will crash on Android.

---

## Prerequisites

Before using this plugin you need:

1. A **Paymob** merchant account — sign up at [Paymob Dashboard](https://accept.paymob.com/portal2/en/login).
2. Your **Public Key** (`publicKey`) — found in your Paymob dashboard.
3. A **Secret Key** (`secretKey`) — keep this **on your backend only**, never ship it inside the app.
4. A **Payment Intention** created on your backend for each transaction, which returns a `client_secret`.

---

## Usage

### 1. Create a Payment Intention (Backend)

Before launching the payment UI, your **backend server** must create a Payment Intention via the Paymob API and return the `client_secret` to your app.

> 📖 Follow the official Paymob documentation to implement this on your backend:
> **[Create a Payment Intention — Paymob Docs](https://developers.paymob.com/paymob-docs/developers/intention-apis/create-intention)**

Once your backend creates the intention, return **only the `client_secret`** to your Flutter app and pass it to `PaymobParams`.

> ⚠️ **Never create the Payment Intention from inside the Flutter app.** Your Secret Key must remain exclusively on your backend server.

---

### 2. Start Payment (Flutter)

```dart
import 'package:paymob_sdk/paymob_sdk.dart';

final _paymobSdk = PaymobSdk();

Future<void> pay() async {
  // Obtain client_secret from YOUR backend
  final clientSecret = await yourBackend.createPaymentIntention(amount: 100);

  await _paymobSdk.startPayment(
    PaymobParams(
      publicKey: 'YOUR_PUBLIC_KEY',
      clientSecret: clientSecret,
      appName: 'My App',                          // optional
      buttonBackgroundColor: Colors.blue,         // optional
      buttonTextColor: Colors.white,              // optional
      saveCardDefault: false,                     // optional
      showSaveCard: true,                         // optional
    ),
    onCheckoutStatus: (status) {
      // handle status
    },
  );
}
```

---

### 3. Handle the Result

`startPayment` accepts an optional `onCheckoutStatus` callback that is invoked with the final `PaymobCheckoutStatus` when the flow completes:

```dart
await _paymobSdk.startPayment(
  params,
  onCheckoutStatus: (status) {
    switch (status) {
      case PaymobCheckoutStatus.successful:
        // Payment was completed successfully
        break;
      case PaymobCheckoutStatus.rejected:
        // Payment was declined / rejected
        break;
      case PaymobCheckoutStatus.pending:
        // Payment is pending (e.g. cash payment awaiting confirmation)
        break;
      case PaymobCheckoutStatus.unknown:
        // Unexpected state
        break;
    }
  },
);
```

---

## API Reference

### `PaymobSdk`

The main entry point of the plugin.

```dart
class PaymobSdk {
  Future<PaymobCheckoutStatus?> startPayment(
    PaymobParams params, {
    void Function(PaymobCheckoutStatus status)? onCheckoutStatus,
  });
}
```

| Method | Description |
|--------|-------------|
| `startPayment(PaymobParams params, {onCheckoutStatus})` | Launches the Paymob payment UI. Invokes the optional `onCheckoutStatus` callback and returns the status when the flow completes. Throws a `PlatformException` if the native SDK encounters an unrecoverable error. |

---

### `PaymobParams`

Configuration object passed to `startPayment`.

```dart
const PaymobParams({
  required String publicKey,
  required String clientSecret,
  String? appName,
  Color? buttonBackgroundColor,
  Color? buttonTextColor,
  bool? saveCardDefault,
  bool? showSaveCard,
});
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `publicKey` | `String` | ✅ | Your Paymob public key from the dashboard. |
| `clientSecret` | `String` | ✅ | The `client_secret` returned by the Paymob payment intention API. A new secret must be generated for each transaction. |
| `appName` | `String?` | ❌ | Display name shown inside the Paymob payment UI. |
| `buttonBackgroundColor` | `Color?` | ❌ | Background color of the pay/confirm button. Defaults to the Paymob theme color. |
| `buttonTextColor` | `Color?` | ❌ | Text color of the pay/confirm button. |
| `saveCardDefault` | `bool?` | ❌ | Whether the "Save card" checkbox should be checked by default. Defaults to `false`. |
| `showSaveCard` | `bool?` | ❌ | Whether to display the "Save card" option to the user. Defaults to `true`. |

---

### `PaymobCheckoutStatus`

An enum representing the final state of a payment attempt.

```dart
enum PaymobCheckoutStatus {
  successful,  // Transaction completed and approved
  rejected,    // Transaction was declined
  pending,     // Transaction is awaiting offline confirmation
  unknown,     // Unrecognised status returned by the SDK
}
```

| Value | Description |
|-------|-------------|
| `successful` | The payment was processed and approved by the payment network. |
| `rejected` | The payment was declined (insufficient funds, invalid card, etc.). |
| `pending` | The transaction was submitted but final confirmation is pending (e.g. Fawry / cash payment). |
| `unknown` | The SDK returned an unrecognised value. Treat this as an error state. |

---

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:paymob_sdk/paymob_sdk.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  final _paymobSdk = PaymobSdk();
  static const _publicKey = 'YOUR_PUBLIC_KEY';

  Future<void> _pay(BuildContext context) async {
    // Step 1: Get client_secret from your backend
    final clientSecret = await yourBackendService.createIntention(amount: 100);

    // Step 2: Launch the payment UI
    await _paymobSdk.startPayment(
      PaymobParams(
        publicKey: _publicKey,
        clientSecret: clientSecret,
        appName: 'My Store',
        buttonBackgroundColor: Colors.indigo,
        buttonTextColor: Colors.white,
        showSaveCard: true,
        saveCardDefault: false,
      ),
      // Step 3: React to the result
      onCheckoutStatus: (status) {
        if (!context.mounted) return;
        switch (status) {
          case PaymobCheckoutStatus.successful:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful!')),
            );
            break;
          case PaymobCheckoutStatus.rejected:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment rejected. Please try again.')),
            );
            break;
          case PaymobCheckoutStatus.pending:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment pending. You will be notified.')),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment status unknown.')),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pay(context),
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
```

---

## Security Notes

| Rule | Reason |
|------|--------|
| **Never embed your secret key in the app.** | The secret key grants full access to your Paymob merchant account. It must live exclusively on your backend server. |
| **Generate a new `client_secret` per transaction.** | A `client_secret` is single-use and tied to a specific amount and currency. Reusing it can lead to incorrect charges. |
| **Validate the transaction on your backend.** | Always confirm the final transaction status via Paymob's server-to-server webhook or transaction inquiry API — do not rely solely on the status returned by the SDK. |

---

## Troubleshooting

**App crashes immediately when calling `startPayment` on Android**
- This is most likely caused by missing Data Binding configuration. Make sure you have added the following to your `android/app/build.gradle.kts`:
  ```kotlin
  android {
      buildFeatures {
          dataBinding = true
      }
  }
  ```
  Then run `flutter clean && flutter pub get` and rebuild the app.

**`PlatformException` is thrown when calling `startPayment`**
- Make sure the `publicKey` and `clientSecret` are correct and not expired.
- Ensure the native Paymob SDK is properly linked (run `pod install` for iOS, sync Gradle for Android).

**Payment UI does not appear on iOS**
- Run `pod install` inside the `ios/` folder of your project.
- Confirm that `PaymobSdkPlugin` is listed in `GeneratedPluginRegistrant`.

**`unknown` status returned unexpectedly**
- This may happen if the user force-closes the payment sheet. Handle it gracefully, e.g. by prompting the user to retry.
