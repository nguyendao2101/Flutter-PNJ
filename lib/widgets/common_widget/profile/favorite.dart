import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/favorite_view_model.dart';
import '../../../view_model/get_data_view_model.dart';
import '../../app_bar/personal_apbar.dart';
import '../product_card/product_detail.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final controller = Get.put(FavoriteViewModel());
  final controllerGetData = Get.put(GetDataViewModel());

  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    controller.favouriteCart();
    _loadProducts();

    // Lắng nghe sự thay đổi của danh sách yêu thích
    ever(controller.favouriteCart, (_) => _loadProducts());
  }

  Future<void> _loadProducts() async {
    await controllerGetData.fetchProducts();

    setState(() {
      _filteredProducts = controllerGetData.products.where((product) {
        return controller.favouriteCart.contains(product['id']) &&
            product['show'] == 'true';
      }).toList();

      _isLoadingProducts = false;
    });

    // Debug: In danh sách sản phẩm đã lọc
    print("🔎 Danh sách sản phẩm yêu thích:");
    for (var product in _filteredProducts) {
      print('✅ ${product['name']} - ID: ${product['id']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarProfile(title: 'Favorite Products'),
      body: _isLoadingProducts
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading
          : _filteredProducts.isEmpty
          ? Center(child: Text("Không có sản phẩm yêu thích."))
          : ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          var product = _filteredProducts[index];
          return Dismissible(
            key: Key(product['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.redAccent,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              // controllerHome.removeFromShoppingCart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item ${product['nameProduct']} removed')),
              );
            },
            child: GestureDetector(
              onTap: (){
                Get.to(() => ProductDetail(productDetail: product,));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3,child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),bottomLeft:  Radius.circular(12))
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                        CachedNetworkImage(
                          imageUrl: product['productImg']?.isNotEmpty == true ? product['productImg'].first : 'https://storage.googleapis.com/duan-4904c.appspot.com/flutter_pnj/Trang%20s%E1%BB%A9c/B%C3%B4ng%20tai/11/gbxmxmy004922-bong-tai-vang-18k-dinh-da-cz-pnj-02.png?GoogleAccessId=firebase-adminsdk-v1s7v%40duan-4904c.iam.gserviceaccount.com&Expires=1893430800&Signature=skId0uhYKxXlF16CKqXnBKGrw21ZI9onCODbveScBugPGiXRFSWXQXdq4AUIKUUbwNFl6h1MMi0fz39PdfGTbH98Oe6MzJLMqPqNDawu5MYAgFqgQPZEzdx7zd9%2FAFaD8CED6mulA1I7lUNZ8CLNHSTrCI%2FcNUf7dylYLjyMQMcdK1wjeTszuja4VXfzSEfak9eLHRgIi%2FZ7adaZayWF6uux2aO75ek2753rCB77Y9PrBCO6c30bu4Wzo6U%2B73AdvCsNmYBv1xu3fhtmUBS0v%2B8RYdSAcOtfzmgoDGzrUpvP%2BovkSnHCkKuQA6KT%2BP6YOblMiK7EIDAgrXnfz21JTw%3D%3D',
                          height: 80,
                          width: 110,
                          placeholder: (context, url) => const SizedBox(
                              height: 24,
                              width: 24,
                              child: const CircularProgressIndicator(strokeWidth: 2)), // Hiển thị khi tải
                          errorWidget: (context, url, error) => const Icon(Icons.error), // Hiển thị khi lỗi
                          fit: BoxFit.cover, // Căn chỉnh hình ảnh
                        ),
                      ),
                    )),
                    Expanded(flex: 5,child: Container(
                      height: 150,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['nameProduct'] ?? 'Không có tiêu đề',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff32343E),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${product['sizePrice'][0]['price']} đ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffA02334),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
