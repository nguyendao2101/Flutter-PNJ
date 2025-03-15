// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../view_model/by_cart_view_model.dart';
// import '../../../view_model/get_data_view_model.dart';
//
// class Pending extends StatefulWidget {
//   const Pending({super.key});
//
//   @override
//   State<Pending> createState() => _PendingState();
// }
//
// class _PendingState extends State<Pending> {
//   final getDataViewModel = Get.put(GetDataViewModel());
//   final ordersViewModel = Get.put(ByCartViewModel());
//
//   @override
//   void initState() {
//     super.initState();
//     _loadOrderTracking();
//   }
//
//   Future<void> _loadOrderTracking() async {
//     try {
//       await getDataViewModel.fetchOrderTracking();
//
//       // Kiểm tra dữ liệu nhận được từ API
//       print("Fetched orderTracking: ${getDataViewModel.orderTracking}");
//
//     } catch (e) {
//       print("Error loading data: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to load data. Please try again later.",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (getDataViewModel.orderTracking.isEmpty) {
//         return const Center(child: Text("Your pending Cart is empty."));
//       }
//
//       var pendingOrders = getDataViewModel.orderTracking.where((item) {
//         print("Comparing UserID: ${item['idUserOrder']} == ${ordersViewModel.userId}");
//         print("Comparing Status: ${item['status']} == 'pending'");
//
//         return item['idUserOrder'].toString() == ordersViewModel.userId.toString() &&
//             item['status'].toString() == 'pending';
//       }).toList();
//
//       return pendingOrders.isEmpty
//           ? const Center(child: Text("No pending orders found."))
//           : ListView.builder(
//         itemCount: pendingOrders.length,
//         itemBuilder: (context, index) {
//           var item = pendingOrders[index];
//           return ListTile(
//             title: Text("Order ID: ${item['orderId']}"),
//             subtitle: Text("Status: ${item['status']}"),
//           );
//         },
//       );
//     });
//
//   }
// }
