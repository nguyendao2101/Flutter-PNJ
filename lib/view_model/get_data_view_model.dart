// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetDataViewModel extends GetxController {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Biến lưu trữ danh sách cửa hàng, sản phẩm và đơn hàng
  // final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> collection = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> adminTitle = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> advertisement = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> orderTracking = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // fetchStores(); // Lấy danh sách cửa hàng
    fetchOrderTracking();
    fetchProducts();
    fetchCollectionProduct();
  }

  // // Hàm lấy danh sách cửa hàng
  // Future<void> fetchStores() async {
  //   try {
  //     final QuerySnapshot snapshot =
  //     await _firestore.collection('stores').get();
  //     final fetchedStores = snapshot.docs
  //         .map((doc) => {
  //       'id': doc.id, // Lưu storeId
  //       ...doc.data() as Map<String, dynamic>,
  //     })
  //         .toList();
  //
  //     // In ra các cửa hàng đã lấy được
  //     print('Stores fetched:');
  //     fetchedStores.forEach((store) {
  //       print('Store ID: ${store['id']}, Store Data: $store');
  //     });
  //
  //     // Gán danh sách cửa hàng vào biến stores
  //     stores.assignAll(fetchedStores);
  //   } catch (e) {
  //     print('Error fetching stores: $e');
  //   }
  // }

  //Hàm lấy adminTitle
  Future<void> fetchAdminTitle() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('AdminTitle').get();

      final fetchedProducts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; // Tránh lỗi null
        return {
          'id': doc.id, // Lưu ID của document
          'acronym': data?['acronym'] ?? '',
          'address': data?['address'] ?? '',
          'business': data?['business'] ?? '',
          'buy': data?['buy'] ?? '',
          'complaint': data?['complaint'] ?? '',
          'fax': data?['fax'] ?? '',
          'nameShop': data?['nameShop'] ?? '',
          'numberPhone': data?['numberPhone'] ?? '',
        };
      }).toList();

      adminTitle.assignAll(fetchedProducts); // Cập nhật danh sách adminTitle
      print("🔥 AdminTitle List:");
      for (var admin in adminTitle) {
        print("📌 ID: ${admin['id']}");
        print("🏪 NameShop: ${admin['nameShop']}");
        print("📍 Address: ${admin['address']}");
        print("📞 Phone: ${admin['numberPhone']}");
        print("-------------------------");
      }
    } catch (e) {
      print('Error fetching AdminTitle: $e');
    }
  }


  // Hàm lấy Advertisement
  Future<void> fetchAdvertisement() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('Advertisement').get();
      final fetchedProducts = snapshot.docs
          .map((doc) => {
        'id': doc.id, // Lưu productId
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      advertisement.assignAll(fetchedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print('Error fetching AdminTitle: $e');
    }
  }

  // Hàm lấy danh sách bộ sưu tập sản phẩm
  Future<void> fetchCollectionProduct() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('CollectionProducts').get();
      final fetchedProducts = snapshot.docs
          .map((doc) => {
        'id': doc.id, // Lưu productId
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      collection.assignAll(fetchedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Hàm lấy danh sách sản phẩm
  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('Products').get();
      final fetchedProducts = snapshot.docs
          .map((doc) => {
        'id': doc.id, // Lưu productId
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      products.assignAll(fetchedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Hàm lấy danh sách sản phẩm
// Hàm lấy danh sách trạng thái đơn hàng
  Future<void> fetchOrderTracking() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('Orders').get();

      if (snapshot.docs.isEmpty) {
        print("No orders found in Firestore.");
        orderTracking.assignAll([]); // Gán danh sách rỗng nếu không có đơn hàng
        return;
      }

      final fetchedOrders = snapshot.docs.map((doc) {
        final orderData = doc.data() as Map<String, dynamic>;

        return {
          'orderId': doc.id, // Sử dụng Firestore document ID
          'addressUserGet': orderData['addressUserGet'],
          'couponDiscount': orderData['couponDiscount'],
          'couponId': orderData['couponId'],
          'emailUserGet': orderData['emailUserGet'],
          'idUserOrder': orderData['idUserOrder'],
          'nameUserGet': orderData['nameUserGet'],
          'phoneUserGet': orderData['phoneUserGet'],
          'productItems': orderData['productItems'],
          'status': orderData['status'],
          'timeOrder': orderData['timeOrder'],
          'totalAmount': orderData['totalAmount'],
          'typePayment': orderData['typePayment '],
        };
      }).toList();

      print("Fetched Order Tracking:");
      fetchedOrders.forEach((order) {
        print("Order ID: ${order['orderId']}, User ID: ${order['idUserOrder']}, Status: ${order['status']}");
      });

      orderTracking.assignAll(fetchedOrders);
    } catch (e) {
      print("Error fetching order tracking: $e");
    }
  }



  // Hàm lấy sản phẩm của cửa hàng cụ thể
  Future<void> fetchProductsByStore(String storeId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('storeId', isEqualTo: storeId) // Lọc theo storeId
          .get();
      final fetchedProducts = snapshot.docs
          .map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      products.assignAll(fetchedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print('Error fetching products by store: $e');
    }
  }

  // Hàm thêm đơn hàng mới cho một cửa hàng

  Future<void> addOrder(String storeId, String userId, List<String> productIds,
      List<int> quantities) async {
    try {
      // Tính tổng giá trị đơn hàng
      int totalAmount = 0;
      for (int i = 0; i < productIds.length; i++) {
        final product = products.firstWhere((p) => p['id'] == productIds[i]);
        totalAmount += (product['price'] as int) * quantities[i];
      }

      // Thêm đơn hàng vào Firestore
      final orderData = {
        'storeId': storeId, // Liên kết với cửa hàng
        'userId': userId,
        'productIds': productIds,
        'quantities': quantities,
        'totalAmount': totalAmount,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('orders').add(orderData);
      print('Đặt hàng thành công!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }
  //
  // Future<void> fetchStoresByProduct(String productId) async {
  //   try {
  //     final QuerySnapshot snapshot = await _firestore
  //         .collection('stores')
  //         .where('productIds',
  //         arrayContains: productId) // Tìm store có chứa productId
  //         .get();
  //     final fetchedStores = snapshot.docs
  //         .map((doc) => {
  //       'id': doc.id,
  //       ...doc.data() as Map<String, dynamic>,
  //     })
  //         .toList();
  //     stores.assignAll(fetchedStores); // Cập nhật danh sách cửa hàng
  //   } catch (e) {
  //     print('Error fetching stores by product: $e');
  //   }
  // }

  // Hàm lấy danh sách đơn hàng của một cửa hàng
  Future<void> fetchOrdersByStore(String storeId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId) // Lọc theo storeId
          .get();
      final fetchedOrders = snapshot.docs
          .map((doc) => {
        'id': doc.id, // Lưu orderId
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> addOrderToFirestore({
    required String addressUserGet,
    required double? couponDiscount,
    required String? couponId,
    required String emailUserGet,
    // required String id,
    required String idUserOrder,
    required String nameUserGet,
    // required String paymentId,
    required String phoneUserGet,
    required List<Map<dynamic, dynamic>> productItems,
    required String status,
    // required DateTime timeOrder,
    required double totalAmount,
    required String typePayment,
  }) async {
    try {
      // Lấy tham chiếu đến collection 'orders'
      final ordersCollection = FirebaseFirestore.instance.collection('Orders');

      // Tạo orderId bằng timestamp
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Dữ liệu đơn hàng với orderId
      final orderData = {
        "addressUserGet": addressUserGet,
        "couponDiscount": couponDiscount,
        "couponId": couponId,
        "emailUserGet": emailUserGet,
        "id": orderId,
        "idUserOrder": idUserOrder,
        "nameUserGet": nameUserGet,
        "phoneUserGet": phoneUserGet,
        "productItems": productItems,
        "status": status,
        "timeOrder": Timestamp.now(),
        "totalAmount": totalAmount,
        "typePayment ": typePayment,
      };

      // Lưu dữ liệu với orderId là ID của tài liệu
      await ordersCollection.doc(orderId).set(orderData);

      print('Order with ID $orderId added successfully!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

}
