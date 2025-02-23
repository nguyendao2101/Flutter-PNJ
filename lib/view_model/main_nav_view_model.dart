import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavViewModel extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  // Quản lý chỉ số của tab được chọn
  RxInt selectedTab = 0.obs;

  // GlobalKey cho Scaffold (để hiển thị Snackbar, Drawer, v.v.)

  // Cập nhật tab được chọn
  void updateSelectedTab(int index) {
    selectedTab.value = index;
  }

  // Xử lý mở Drawer (nếu cần)
  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }
}
