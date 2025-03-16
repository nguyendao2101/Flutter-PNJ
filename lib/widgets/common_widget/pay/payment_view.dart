import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/by_cart_view_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import '../../../model/service/stripe_service.dart';
import '../../../view_model/get_data_view_model.dart';
import '../../../view_model/home_view_model.dart';
import '../../../view_model/profile_view_model.dart';
import '../../common/image_extention.dart';
import '../button/bassic_button.dart';
import '../profile/order_tracking.dart';

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
  final controllerProfile = Get.put(ProfileViewModel());

  TextEditingController couponController = TextEditingController();
  double coupon = 0; // Khai báo coupon là biến trạng thái
  double delivery = 0; // Khai báo coupon là biến trạng thái
  int price = 0;
  List<Map<String, dynamic>> selectedPrices = [];
  double total = 0;

  //
  List<Map<String, dynamic>> _stores = [];
  String? _selectedStoreId;
  bool _isLoadingStores = false;
  String? selectedLocation; // Lưu địa chỉ được chọn
  String selectedLocationName = ''; // Lưu địa chỉ được chọn
  var selectedPaymentMethod = Rxn<Map<String, String>>();
  List<String> selectedProducts = [];

  final List<Map<String, String>> paymentMethods = [
    {'id': '1', 'name': 'Cash on Delivery'},
    {'id': '2', 'name': 'Payment via VNPay'},
    {'id': '3', 'name': 'Payment via Stripe'},
  ];
  String responseCode = '';
  String imageURL = '';
  String imageFace = '';
  List<int> quantities = [];
  List<String> nameProduct =
      []; // Sửa kiểu dữ liệu của nameProduct thành List<String>
  List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = true;
  String enteredCode = '';
  Future<Map<String, String>>? _locationsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _locationsFuture = controller.listenToAddress();
    controller.fetchCoupons();
  }

  // void removeMultipleFromFavoriteCart() {
  //   List<String> productIds = controller.ordersList.map((item) {
  //     final product = products.firstWhere(
  //           (prod) => prod['id'] == item['idProduct'],
  //       orElse: () => {'id': ''}, // Tránh lỗi nếu không tìm thấy sản phẩm
  //     );
  //
  //     return product['id'].toString();
  //   }).where((id) => id.isNotEmpty).toList(); // Loại bỏ ID rỗng
  //
  //   if (productIds.isNotEmpty) {
  //     for (String productId in productIds) {
  //       print('da chon: $productId');
  //       controllerHome.removeFromFavoriteCart(productId); // Gọi hàm xóa từng sản phẩm
  //     }
  //   } else {
  //     Get.snackbar("Lỗi", "Không có sản phẩm nào để xóa!");
  //   }
  // }
  void removeMultipleShoppingCart() {
    List<Map<String, dynamic>> selectedProducts = controller.ordersList
        .map((item) {
          final product = products.firstWhere(
            (prod) => prod['id'] == item['idProduct'],
            orElse: () => {'id': ''}, // Tránh lỗi nếu không tìm thấy sản phẩm
          );

          return {
            'id': product['id'].toString(),
            'size': item['size'].toString(), // Lấy thêm size
          };
        })
        .where((item) => item['id']!.isNotEmpty)
        .toList(); // Loại bỏ sản phẩm không hợp lệ

    if (selectedProducts.isNotEmpty) {
      for (var product in selectedProducts) {
        print('Đã chọn de xoa: ID: ${product['id']}, Size: ${product['size']}');
        controllerHome.removeFromShoppingCart(
            product['id'], product['size']); // Gọi hàm xóa
      }
    } else {
      Get.snackbar("Lỗi", "Không có sản phẩm nào để xóa!");
    }
  }

  void saveOrder() {
    List<Map<dynamic, dynamic>> productItems = widget.product
        .map((item) {
          final product = products.firstWhere(
            (prod) => prod['id'] == item['idProduct'],
            orElse: () => {},
          );

          if (product == null) return {};

          // Ép kiểu danh sách sizePrice thành List<Map<String, dynamic>>
          var rawData = product['sizePrice'] as List<dynamic>? ?? [];
          List<Map<String, dynamic>> sizePriceList =
              rawData.map((e) => Map<String, dynamic>.from(e)).toList();

          // Lấy giá theo size
          final matchedSizePrice = sizePriceList.firstWhere(
            (sp) => sp['size'] == item['size'],
            orElse: () => {},
          );

          int price =
              matchedSizePrice.isNotEmpty ? matchedSizePrice['price'] ?? 0 : 0;
          int quantity = (item['Quantity'] ?? 1).toInt();

          return {
            'idProductNow': product['id'] as String,
            'description': product['description'] as String,
            'nameProduct': product['nameProduct'] as String,
            'image':
                (product['productImg'] as List<dynamic>?)?.firstOrNull ?? '',
            'size': item['size'] as int,
            'price': price,
            'quantity': quantity,
            'totalPrice': price * quantity,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList(); // Lọc bỏ phần tử rỗng

    // Gọi hàm thêm vào Firestore
    controllerGetData.addOrderToFirestore(
      addressUserGet: selectedLocationName,
      couponDiscount: coupon,
      couponId: enteredCode,
      emailUserGet: controllerProfile.userData['email'],
      idUserOrder: controller.userId.toString(),
      nameUserGet: controllerProfile.userData['fullName'],
      phoneUserGet: controllerProfile.userData['numberPhone'].toString(),
      productItems: productItems,
      status: 'pending',
      totalAmount: (total - coupon),
      typePayment: selectedPaymentMethod.value!['name'].toString(),
    );
  }

  Future<void> _loadProducts() async {
    await controllerGetData.fetchProducts();
    setState(() {
      products = controllerGetData.products;
      isLoadingProducts = false;
    });
  }

  double calculateTotalPrice() {
    if (selectedPrices.isEmpty)
      return 0.0; // Tránh lỗi tính toán trên danh sách rỗng

    return selectedPrices.fold(0.0, (total, item) {
      return total + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1));
    });
  }

  List<Map<String, dynamic>> _getSelectedPrices() {
    List<Map<String, dynamic>> tempList = [];

    for (var item in controller.ordersList) {
      final product = products.firstWhere(
        (prod) => prod['id'] == item['idProduct'],
        orElse: () => {}, // Nếu không tìm thấy, trả về object rỗng
      );

      if (product.isNotEmpty) {
        // Lấy danh sách sizePrice
        List<Map<String, dynamic>> sizePriceList = [];
        var rawData = product['sizePrice'] as List<dynamic>?;
        if (rawData != null) {
          sizePriceList =
              rawData.map((e) => Map<String, dynamic>.from(e)).toList();
        }

        // Tìm giá của sản phẩm theo size
        final matchedSizePrice = sizePriceList.firstWhere(
          (sp) => sp['size'] == item['size'],
          orElse: () => {},
        );

        double price =
            matchedSizePrice.isNotEmpty ? matchedSizePrice['price'] ?? 0 : 0;
        int quantity = (item['Quantity'] ?? 1).toInt();

        // Thêm vào danh sách selectedPrices
        tempList.add({'price': price, 'quantity': quantity});
      }
    }

    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    double x;
    double y;
    // double total1 = controller.calculateTotal(selectedPrices);  // Cập nhật tổng tiền với coupon
    // double total = controller.calculateTotal(widget.product) - coupon + delivery;  // Cập nhật tổng tiền với coupon
    final selectedStore =
        Rx<Map<String, dynamic>?>(null); // Lưu cửa hàng được chọn
    final selectedAddress =
        Rx<Map<String, dynamic>?>(null); // Lưu cửa hàng được chọn
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
                  final selectedProducts =
                      widget.product; // Gọi hàm để lấy danh sách đã lọc

                  if (index < 0 || index >= selectedProducts.length) {
                    return const SizedBox();
                  }

                  final selectedProduct = selectedProducts[index]
                      ['originalIndex']; // Lấy sản phẩm từ danh sách đã lọc

                  return _buildCartItem(selectedProduct, currencyFormat);
                },
              ),
              const SizedBox(width: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: couponController,
                        decoration: InputDecoration(
                          hintText: 'Add Promo code',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff32343E),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          border: InputBorder.none, // Bỏ viền
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical:
                                  10), // Điều chỉnh padding để căn chỉnh nội dung
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide:
                                BorderSide.none, // Bỏ viền khi không focus
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none, // Bỏ viền khi có focus
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        enteredCode = couponController.text
                            .trim(); // Lấy giá trị từ TextField
                        var matchingCoupon = controller.coupons.firstWhere(
                          (coupon) => coupon['id'] == enteredCode,
                          orElse: () =>
                              {}, // Trả về một map rỗng khi không tìm thấy
                        );

                        if (matchingCoupon.isNotEmpty) {
                          // Nếu tìm thấy mã giảm giá
                          print(
                              'Coupon found: ${matchingCoupon['discount']} VND');
                          setState(() {
                            coupon = matchingCoupon['discount']
                                .toDouble(); // Cập nhật coupon khi tìm thấy
                          });
                        } else {
                          // Nếu không tìm thấy mã giảm giá
                          print('Invalid coupon code');
                          setState(() {
                            coupon = 0; // Đặt lại coupon nếu không tìm thấy
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xffFBFBFB),
                        backgroundColor: const Color(
                            0xff981622), // Màu chữ khi button được nhấn
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              4), // Bo góc với bán kính 12
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
              _moneyToTal(
                  'Total', total, const Color(0xff5B645F), currencyFormat),
              _moneyToTal('Delivery fees', delivery, const Color(0xff5B645F),
                  currencyFormat),
              _moneyToTal(
                  'Promo', coupon, const Color(0xff5B645F), currencyFormat),
              _moneyToTal('Total', (total - coupon + delivery),
                  const Color(0xff5B645F), currencyFormat),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<Map<String, String>>(
                future: _locationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi khi tải dữ liệu: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final Map<String, String> locations = snapshot.data!;

                    // Tạo danh sách DropdownMenuItem từ dữ liệu
                    final dropdownItems = locations.entries
                        .map((entry) => DropdownMenuItem<String>(
                              value: entry.key, // ID địa chỉ làm giá trị
                              child: Text(
                                entry.value, // Địa chỉ hiển thị
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ))
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              labelText: 'Select Address',
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedLocation,
                                hint: const Text(
                                  'Select Address',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff32343E),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                isExpanded: true,
                                items: dropdownItems,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLocation = newValue;
                                    selectedLocationName =
                                        locations[selectedLocation]!;
                                  });

                                  print(
                                      'Địa chỉ được chọn: $selectedLocationName');
                                },
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff32343E),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                                icon: Image.asset(ImageAsset.downArrow,
                                    height: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('Không có địa chỉ nào.'));
                  }
                },
              ),
              Obx(() {
                // Tạo danh sách các mục Dropdown
                final List<DropdownMenuItem<Map<String, String>>>
                    dropdownItems = paymentMethods
                        .map((method) => DropdownMenuItem<Map<String, String>>(
                              value: method,
                              child: Text(
                                method['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff32343E),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ))
                        .toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          labelText: 'Select Payment Method',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Map<String, String>>(
                            value: selectedPaymentMethod.value,
                            items: dropdownItems,
                            onChanged: (method) {
                              selectedPaymentMethod.value = method;
                              print(
                                  'Selected payment method: ${method!['name']}');
                            },
                            hint: const Text(
                              'Select Payment Method',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff32343E),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                            dropdownColor: Colors.white,
                            icon: selectedPaymentMethod.value?['id'] == '1'
                                ? Image.asset(ImageAsset
                                    .money) // Thanh toán khi nhận hàng
                                : selectedPaymentMethod.value?['id'] == '2'
                                    ? SvgPicture.asset(
                                        ImageAsset.vnpay,
                                        height: 48,
                                      ) // Thanh toán VNPay
                                    : selectedPaymentMethod.value?['id'] == '3'
                                        ? Image.asset(
                                            ImageAsset.stripe,
                                            height: 48,
                                          ) // Thanh toán Stripe
                                        : const Icon(Icons.payment,
                                            color: Colors.grey), // Mặc định
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 16.0),
                    ],
                  ),
                );
              }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: BasicAppButton(
                  onPressed: () async {
                    // Debug giá trị trước khi xử lý
                    print(
                        'Selected Payment Method: ${selectedPaymentMethod.value}');
                    print('Response Code before payment1: $responseCode');

                    if (selectedPaymentMethod.value?['id'] == '2') {
                    } else if (selectedPaymentMethod.value?['id'] == '3') {
                      handlePayment(total, coupon);
                      controllerHome.addAllToPurchasedCart(widget.product);
                      // controllerHome.removeAllFromPurchasedCart(widget.product);
                    } else {
                      saveOrder();
                      showPaymentMethod(context, selectedPaymentMethod);
                      List<Map<String, dynamic>> selectedProducts =
                          widget.product.map((item) {
                        return {
                          'idProduct': item['idProduct'],
                          'size': item['size'],
                        };
                      }).toList();

                      controllerHome
                          .removeMultipleFromShoppingCart(selectedProducts);
                      controllerHome.addAllToPurchasedCart(widget.product);
                    }
                  },
                  title: 'Continue to payment',
                  sizeTitle: 16,
                  height: 62,
                  radius: 12,
                  colorButton: const Color(0xffFF7622),
                  fontW: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 100,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        total = 0; // Đặt lại total để tránh cộng dồn
        for (var order in widget.product) {
          final prod = products.firstWhere(
            (p) => p['id'] == order['idProduct'],
            orElse: () => {},
          );

          var sizes = prod['sizePrice'] as List<dynamic>?;
          List<Map<String, dynamic>> sizeList = sizes != null
              ? sizes.map((e) => Map<String, dynamic>.from(e)).toList()
              : [];

          var matched = sizeList.firstWhere(
            (sp) => sp['size'] == order['size'],
            orElse: () => {},
          );

          int itemPrice = matched.isNotEmpty ? matched['price'] ?? 0 : 0;
          int itemQuantity = (order['Quantity'] ?? 1).toInt();
          total += itemPrice * itemQuantity;
        }
      });
    });
    return Container(
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
                height: 150,
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
        ],
      ),
    );
  }

  Widget _moneyToTal(String title, double number, Color colorTitle,
      NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: colorTitle,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
          Row(
            children: [
              Text(
                currencyFormat.format(number).toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xffA02334),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'đ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff1C1B1F),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showPaymentMethod(
      BuildContext context, Rxn<Map<String, String>> selectedPaymentMethod) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Confirmation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Color(0xff32343E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (selectedPaymentMethod.value?['id'] == '1')
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        // Add a check icon for visual confirmation
                        const SizedBox(height: 24),
                        Image.asset(
                          ImageAsset.check,
                          height: 128,
                        ),
                        const SizedBox(height: 64),

                        const Text(
                          'Your order has been confirmed by PNJ.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        // Button to go to Order Tracking
                        TextButton(
                          onPressed: () {
                            // Get.to(() => const OrderTracking(initialIndex: 0,));
                            Get.to(() => const OrderTracking(
                                  initialIndex: 0,
                                ));
                          },
                          child: const Text(
                            'Order Tracking',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffE03137),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPaymentMethodFail(
      BuildContext context, Rxn<Map<String, String>> selectedPaymentMethod) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Confirmation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Color(0xff32343E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (selectedPaymentMethod.value?['id'] == '1')
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        // Add a check icon for visual confirmation
                        const SizedBox(height: 24),
                        Image.asset(
                          ImageAsset.remove,
                          height: 128,
                        ),
                        const SizedBox(height: 64),

                        const Text(
                          'Your order has been confirmed by PNJ.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        // Button to go to Order Tracking
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffE03137),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handlePayment(double total, double coupon) async {
    String? paymentIntent =
        await StripeService.instance.makePayment(total - coupon);

    if (paymentIntent != null) {
      try {
        await Stripe.instance.presentPaymentSheet();
        saveOrder();
        List<Map<String, dynamic>> selectedProducts =
            controller.ordersList.map((item) {
          return {
            'idProduct': item['idProduct'],
            'size': item['size'],
          };
        }).toList();
        controllerHome.removeMultipleFromShoppingCart(selectedProducts);
        showPaymentMethod(context, selectedPaymentMethod);
      } catch (e) {
        if (e is StripeException) {
          print("Lỗi Stripe: ${e.error.localizedMessage}");
          _showPaymentMethodFail(context, selectedPaymentMethod);
        } else {
          print("Lỗi không xác định: $e");
        }
        // TODO: Xử lý lỗi khi thanh toán thất bại, hiển thị thông báo cho người dùng
      }
    } else {
      print("Không thể khởi tạo thanh toán!");
      _showPaymentMethodFail(context, selectedPaymentMethod);
    }
  }
}
