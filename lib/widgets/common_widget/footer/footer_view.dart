import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/get_data_view_model.dart';
import '../../common/image_extention.dart';

class FooterView extends StatefulWidget {
  const FooterView({super.key});

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> {
  final controllerGetData = Get.put(GetDataViewModel());
  List<Map<String, dynamic>> _adminTitle = [];
  bool _isLoadingAdminTitle = true;

  @override
  void initState() {
    super.initState();
    _loadAdminTitle();
  }

  Future<void> _loadAdminTitle() async {
    await controllerGetData.fetchAdminTitle();
    setState(() {
      _adminTitle = controllerGetData.adminTitle;
      _isLoadingAdminTitle = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoadingAdminTitle) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_adminTitle.isEmpty) {
      return const Center(child: Text("Không có dữ liệu"));
    }

    // Lấy phần tử đầu tiên sau khi chắc chắn danh sách không rỗng
    Map<String, dynamic> adminTitle = _adminTitle.first;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(ImageAsset.columnLogoApp),
            ],
          ),
          const SizedBox(height: 8),
          _title(adminTitle['address'] ?? ""),
          _title('ĐT: ${adminTitle['numberPhone'] ?? ""} - Fax: ${adminTitle['fax'] ?? ""}'),
          _title(adminTitle['business'] ?? ""),
          const SizedBox(height: 20),
          _title('Tổng đài hỗ trợ (08:00-21:00, miễn phí gọi)'),
          _title('Gọi mua: ${adminTitle['buy'] ?? ""} (phím 1)'),
          _title('Khiếu nại: ${adminTitle['complaint'] ?? ""} (phím 2)'),
          const SizedBox(height: 20),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'VỀ PNJ\nDỊCH VỤ KHÁCH HÀNG\nTỔNG HỢP CÁC CHÍNH SÁCH PNJ',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff131118),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          const Text(
            'KẾT NỐI VỚI CHÚNG TÔI',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff131118),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(ImageAsset.social),
          const SizedBox(height: 24),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          _title('   © 2017 Công Ty Cổ Phần Vàng Bạc Đá Quý Phú Nhuận'),
          const SizedBox(height: 10),
          Image.asset(ImageAsset.pay),
        ],
      ),
    );
  }

  Text _title(String text){
    return Text(text, style: const TextStyle(
      fontSize: 9,
      color: Color(0xff131118),
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,),);
  }
}
