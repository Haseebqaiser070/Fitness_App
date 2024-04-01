import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String? message;
  bool? success;
  StripeTransactionResponse({this.message, this.success});
}

/*
Publishable key
pk_test_51JZfXTL3GGZFa3bGQtCuRKNRSqBv0INrZv9n7ac9qlK3bZ7nIREWpKmfT8ZdCKmiVgEDxFUnToG09z6Y01Q85hUR00UnbvRfGe

Secret key
sk_test_51JZfXTL3GGZFa3bGvbOpYWS4u8592gjgc4FsmuCEhGoEsuINWbhVh1DOQWpPmNuHQU0YVioioy9I5BzHsp6zHMjO00491yjWck
*/

class StripeService {
  static String? apiBase = 'https://api.stripe.com/v1';
  static String? paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String? secret =
      "sk_test_51JZfXTL3GGZFa3bGvbOpYWS4u8592gjgc4FsmuCEhGoEsuINWbhVh1DOQWpPmNuHQU0YVioioy9I5BzHsp6zHMjO00491yjWck";
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_51JZfXTL3GGZFa3bGQtCuRKNRSqBv0INrZv9n7ac9qlK3bZ7nIREWpKmfT8ZdCKmiVgEDxFUnToG09z6Y01Q85hUR00UnbvRfGe",
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String? amount, String? currency, CreditCard? card}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var paymentIntent =
          await StripeService.createPaymentIntent(amount!, currency!);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent!['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        debugPrint('${response.status}');
        return StripeTransactionResponse(
            message: response.paymentIntentId, success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String? amount, String? currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(amount!, currency!);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent!['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        debugPrint(response.paymentIntentId);
        return StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl!),
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
    return null;
  }
}
