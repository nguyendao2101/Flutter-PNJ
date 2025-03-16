import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/get_data_view_model.dart';
import 'package:flutter_pnj/view_model/home_view_model.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/common_widget/product_card/product_card_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final controller = Get.put(HomeViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _advertisement = [];
  bool _isLoadingAdvertisement = true;
  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = true;
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();

    print("✅ HomeView initState()");

    _searchController = TextEditingController();
    print("✅ _searchController đã được khởi tạo!");

    _searchController.addListener(() {
      print("📌 Đã gọi _filterProducts()");
      _filterProducts();
    });

    _loadAdvertisement();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    print("🔄 Đang tải danh sách sản phẩm...");
    await controllerGetData.fetchProducts();

    setState(() {
      _products = controllerGetData.products;
      _isLoadingProducts = false;
      print("✅ Đã tải sản phẩm (${_products.length} sản phẩm)");

      for (var product in _products) {
        print("📦 Sản phẩm: ${product['nameProduct']} - Hình ảnh: ${product['productImg'][0]}");
      }
    });
  }

  void _filterProducts() {
    try {
      String query = _searchController.text.toLowerCase();
      print("🔍 Tìm kiếm với từ khóa: '$query'");

      setState(() {
        _filteredProducts = _products.where((product) {
          String productName = product['nameProduct'].toString().toLowerCase();
          bool isVisible = product['show'] == 'true';
          bool matchesQuery = productName.contains(query);

          print("📢 Kiểm tra sản phẩm: $productName - show: $isVisible - match: $matchesQuery");

          return matchesQuery && isVisible;
        }).toList();

        print("=== Danh sách sản phẩm sau khi lọc ===");
        if (_filteredProducts.isEmpty) {
          print("⚠️ Không có sản phẩm phù hợp với tìm kiếm: '$query'");
        } else {
          for (var product in _filteredProducts) {
            print("✔ ${product['nameProduct']}");
          }
        }
      });
    } catch (e, stack) {
      print("❌ Lỗi trong _filterProducts(): $e");
      print(stack);
    }
  }

  Future<void> _loadAdvertisement() async {
    print("🔄 Đang tải quảng cáo...");
    await controllerGetData.fetchAdvertisement();

    setState(() {
      _advertisement = controllerGetData.advertisement;
      _isLoadingAdvertisement = false;
      print("✅ Đã tải quảng cáo (${_advertisement.length} quảng cáo)");
    });
  }

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
                controller: _searchController,
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
                onChanged: (value) {
                  print("✍ Nhập vào: $value");
                  _filterProducts();
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          /// Danh sách sản phẩm
          if (_searchController.text.isNotEmpty)
            Positioned(
              top: 0, // Điều chỉnh vị trí dựa vào chiều cao của slider
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white, // Đặt màu nền trắng cho danh sách
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: _isLoadingProducts
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredProducts.isEmpty
                    ? const Center(child: Text('Không có sản phẩm phù hợp'))
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ProductCardListView(product: product),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

}
