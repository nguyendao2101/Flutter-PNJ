import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/firebase/firebase_authencation.dart';

class ProfileViewModel extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final _userData = {}.obs;
  String _userId = '';
  RxMap get userData => _userData;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _getUserData();
    }
  }

  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$_userId');
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      _userData.value = Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      _userData.value = {};
    }
  }

  Future<void> transferUserDataToBrowseShop() async {
    // Lấy thông tin người dùng từ nhánh 'users/$_userId'
    DatabaseReference userRef = _database.child('users/$_userId');
    DataSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Lấy dữ liệu từ userSnapshot
      Map<String, dynamic> userData =
      Map<String, dynamic>.from(userSnapshot.value as Map);

      // Lưu thông tin vào nhánh 'browseShop/$_userId'
      DatabaseReference browseShopRef = _database.child('browseShop/$_userId');
      await browseShopRef.set(userData); // Lưu dữ liệu vào 'browseShop'

      print("User data transferred to browseShop.");
    } else {
      print("No user data found to transfer.");
    }
  }

  void onLogout() {
    FirAuth firAuth = FirAuth(); // Tạo một thể hiện của FirAuth
    firAuth.signOut(); // Gọi phương thức signOut từ thể hiện
  }
}
