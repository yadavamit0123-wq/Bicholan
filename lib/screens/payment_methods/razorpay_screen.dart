import 'dart:convert';

import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/wallet/my_wallet.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_history.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../helpers/main_helpers.dart';
import '../../helpers/shared_pref.dart';
import '../../main.dart';
import '../../redux/libs/helpers/show_message_state.dart';
import '../account/account_middleware.dart';

class RazorpayScreen extends StatefulWidget {
  var amount;
  String? payment_type;
  String? payment_method_key;
  String? package_id;

  RazorpayScreen({
    super.key,
    this.amount,
    this.payment_type,
    this.payment_method_key,
    this.package_id,
  });

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  late Razorpay _razorpay;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _orderData;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createOrderAndOpenCheckout();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _createOrderAndOpenCheckout() async {
    final accessToken = SharedPref().accessToken ?? await getToken;
    final userId = store.state.authState?.userData?.id;

    if (accessToken == null || userId == null) {
      setState(() {
        _errorMessage = 'Please login again to continue payment.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.BASE_URL}/razorpay/create-order'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'amount': widget.amount.toString(),
          'payment_type': widget.payment_type,
          'package_id': widget.package_id?.toString() ?? '0',
          'payment_method': widget.payment_method_key ?? 'razorpay',
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || data['result'] != true) {
        throw Exception(data['message']?.toString() ?? 'Could not start Razorpay payment.');
      }

      _orderData = data;
      setState(() {
        _isLoading = false;
      });

      _razorpay.open({
        'key': data['key'],
        'amount': data['amount'],
        'order_id': data['order_id'],
        'currency': data['currency'] ?? 'INR',
        'name': data['name'] ?? 'Bicholan',
        'description': data['description'] ?? '',
        'image': data['image'],
        'prefill': data['prefill'] ?? {},
        'external': {
          'wallets': ['paytm', 'phonepe', 'gpay'],
        },
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyPaymentOnServer(PaymentSuccessResponse response) async {
    final accessToken = SharedPref().accessToken ?? await getToken;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final verifyResponse = await http.post(
        Uri.parse('${AppConfig.BASE_URL}/razorpay/payment'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'razorpay_payment_id': response.paymentId,
          'razorpay_order_id': response.orderId,
          'razorpay_signature': response.signature,
          'user_id': _orderData?['user_id'] ?? store.state.authState?.userData?.id,
          'payment_type': widget.payment_type,
          'package_id': widget.package_id?.toString() ?? '0',
          'amount': widget.amount.toString(),
          'payment_method': widget.payment_method_key ?? 'razorpay',
        }),
      );

      final data = jsonDecode(verifyResponse.body) as Map<String, dynamic>;

      if (data['result'] == true) {
        store.dispatch(ShowMessageAction(msg: data['message']?.toString() ?? 'Payment successful'));
        _handleNavigation();
      } else {
        store.dispatch(ShowMessageAction(msg: data['message']?.toString() ?? 'Payment failed'));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      store.dispatch(ShowMessageAction(msg: 'Payment verification failed'));
      if (mounted) Navigator.pop(context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _verifyPaymentOnServer(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;

    final message = response.message ?? 'Payment cancelled';
    if (message.toLowerCase().contains('cancel')) {
      Navigator.pop(context);
      return;
    }

    store.dispatch(ShowMessageAction(msg: message));
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    store.dispatch(ShowMessageAction(msg: 'External wallet selected: ${response.walletName}'));
  }

  void _handleNavigation() {
    if (widget.payment_type == 'wallet_payment') {
      NavigatorPush.push_remove_untill(page: MyWallet(from_wallet: true));
      OneContext().navigator.push(
        MaterialPageRoute(builder: (context) => MyWallet(from_wallet: true)),
      );
    } else if (widget.payment_type == 'package_payment') {
      store.dispatch(accountMiddleware());
      OneContext().navigator.push(
        MaterialPageRoute(
          builder: (context) => PackageHistory(from_package: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        text: AppLocalizations.of(context)!.razorpay_screen_title,
      ).build(context),
      body: Center(
        child: _errorMessage != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading) const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    _isLoading
                        ? 'Opening Razorpay checkout...'
                        : 'Complete payment in Razorpay window',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
