import 'package:flutter/material.dart';

class AdvertisementAdmin extends StatefulWidget {
  final Map<String, dynamic> adminTitle;
  const AdvertisementAdmin({super.key, required this.adminTitle});

  @override
  State<AdvertisementAdmin> createState() => _AdvertisementAdminState();
}

class _AdvertisementAdminState extends State<AdvertisementAdmin> {
  List<String> getImageUrls() {
    // Lấy advertisement và lọc các URL ảnh hợp lệ
    Map<String, dynamic> advertisement = widget.adminTitle['advertisement'] ?? {};

    // Chỉ lấy các giá trị là URL (string) và có dạng link ảnh
    List<String> imageUrls = advertisement.values
        .where((value) => value is String && value.toString().startsWith('http'))
        .cast<String>()
        .toList();

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = getImageUrls();

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network('https://firebasestorage.googleapis.com/v0/b/duan-4904c.appspot.com/o/flutter_pnj%2FImage%20Home%2FImage%20Qu%E1%BA%A3ng%20c%C3%A1o%2FQuangCao.png?alt=media&token=5ec61593-ff84-4ef7-b7b5-f7506012f188',height: 200,),
          // ListView(
          //   children: imageUrls.map((url) {
          //     print('link anh $url');
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 8.0),
          //       child: Image.network(
          //         url,
          //         fit: BoxFit.cover,
          //         errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          //       ),
          //     );
          //   }).toList(),
          // )
        ],
      ),
    );
  }
}
