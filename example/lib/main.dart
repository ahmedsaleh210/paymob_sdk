import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paymob_sdk/paymob_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _paymobSdk = PaymobSdk();
  static const String _publicKey =
      'PUBLIC_KEY'; // Replace with your actual public key from Paymob dashboard

  /// ⚠️ WARNING: Never expose your secret key in client-side code.
  /// This key is placed here for demonstration purposes only.
  /// In production, keep it strictly on your backend server.
  static const String _secretKey = "SECRET_KEY";
  late final Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://accept.paymob.com/v1/',
        headers: {
          'Authorization': 'Token $_secretKey',
          'Content-Type': 'application/json',
        },
      ),
    )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  /// ⚠️ NOTE: This function should be implemented on your backend server.
  /// Your backend should create the payment intention and return only
  /// the [client_secret] to the app. It is included here for demonstration
  /// purposes only.
  Future<String> _createPaymentIntention(int amount) async {
    int amountInCents = amount * 100;
    final response = await _dio.post(
      'intention/',
      data: {
        "amount": amountInCents,
        "currency": "EGP",
        "payment_methods": [5561416],
        "billing_data": {
          "first_name": "Test",
          "last_name": "User",
          "email": "test@test.com",
          "phone_number": "01012345678",
          "apartment": "NA",
          "floor": "NA",
          "street": "NA",
          "building": "NA",
          "city": "Cairo",
          "country": "EG",
        },
      },
    );
    return response.data['client_secret'];
  }

  void _pay(BuildContext context) async {
    final clientSecret = await _createPaymentIntention(100);
    final result = await _paymobSdk.startPayment(
      PaymobParams(
        publicKey: _publicKey,
        clientSecret: clientSecret,
        appName: 'Test App',
        buttonBackgroundColor: Colors.black,
        buttonTextColor: Colors.white,
        saveCardDefault: false,
        showSaveCard: false,
      ),
    );
    if (!context.mounted) return;
    switch (result) {
      case PaymobTransactionStatus.successful:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment successful!')));
        break;
      case PaymobTransactionStatus.rejected:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment rejected. Please try again.')),
        );
        break;
      case PaymobTransactionStatus.pending:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment pending. You will be notified.'),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment status unknown.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  _pay(context);
                },
                child: const Text('Start Payment'),
              ),
            );
          }
        ),
      ),
    );
  }
}
