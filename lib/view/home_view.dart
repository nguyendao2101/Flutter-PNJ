import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/get_data_view_model.dart';
import 'package:flutter_pnj/view_model/home_view_model.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../widgets/common_widget/footer/footer_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final controller = Get.put(HomeViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  // List<Map<String, dynamic>> _adminTitle = [];
  // bool _isLoadingAdminTitle = true;

  @override
  void initState() {
    super.initState();
  }


  // // Hàm lấy tất cả URL ảnh từ adminTitle
  // List<String> getAllImageUrls() {
  //   List<String> imageUrls = [];
  //
  //   for (var adminTitle in _adminTitle) {
  //     imageUrls.addAll((adminTitle['advertisement'] ?? {})
  //         .values
  //         .where((value) => value is String && value.toString().startsWith('http'))
  //         .cast<String>());
  //   }
  //
  //   return imageUrls;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(ImageAsset.loadLogoApp, height: 26),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 28),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SvgPicture.asset(ImageAsset.filter, color: Colors.black,height: 24,),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('HOME'),
            FooterView()
          ],
        ),
      ),
    );
  }

  SizedBox _siboxTitle(String text, double width){
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(text, style: const TextStyle(
            fontSize: 24,
            color: Color(0xff131118),
            fontFamily: 'Prata',
            fontWeight: FontWeight.w400,),),
          const SizedBox(height: 6,),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
