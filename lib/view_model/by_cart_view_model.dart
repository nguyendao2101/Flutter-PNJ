import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ByCartViewModel extends GetxController {
  //firebase realtime
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  //firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Map<String, dynamic>> coupons = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> ordersList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> addressList = <Map<String, dynamic>>[].obs;
  final RxList<int> selectedItems = <int>[].obs; // Danh sách index của các sản phẩm được chọn
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> favorite = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> addCalendarAllEvents =
      <Map<String, dynamic>>[].obs;

  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
    listenToOrders();
    fetchCoupons();
    fetchStores();
    fetchLocationsFromFirebase();
    fetchProducts();
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

  // Hàm lấy danh sách cửa hàng
  Future<void> fetchStores() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('stores').get();
      final fetchedStores = snapshot.docs
          .map((doc) => {
        'id': doc.id, // Lưu storeId
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();

      // In ra các cửa hàng đã lấy được
      print('Stores fetched:');
      fetchedStores.forEach((store) {
        print('Store ID: ${store['id']}, Store Data: $store');
      });

      // Gán danh sách cửa hàng vào biến stores
      stores.assignAll(fetchedStores);
    } catch (e) {
      print('Error fetching stores: $e');
    }
  }


  // hàm lấy danh sách coupon
  Future<void> fetchCoupons() async {
    try {
      print('Fetching coupons...');
      final QuerySnapshot snapshot = await _firestore.collection('Coupons').get();
      print('Raw snapshot data: ${snapshot.docs}');

      final fetchedCoupons = snapshot.docs.map((doc) {
        print('Document ID: ${doc.id}, Data: ${doc.data()}');
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      coupons.assignAll(fetchedCoupons); // Cập nhật danh sách coupon
      print('Fetched coupons: $fetchedCoupons');
      print('Fetched coupons2: $coupons');
    } catch (e) {
      print('Error fetching coupons: ${e.toString()}');
    }
  }


  void _initializeUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
    }
  }
  Future<Map<String, String>> listenToAddress() async {
    DatabaseReference addressRef =
    FirebaseDatabase.instance.ref('users/${userId.value}/addAddress');

    try {
      DatabaseEvent event = await addressRef.once();
      DataSnapshot snapshot = event.snapshot;

      print('🔥 Dữ liệu từ Firebase: ${snapshot.value}');

      if (snapshot.value == null) {
        return {}; // Trả về Map rỗng nếu không có dữ liệu
      }

      final dynamic rawData = snapshot.value;
      Map<String, String> addressMap = {};

      if (rawData is List) {
        // Trường hợp dữ liệu là List
        for (int i = 0; i < rawData.length; i++) {
          var item = rawData[i];
          if (item is Map) {
            String address = "${item['street'] ?? 'N/A'}, ${item['city'] ?? 'N/A'}, ${item['country'] ?? 'N/A'}";
            addressMap[i.toString()] = address;
          }
        }
      } else if (rawData is Map) {
        // Trường hợp dữ liệu là Map
        rawData.forEach((key, value) {
          if (value is Map) {
            String address = "${value['street'] ?? 'N/A'}, ${value['city'] ?? 'N/A'}, ${value['country'] ?? 'N/A'}";
            addressMap[key] = address;
          }
        });
      }

      print("✅ Danh sách địa chỉ: $addressMap");
      return addressMap;
    } catch (e) {
      print("❌ Lỗi khi lấy dữ liệu từ Firebase: $e");
      return {};
    }
  }

  Future<void> listenToOrders() async {
    DatabaseReference officialRidersRef =
    _databaseReference.child('users/${userId.value}/shoppingCart');

    officialRidersRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      print('🔥 Kiểu dữ liệu của shoppingCart: ${snapshot.value.runtimeType}');

      if (snapshot.value == null) {
        ordersList.clear();
        print("⚠️ shoppingCart không tồn tại hoặc trống!");
        return;
      }

      try {
        final dynamic rawData = snapshot.value;

        if (rawData is List) {
          // Chuyển từng phần tử của List thành Map<String, dynamic>
          ordersList.clear();
          for (var item in rawData) {
            if (item is Map) {
              ordersList.add({
                'id': item['id'] ?? 'N/A',
                'idProduct': item['idProduct'] ?? 'N/A',
                'size': item['size'] ?? 'N/A',
                'stock': item['stock'] ?? 'N/A',
              });
            } else {
              print("⚠️ Dữ liệu không hợp lệ trong danh sách: $item");
            }
          }
          print("✅ Updated ordersList: $ordersList");
        } else {
          throw Exception("❌ shoppingCart không phải là một danh sách hợp lệ!");
        }
      } catch (e) {
        ordersList.clear();
        print("❌ Lỗi khi xử lý shoppingCart: $e");
      }
    });
  }


