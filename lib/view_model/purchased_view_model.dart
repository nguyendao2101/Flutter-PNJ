import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class PurchasedViewModel extends GetxController {
  final RxString userId = ''.obs;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  var purchasedCart = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  void _initializeUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
      fetchFurchasedCart(); // Gọi fetch khi userId đã có
    }
  }

  void fetchFurchasedCart() {
    if (userId.value.isEmpty) return; // Tránh gọi khi chưa có userId

    DatabaseReference officialRidersRef =
    _databaseReference.child('users/${userId.value}/purchasedCart');

    officialRidersRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        purchasedCart.clear();
        print("⚠️ purchasedCart không có dữ liệu hoặc rỗng.");
        return;
      }

      var data = event.snapshot.value;
      print("🔥 Dữ liệu từ Firebase: $data");

      if (data is List) {
        purchasedCart.assignAll(data.map((e) => e.toString()).toList());
      } else if (data is Map) {
        purchasedCart.assignAll(data.values.map((e) => e.toString()).toList());
      } else {
        print("⚠️ Dữ liệu không hợp lệ: $data");
      }

      print("✅ Danh sách favoriteCart đã cập nhật: $purchasedCart");
    }, onError: (error) {
      print("❌ Lỗi khi lấy dữ liệu từ Firebase: $error");
    });
  }

}
