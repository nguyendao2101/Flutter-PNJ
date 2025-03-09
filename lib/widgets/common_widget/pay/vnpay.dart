// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class PaymentWebView extends StatefulWidget {
//   final String paymentUrl;
//
//   const PaymentWebView({Key? key, required this.paymentUrl}) : super(key: key);
//
//   @override
//   _PaymentWebViewState createState() => _PaymentWebViewState();
// }
//
// class _PaymentWebViewState extends State<PaymentWebView> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(widget.paymentUrl));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Thanh toán VNPAY"),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
