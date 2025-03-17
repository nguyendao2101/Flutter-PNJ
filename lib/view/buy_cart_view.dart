import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/by_cart_view_model.dart';
import 'package:flutter_pnj/view_model/get_data_view_model.dart';
import 'package:flutter_pnj/widgets/common_widget/product_card/product_detail.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../view_model/home_view_model.dart';
import '../widgets/common_widget/pay/payment_view.dart';

class BuyCartView extends StatefulWidget {
  const BuyCartView({super.key});

  @override
  State<BuyCartView> createState() => _BuyCartViewState();
}

class _BuyCartViewState extends State<BuyCartView> {
  final controller = Get.put(ByCartViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  final controllerHome = Get.put(HomeViewModel());

  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    controller.ordersList;
    controller.listenToOrders();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await controllerGetData.fetchProducts();
    setState(() {
      _products = controllerGetData.products;
      _isLoadingProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Shopping Cart",
          style: TextStyle(
            fontSize: 24,
            color: Color(0xff32343E),
            fontWeight: FontWeight.w500,
            fontFamily: 'Jost',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.ordersList.isEmpty) {
          return const Center(
            child: Text("Không có sản phẩm trong giỏ hàng"),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.ordersList.length,
                itemBuilder: (context, index) {
                  return _buildCartItem(index, currencyFormat);
                },
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.selectedItems.isEmpty) {
          return const SizedBox
              .shrink(); // Ẩn nút nếu không có sản phẩm nào được chọn
        }
        return FloatingActionButton.extended(
          onPressed: () {
            final selectedProducts = controller.checkoutSelectedItems();

            // Bước 2: Kiểm tra có vượt tồn kho không
            final hasOverStock =
                controller.isSelectedProductsOverStock(selectedProducts);

            // Bước 3: Nếu vượt kho, thông báo lỗi và return
            if (hasOverStock) {
              Get.snackbar(
                'Lỗi',
                'Có sản phẩm vượt quá số lượng tồn kho!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }

            // Bước 4: Nếu hợp lệ, chuyển qua trang thanh toán
            Get.to(() => PaymentView(
                  product: selectedProducts,
                ));
          },
          label: const Text(
            'Buy',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xffFFFFFF),
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          backgroundColor: const Color(0xff981622),
          icon: const Icon(
            Icons.shopping_cart_checkout,
            color: Colors.white,
          ),
        );
      }),
    );
  }

  /// **Widget xây dựng từng mục trong giỏ hàng**
  Widget _buildCartItem(int index, NumberFormat currencyFormat) {
    final item = controller.ordersList[index];
    final product = _products.firstWhere(
      (prod) => prod['id'] == item['idProduct'],
      orElse: () => {},
    );

    List<Map<String, dynamic>> sizePriceList = [];
    var rawData = product['sizePrice'] as List<dynamic>?;
    if (rawData != null) {
      sizePriceList = rawData.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    final matchedSizePrice = sizePriceList.firstWhere(
      (sp) => sp['size'] == item['size'],
      orElse: () => {},
    );
    int price =
        matchedSizePrice.isNotEmpty ? matchedSizePrice['price'] ?? 0 : 0;

    return Dismissible(
      key: Key(item['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        controllerHome.removeFromShoppingCart(item['idProduct'], item['size']);
        print('xoa: ${item['idProduct']} va ${item['size']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item ${product['nameProduct']} removed')),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.to(() => ProductDetail(productDetail: product));
        },
        child: Container(
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
              Expanded(
                  flex: 3,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: product['productImg']?.isNotEmpty == true
                            ? product['productImg'].first
                            : 'https://storage.googleapis.com/duan-4904c.appspot.com/flutter_pnj/Trang%20s%E1%BB%A9c/B%C3%B4ng%20tai/11/gbxmxmy004922-bong-tai-vang-18k-dinh-da-cz-pnj-02.png?GoogleAccessId=firebase-adminsdk-v1s7v%40duan-4904c.iam.gserviceaccount.com&Expires=1893430800&Signature=skId0uhYKxXlF16CKqXnBKGrw21ZI9onCODbveScBugPGiXRFSWXQXdq4AUIKUUbwNFl6h1MMi0fz39PdfGTbH98Oe6MzJLMqPqNDawu5MYAgFqgQPZEzdx7zd9%2FAFaD8CED6mulA1I7lUNZ8CLNHSTrCI%2FcNUf7dylYLjyMQMcdK1wjeTszuja4VXfzSEfak9eLHRgIi%2FZ7adaZayWF6uux2aO75ek2753rCB77Y9PrBCO6c30bu4Wzo6U%2B73AdvCsNmYBv1xu3fhtmUBS0v%2B8RYdSAcOtfzmgoDGzrUpvP%2BovkSnHCkKuQA6KT%2BP6YOblMiK7EIDAgrXnfz21JTw%3D%3D',
                        height: 80,
                        width: 110,
                        placeholder: (context, url) => const SizedBox(
                            height: 24,
                            width: 24,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2)), // Hiển thị khi tải
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error), // Hiển thị khi lỗi
                        fit: BoxFit.cover, // Căn chỉnh hình ảnh
                      ),
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                    height: 180,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['nameProduct'] ?? 'Không có tiêu đề',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${currencyFormat.format(price)} đ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffA02334),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        controller.decreaseQuantity(index),
                                    icon: _iconContainer(Icons.remove),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '${item['Quantity'] ?? 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.increaseQuantity(index),
                                    icon: _iconContainer(Icons.add),
                                  ),
                                ],
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xffA02334),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${item['size']}',
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
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 180,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: Obx(
                      () => Checkbox(
                        value: controller.selectedItems.contains(index),
                        onChanged: (bool? value) =>
                            controller.toggleItemSelection(index),
                        activeColor: const Color(0xff981622),
                        checkColor: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// **Widget tạo IconButton có hình tròn**
  Widget _iconContainer(IconData icon) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(icon, color: Colors.black, size: 18),
    );
  }
}