// lấy thông tin order
//   Future<void> listenToOrders() async {
//     if (userId.isEmpty) return;
//
//     await Future.delayed(Duration(milliseconds: 500)); // Giả lập độ trễ
//
//     _databaseReference.child('users/${userId.value}/shoppingCart').onValue.listen((event) {
//       print("🔥 Firebase shoppingCart event triggered!"); // Kiểm tra sự kiện
//
//       if (!event.snapshot.exists || event.snapshot.value == null) {
//         ordersList.clear();
//         print("⚠️ shoppingCart không tồn tại hoặc trống!");
//         return;
//       }
//
//       try {
//         final dynamic rawData = event.snapshot.value;
//         print("📦 Raw shoppingCart data: $rawData");
//
//         if (rawData is Map<Object?, Object?>) {
//           final List<Map<String, dynamic>> data = rawData.values.map((item) {
//             if (item is Map<Object?, Object?>) {
//               return Map<String, dynamic>.from(item);
//             } else {
//               throw Exception("Dữ liệu không hợp lệ: $item");
//             }
//           }).toList();
//
//           ordersList.value = data;
//           print("✅ Updated ordersList: ${ordersList.value}");
//         } else {
//           throw Exception("shoppingCart không phải là một Map hợp lệ!");
//         }
//       } catch (e) {
//         ordersList.clear();
//         print("❌ Lỗi khi xử lý shoppingCart: $e");
//       }
//     });
//   }




  //xoa thong tin gio hang
  void deleteOrder({required String itemId}) async {
    if (userId.isEmpty) return;

    final shoppingCartRef = _databaseReference.child('users/${userId.value}/ShoppingCart');

    try {
      final snapshot = await shoppingCartRef.get();

      // In dữ liệu lấy được từ Firebase
      print('Shopping cart snapshot: ${snapshot.value}');

      // Kiểm tra xem có dữ liệu hay không
      if (!snapshot.exists || snapshot.value == null) {
        print('Shopping cart is empty or data is null.');
        return;
      }

      // Kiểm tra kiểu dữ liệu của snapshot.value
      if (snapshot.value is List) {
        List<dynamic> cartItems = List<dynamic>.from(snapshot.value as List);
        print('Shopping cart data is a list.');

        bool itemFound = false;

        // Duyệt qua từng item trong shopping cart
        for (var cartItem in cartItems) {
          if (cartItem is String) {
            // Chuyển chuỗi JSON thành Map
            Map<String, dynamic> cartItemMap = jsonDecode(cartItem);

            print('Checking item: ${cartItemMap['id']} against itemId: $itemId');

            // So sánh với itemId sau khi loại bỏ dấu cách
            if (cartItemMap['id'].toString().trim() == itemId.trim()) {
              // Xóa sản phẩm có id trùng
              await shoppingCartRef.child(cartItemMap['id']).remove();
              itemFound = true;
              print('Item with ID $itemId has been removed successfully.');
              break; // Thoát vòng lặp khi đã xóa xong
            }
          }
        }

        if (!itemFound) {
          print('Item with ID $itemId not found in shopping cart.');
        }
      } else {
        print('Shopping cart data is not in the expected format (List).');
      }
    } catch (error) {
      print('Failed to remove item with ID $itemId: $error');
    }
  }




  //
  Future<Map<String, String>> fetchLocationsFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;
      DataSnapshot snapshot = await _databaseReference.child('users/$userId/AddAdress').get();

      if (snapshot.exists && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.map((key, value) => MapEntry(key.toString(), value.toString()));
      } else {
        debugPrint("No valid data found for locations.");
      }
    } catch (e) {
      debugPrint("Error fetching locations: $e");
    }
    return {}; // Trả về Map rỗng khi không có dữ liệu
  }


  void selectItem(int index) {
    selectedItems.add(index); // Thêm sản phẩm vào danh sách đã chọn
  }

  void deselectItem(int index) {
    selectedItems.remove(index); // Loại sản phẩm khỏi danh sách đã chọn
  }

  void toggleItemSelection(int index) {
    if (selectedItems.contains(index)) {
      deselectItem(index);
    } else {
      selectItem(index);
    }
  }

  void increaseQuantity(int index) {
    ordersList[index]['Quantity'] = (ordersList[index]['Quantity'] ?? 1) + 1;
    ordersList.refresh();
  }

  void decreaseQuantity(int index) {
    if (ordersList[index]['Quantity'] > 1) {
      ordersList[index]['Quantity'] -= 1;
      ordersList.refresh();
    }
  }

  List<Map<String, dynamic>> checkoutSelectedItems() {
    print('Selected items indexes: $selectedItems');

    List<Map<String, dynamic>> selectedProducts = [];

    for (int i = 0; i < selectedItems.length; i++) {
      int originalIndex = selectedItems[i];

      if (originalIndex >= 0 && originalIndex < ordersList.length) {
        print('Selected product at index: $originalIndex -> ${ordersList[originalIndex]}');

        final product = Map<String, dynamic>.from(ordersList[originalIndex]); // Tạo bản sao sản phẩm
        product['Quantity'] = ordersList[originalIndex]['Quantity'] ?? 1;
        product['originalIndex'] = originalIndex; // Lưu lại index gốc

        selectedProducts.add(product);
      }
    }

    print('Danh sách sản phẩm đã chọn: $selectedProducts');
    return selectedProducts;
  }



  double calculateTotal(List<Map<String, dynamic>> product) {
    double total = 0.0;
    for (var item in product) {
      // total += item['Price']*item['Quantity']; // Cộng dồn giá của mỗi sản phẩm
        total += item['price']*item['quantity'];
    }
    return total;
  }

}
