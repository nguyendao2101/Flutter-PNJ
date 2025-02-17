import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/load_image_panner_view.dart';
import 'package:flutter_pnj/view/login_view.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void loadView() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(() => const LoadImagePannerView());
  }
}
