import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/login_view.dart';
import 'package:flutter_pnj/view_model/splash_view_model.dart';
import 'package:get/get.dart';

import '../widgets/common/image_extention.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final controller =  Get.put(SplashViewModel());

  @override
  void initState() {
    super.initState();
    controller.loadView();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(ImageAsset.loadLogoApp, height: 480, width: 339,),
      ),
    );
  }
}
