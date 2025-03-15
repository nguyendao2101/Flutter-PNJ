import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../view_model/by_cart_view_model.dart';
import '../../../view_model/get_data_view_model.dart';

class Confirmed extends StatefulWidget {
  const Confirmed({super.key});

  @override
  State<Confirmed> createState() => _ConfirmedState();
}

class _ConfirmedState extends State<Confirmed> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(ByCartViewModel());

  @override
  void initState() {
    super.initState();
    _loadOrderTracking();
  }

  Future<void> _loadOrderTracking() async {
    try {
      await getDataViewModel.fetchOrderTracking();

      // Kiểm tra dữ liệu nhận được từ API
      print("Fetched orderTracking: ${getDataViewModel.orderTracking}");

    } catch (e) {
      print("Error loading data: $e");
      Get.snackbar(
        "Error",
        "Failed to load data. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");
    return Obx(() {
      if (getDataViewModel.orderTracking.isEmpty) {
        return const Center(child: Text("Your pending Cart is empty."));
      }

      var pendingOrders = getDataViewModel.orderTracking.where((item) {
        print("Comparing UserID: ${item['idUserOrder']} == ${ordersViewModel.userId}");
        print("Comparing Status: ${item['status']} == 'confirmed'");

        return item['idUserOrder'].toString() == ordersViewModel.userId.toString() &&
            item['status'].toString() == 'confirmed';
      }).toList();

      return pendingOrders.isEmpty
          ? const Center(child: Text("No pending orders found."))
          : ListView.builder(
        itemCount: pendingOrders.length,
        itemBuilder: (context, index) {
          var item = pendingOrders[index];
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 7,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${item['orderId']}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff1C1B1F),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                if (item['productItems'] is List)
                  for (var product
                  in item['productItems'])
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 2,child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),bottomLeft:  Radius.circular(12))
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                              CachedNetworkImage(
                                imageUrl: product['image'] ?? product['imgURL'],
                                height: 80,
                                width: 110,
                                placeholder: (context, url) => const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: const CircularProgressIndicator(strokeWidth: 2)), // Hiển thị khi tải
                                errorWidget: (context, url, error) => const Icon(Icons.error), // Hiển thị khi lỗi
                                fit: BoxFit.cover, // Căn chỉnh hình ảnh
                              ),
                            ),
                          )),
                          Expanded(flex: 3,child: Container(
                            height: 130,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? product['nameProduct'] ,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff1C1B1F),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                    maxLines: 2, // Giới hạn tối đa 2 dòng
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Quantity: ${product['quantity'] ?? product['stock']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff1C1B1F),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        "Size: ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffA02334),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${product['size'].toString()}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address: ${item['addressUserGet']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff1C1B1F),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Payment Method: ${item['typePayment '] ?? item['typePayment']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff1C1B1F),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Total: ${currencyFormat.format(item['totalAmount'])} đ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xffA02334),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        },
      );
    });

  }
}
