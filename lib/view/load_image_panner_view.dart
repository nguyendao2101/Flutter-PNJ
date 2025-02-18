// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/common/image_extention.dart';
import '../widgets/common_widget/button/bassic_button.dart';
import 'login_view.dart';

class LoadImagePannerView extends StatefulWidget {
  const LoadImagePannerView({super.key});

  @override
  _LoadImagePannerViewState createState() => _LoadImagePannerViewState();
}

class _LoadImagePannerViewState extends State<LoadImagePannerView> {
  // Khai báo PageController riêng cho từng PageView
  final PageController _pageController1 = PageController();
  final PageController _pageController2 = PageController();
  final PageController _pageController3 = PageController();


  @override
  void dispose() {
    // Giải phóng tài nguyên của các controller khi widget bị hủy
    _pageController1.dispose();
    _pageController2.dispose();
    _pageController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagesPanner = [
      ImageAsset.banner1,
      ImageAsset.banner2,
      ImageAsset.banner3,
    ];
    List<String> imagesLocationPanner = [
      ImageAsset.circle1,
      ImageAsset.circle2,
      ImageAsset.circle3,
    ];
    List<String> tiltlePanner = [
      'Choose Products',
      'Make Payment',
      'Get Your Order'
    ];

    return Scaffold(
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                Get.to(() => const LoginView());
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Skip',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          automaticallyImplyLeading: false),
      body: Stack(
        children: [
          // 1. PageView cho imagesPanner
          Positioned(
            top: 20, // Đặt cách trên cùng 20px
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.4, // Chiếm 40% chiều cao
              child: PageView.builder(
                controller: _pageController1,
                itemCount: imagesPanner.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      imagesPanner[index],
                      height: 480, // Chiều cao của hình ảnh
                      width: 339, // Để ảnh rộng ra hết chiều ngang màn hình
                    ),
                  );
                },
                onPageChanged: (index) {
                  // Khi trang của PageView 1 thay đổi, thay đổi luôn trang của PageView 2 và 3
                  _pageController2.jumpToPage(index);
                  _pageController3.jumpToPage(index);
                },
              ),
            ),
          ),

          // 2. PageView cho tiêu đề (titlePanner)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4 +
                40, // Đặt cách dưới PageView đầu tiên
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.2, // Chiếm 20% chiều cao
              child: PageView.builder(
                controller: _pageController3,
                itemCount: tiltlePanner.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      tiltlePanner[index],
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Jost'),
                    ),
                  );
                },
                onPageChanged: (index) {
                  // Khi trang của PageView 3 thay đổi, thay đổi luôn trang của PageView 1 và 2
                  _pageController2.jumpToPage(index);
                  _pageController1.jumpToPage(index);
                },
              ),
            ),
          ),

          // 3. Đoạn text miêu tả
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.5, // Vị trí của đoạn văn bản
            left: 0,
            right: 0,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffA8A8A9),
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // 4. PageView cho imagesLocationPanner
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.86, // Đặt cách dưới text description
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.3, // Chiếm 30% chiều cao
              child: PageView.builder(
                controller: _pageController2,
                itemCount: imagesLocationPanner.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      imagesLocationPanner[index],
                      height: 10, // Điều chỉnh chiều cao cho hình ảnh
                      width: 80, // Để ảnh rộng ra hết chiều ngang màn hình
                    ),
                  );
                },
                onPageChanged: (index) {
                  // Khi trang của PageView 2 thay đổi, thay đổi luôn trang của PageView 1 và 3
                  _pageController1.jumpToPage(index);
                  _pageController3.jumpToPage(index);
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.84,
            right: 16,
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  int currentPage = _pageController1.page?.toInt() ?? 0;
                  if (currentPage < imagesPanner.length - 1) {
                    setState(() { // Cập nhật UI
                      _pageController1.jumpToPage(currentPage + 1);
                      _pageController2.jumpToPage(currentPage + 1);
                      _pageController3.jumpToPage(currentPage + 1);
                    });
                  } else {
                    Get.to(() => const LoginView());
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff6D2323),
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
