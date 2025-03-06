import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/by_cart_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
// import 'package:vnpay_flutter/vnpay_flutter.dart';

import '../../../view_model/get_data_view_model.dart';
import '../../../view_model/home_view_model.dart';
import '../../common/image_extention.dart';
import '../button/bassic_button.dart';
class PaymentView extends StatefulWidget {
  List<Map<String, dynamic>> product;
  PaymentView({super.key, required this.product});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final controller = Get.put(ByCartViewModel());
  final controllerHome = Get.put(HomeViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  TextEditingController couponController = TextEditingController();
  double coupon = 0;  // Khai báo coupon là biến trạng thái
  double delivery = 0;  // Khai báo coupon là biến trạng thái
  int price = 0;
  List<Map<String, dynamic>> selectedPrices = [];

  //
  List<Map<String, dynamic>> _stores = [];
  String? _selectedStoreId;
  bool _isLoadingStores = false;
  String? selectedLocation; // Lưu địa chỉ được chọn
  String? selectedLocationName ; // Lưu địa chỉ được chọn
  var selectedPaymentMethod = Rxn<Map<String, String>>();

  final List<Map<String, String>> paymentMethods = [
    {'id': '1', 'name': 'Cash on Delivery'},
    {'id': '2', 'name': 'Payment via VNPay'},
    {'id': '3', 'name': 'Payment via Stripe'},
  ];
  String responseCode = '';
  String imageURL = '';
  String imageFace = '';
  List<int> quantities = [];
  List<String> nameProduct = []; // Sửa kiểu dữ liệu của nameProduct thành List<String>
  List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = true;


  @override
  void initState() {
    super.initState();
    _loadProducts();
    // controller.fetchStores();
    //
    // // Sửa việc chuyển đổi `Name` sang kiểu String
    // quantities = widget.product.map<int>((item) => item['Quantity'] ?? 0).toList();
    // nameProduct = widget.product.map<String>((item) => item['Name'] ?? '').toList(); // Sửa kiểu dữ liệu thành String
    // imageURL = widget.product.isNotEmpty
    //     ? (widget.product[0]['ImageUrl'] ?? '') // Lấy giá trị đầu tiên hoặc rỗng
    //     : '';
    // imageFace = widget.product.isNotEmpty
    //     ? (widget.product[0]['ImageUrlFacebook'] ?? '') // Lấy giá trị đầu tiên hoặc rỗng
    //     : '';
  }

  Future<void> _loadProducts() async {
    await controllerGetData.fetchProducts();
    setState(() {
      products = controllerGetData.products;
      isLoadingProducts = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    double x;
    double y;
    double total1 = controller.calculateTotal(widget.product, price);  // Cập nhật tổng tiền với coupon
    // double total = controller.calculateTotal(widget.product) - coupon + delivery;  // Cập nhật tổng tiền với coupon
    final selectedStore = Rx<Map<String, dynamic>?>(null); // Lưu cửa hàng được chọn
    final selectedAddress = Rx<Map<String, dynamic>?>(null); // Lưu cửa hàng được chọn
    final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffD9D9D9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ImageAsset.backButton,
                      height: 5,
                      width: 6,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Pay Your Order',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xff32343E),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Text(widget.product['Quantity']),
              // ListView.builder
              ListView.builder(
                itemCount: widget.product.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final selectedProducts = widget.product; // Gọi hàm để lấy danh sách đã lọc

                  if (index < 0 || index >= selectedProducts.length) {
                    return const SizedBox();
                  }

                  final selectedProduct = selectedProducts[index]['originalIndex']; // Lấy sản phẩm từ danh sách đã lọc

                  return _buildCartItem(selectedProduct, currencyFormat);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  /// **Widget xây dựng từng mục trong giỏ hàng**
  Widget _buildCartItem(int index, NumberFormat currencyFormat) {
    final item = controller.ordersList[index];
    final product = products.firstWhere(
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
    price = matchedSizePrice.isNotEmpty ? matchedSizePrice['price'] ?? 0 : 0;
    int quantity = (item['Quantity'] ?? 1).toInt();

    // Thêm giá và số lượng vào danh sách
    selectedPrices.add({'price': price, 'quantity': quantity});
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
        controllerHome.removeFromShoppingCart(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item ${product['nameProduct']} removed')),
        );
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
            Expanded(flex: 3,child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),bottomLeft:  Radius.circular(12))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['productImg']?.isNotEmpty == true ? product['productImg'].first : 'https://storage.googleapis.com/duan-4904c.appspot.com/flutter_pnj/Trang%20s%E1%BB%A9c/B%C3%B4ng%20tai/11/gbxmxmy004922-bong-tai-vang-18k-dinh-da-cz-pnj-02.png?GoogleAccessId=firebase-adminsdk-v1s7v%40duan-4904c.iam.gserviceaccount.com&Expires=1893430800&Signature=skId0uhYKxXlF16CKqXnBKGrw21ZI9onCODbveScBugPGiXRFSWXQXdq4AUIKUUbwNFl6h1MMi0fz39PdfGTbH98Oe6MzJLMqPqNDawu5MYAgFqgQPZEzdx7zd9%2FAFaD8CED6mulA1I7lUNZ8CLNHSTrCI%2FcNUf7dylYLjyMQMcdK1wjeTszuja4VXfzSEfak9eLHRgIi%2FZ7adaZayWF6uux2aO75ek2753rCB77Y9PrBCO6c30bu4Wzo6U%2B73AdvCsNmYBv1xu3fhtmUBS0v%2B8RYdSAcOtfzmgoDGzrUpvP%2BovkSnHCkKuQA6KT%2BP6YOblMiK7EIDAgrXnfz21JTw%3D%3D',
                  fit: BoxFit.fill,
                  width: 80,
                  height: 80,
                ),
              ),
            )),
            Expanded(flex: 5,child: Container(
              height: 150,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity: ${item['Quantity'] ?? 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        )
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
          ],
        ),
      ),
    );
  }

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

  double calculateTotalPrice() {
    return selectedPrices.fold(0.0, (total, item) {
      return total + (item['price'] * item['quantity']);
    });
  }


}


