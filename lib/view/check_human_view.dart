import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/main_nav_view.dart';
import 'package:get/get.dart';

import '../widgets/common/image_extention.dart';


class ConfirmHumanView extends StatefulWidget {
  const ConfirmHumanView({super.key});

  @override
  State<ConfirmHumanView> createState() => _ConfirmHumanViewState();
}

class _ConfirmHumanViewState extends State<ConfirmHumanView> {
  bool isHuman = false;

  void navigatorAccessLocation() {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => const MainNavView(initialIndex: 0,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            ImageAsset.loadLogoApp,
            height: 256,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.5, // Tăng kích thước Checkbox
                    child: Checkbox(
                      value: isHuman,
                      activeColor: const Color(0xffC62300),
                      onChanged: (value) {
                        if (value == true) {
                          navigatorAccessLocation(); // Chờ 1 giây rồi chuyển màn hình
                        }
                        setState(() {
                          isHuman = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                      width: 12), // Khoảng cách giữa Checkbox và Text
                  const Text(
                    "I'm not a Robot",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff32343E),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
