import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'consts.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  // Future<void> makePayment(double amountVND) async {
  //   try {
  //     // Chuyển đổi từ VND sang USD
  //     double exchangeRate = 0.000041; // Tỷ giá VND/USD, nên cập nhật thường xuyên
  //     int amountUSD = (amountVND * exchangeRate).round();
  //
  //     String? paymentIntentClientSecret = await _createPaymentIntent(amountUSD, "usd");
  //     if (paymentIntentClientSecret == null) return;
  //
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentClientSecret,
  //         merchantDisplayName: "Nguyen Dao",
  //       ),
  //     );
  //     await _processPayment();
  //   } catch (e) {
  //     print("Lỗi khi thanh toán: $e");
  //   }
  // }
  Future<String?> makePayment(double amountVND) async {
    try {
      double exchangeRate = 0.000041;
      int amountUSD = (amountVND * exchangeRate).round();

      String? paymentIntentClientSecret = await _createPaymentIntent(amountUSD, "usd");
      if (paymentIntentClientSecret == null) return null;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Nguyen Dao",
        ),
      );

      return paymentIntentClientSecret; // Trả về client_secret để gọi ở View
    } catch (e) {
      print("Lỗi khi tạo Payment Intent: $e");
      return null;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey"
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print("Lỗi khi tạo Payment Intent: $e");
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Thanh toán thành công!");
    } catch (e) {
      if (e is StripeException) {
        print("Lỗi Stripe: ${e.error.localizedMessage}");
      } else {
        print("Lỗi không xác định: $e");
      }
    }
  }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100; // Chuyển đổi sang cent
    return calculateAmount.toString();
  }
}