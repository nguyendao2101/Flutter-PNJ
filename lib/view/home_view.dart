import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/get_data_view_model.dart';
import 'package:flutter_pnj/view_model/home_view_model.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/common_widget/button/bassic_button_inter.dart';
import '../widgets/common_widget/footer/footer_view.dart';
import '../widgets/common_widget/product_card/product_card_list_view.dart';
import '../widgets/common_widget/type_product/type_product.dart';

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

  List<Map<String, dynamic>> _advertisement = [];
  bool _isLoadingAdvertisement = true;
  List<Map<String, dynamic>> _products= [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadAdvertisement();
    // _loadAdminTitle();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await controllerGetData.fetchProducts();
    setState(() {
      _products = controllerGetData.products;
      _isLoadingProducts = false;
      for(var product in _products){
        print('Name product: ${product['productImg'][0]}');
      }
    });
  }

  // Future<void> _loadAdminTitle() async {
  //   await controllerGetData.fetchAdminTitle();
  //   setState(() {
  //     _adminTitle = controllerGetData.adminTitle;
  //     _isLoadingAdminTitle = false;
  //   });
  // }


  Future<void> _loadAdvertisement() async {
    await controllerGetData.fetchAdvertisement();
    setState(() {
      _advertisement = controllerGetData.advertisement;
      _isLoadingAdvertisement = false;
    });
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

    List<String> titleImageJewelry = ['Nhẫn','Dây Chuyền','Vòng - Lắc','Bông Tai'];
    List<String> titleImageJewelryMarry = ['Nhẫn Cầu Hôn','Nhân Cưới','Nhẫn Cặp','Kiềng'];
    List<String> imageJewelry = [
      ImageAsset.homeNhan,
      ImageAsset.homeDayChuyen,
      ImageAsset.homeVongLac,
      ImageAsset.homeBongTai,
    ];
    List<String> imageJewelryMarry = [
      ImageAsset.homeNhanCauHon,
      ImageAsset.homeNhanCuoi,
      ImageAsset.homeNhanCap,
      ImageAsset.homeKieng,
    ];
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
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            SizedBox(
              height: 220, // Chiều cao tổng
              child: Stack(
                alignment: Alignment.bottomCenter, // Căn chấm xuống dưới ảnh
                children: [
                  _isLoadingAdvertisement ? const Center(child: CircularProgressIndicator())
                      : _advertisement.isNotEmpty
                      ? CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 4),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemCount: _advertisement.length,
                    itemBuilder: (context, index, realIndex) {
                      final imageUrl = _advertisement[index]['urlImage'] ?? '';

                      return ClipRRect(
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const Center(child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2))), // Hiển thị khi đang tải ảnh
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                height: 200,
                                child: const Center(child: Icon(Icons.broken_image, size: 40)),
                              ),
                            )
                            : Container(
                          color: Colors.grey[300],
                          height: 200,
                          child: const Center(child: Icon(Icons.broken_image, size: 40)),
                        ),
                      );
                    },
                  ) : const Center(child: Text("Không có dữ liệu")),
                  Positioned(
                    bottom: 10, // Khoảng cách từ đáy ảnh
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: _advertisement.length,
                      effect: WormEffect(
                        dotWidth: 8,
                        dotHeight: 8,
                        spacing: 5,
                        activeDotColor: Colors.white, // Màu chấm nổi bật
                        dotColor: Colors.white.withOpacity(0.5), // Màu chấm nhạt
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _siboxTitle('Trang Sức',140),
            const SizedBox(height: 20),
            SizedBox(
              height: 220, // Chiều cao của danh sách ảnh
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Vuốt ngang
                itemCount: imageJewelry.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      if(titleImageJewelry[index] == 'Vòng - Lắc'){
                        Get.to(() => TypeProduct(typeProduct: 'Vòng lắc', productDetail: _products,));
                      }
                      if(titleImageJewelry[index] == 'Nhẫn'){
                        Get.to(() => TypeProduct(typeProduct: 'Nhẫn', productDetail: _products,));
                      }
                      if(titleImageJewelry[index] == 'Dây Chuyền'){
                        Get.to(() => TypeProduct(typeProduct: 'Dây chuyền', productDetail: _products,));
                      }
                      if(titleImageJewelry[index] == 'Bông Tai'){
                        Get.to(() => TypeProduct(typeProduct: 'Bông tai', productDetail: _products,));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imageJewelry[index],
                              width: 163, // Độ rộng ảnh
                              height: 167, // Chiều cao ảnh
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 150,
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.broken_image, size: 40)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12,),
                          Text(titleImageJewelry[index],style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xff131118),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,),)
                        ],
                      ),
                    ),
                  );
                },
              ),),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: BassicButtonInter(onPressed: () {},
                title: 'TOP BÁN CHẠY', sizeTitle: 12,fontW: FontWeight.w700,colorButton: const Color(0xffAC3843),
                height: 44, radius: 5,
              ),
            ),
            const SizedBox(height: 20),
            _siboxTitle('Trang Sức Cưới',200),
            const SizedBox(height: 20),
            SizedBox(
              height: 220, // Chiều cao của danh sách ảnh
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Vuốt ngang
                itemCount: imageJewelryMarry.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      // 'Nhẫn Cầu Hôn','Nhân Cưới','Nhẫn Cặp','Kiềng'
                      if(titleImageJewelryMarry[index] == 'Nhẫn Cầu Hôn'){
                        Get.to(() => TypeProduct(typeProduct: 'Nhẫn Cầu hôn', productDetail: _products,));
                      }
                      if(titleImageJewelryMarry[index] == 'Nhân Cưới'){
                        Get.to(() => TypeProduct(typeProduct: 'Nhẫn cưới', productDetail: _products,));
                      }
                      if(titleImageJewelryMarry[index] == 'Nhẫn Cặp'){
                        Get.to(() => TypeProduct(typeProduct: 'Nhẫn cặp', productDetail: _products,));
                      }
                      if(titleImageJewelryMarry[index] == 'Kiềng'){
                        Get.to(() => TypeProduct(typeProduct: 'Kiềng', productDetail: _products,));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imageJewelryMarry[index],
                              width: 163, // Độ rộng ảnh
                              height: 167, // Chiều cao ảnh
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 150,
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.broken_image, size: 40)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12,),
                          Text(titleImageJewelryMarry[index],style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xff131118),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,),)
                        ],
                      ),
                    ),
                  );
                },
              ),),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: BassicButtonInter(onPressed: () {},
                title: 'TOP BÁN CHẠY', sizeTitle: 12,fontW: FontWeight.w700,colorButton: const Color(0xffAC3843),
                height: 44, radius: 5,
              ),
            ),
            const SizedBox(height: 40),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Get.to(()=> TypeProduct(typeProduct: 'Nhẫn', productDetail: _products,));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _titleSeeMore('Nhẫn'),
              ),
            ),
            _cardProduct('Nhẫn'),
            // GestureDetector(
            //   onTap: (){
            //     Get.to(()=> TypeProduct(typeProduct: 'Dây chuyền', productDetail: _products,));
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: _titleSeeMore('Dây Chuyền'),
            //   ),
            // ),
            // _cardProduct('Dây chuyền'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Get.to(()=> TypeProduct(typeProduct: 'Vòng lắc', productDetail: _products,));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _titleSeeMore('Vòng - lắc'),
              ),
            ),
            _cardProduct('Vòng lắc'),
            // GestureDetector(
            //   onTap: (){
            //     Get.to(()=> TypeProduct(typeProduct: 'Bông tai', productDetail: _products,));
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: _titleSeeMore('Bông Tai'),
            //   ),
            // ),
            // _cardProduct('Bông tai'),
            // GestureDetector(
            //   onTap: (){
            //     Get.to(()=> TypeProduct(typeProduct: 'Nhẫn Cầu hôn', productDetail: _products,));
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: _titleSeeMore('Nhẫn cầu hôn'),
            //   ),
            // ),
            // _cardProduct('Nhẫn Cầu hôn'),
            GestureDetector(
              onTap: (){
                Get.to(()=> TypeProduct(typeProduct: 'Nhẫn cưới', productDetail: _products,));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _titleSeeMore('Nhẫn Cưới'),
              ),
            ),
            _cardProduct('Nhẫn cưới'),
            // GestureDetector(
            //   onTap: (){
            //     Get.to(()=> TypeProduct(typeProduct: 'Nhẫn cặp', productDetail: _products,));
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: _titleSeeMore('Nhẫn Cặp'),
            //   ),
            // ),
            // _cardProduct('Nhẫn cặp'),
            // GestureDetector(
            //   onTap: (){
            //     Get.to(()=> TypeProduct(typeProduct: 'Kiềng', productDetail: _products,));
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: _titleSeeMore('Kiềng'),
            //   ),
            // ),
            // _cardProduct('Kiềng'),
            const SizedBox(height: 40),
            const FooterView(),
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

  Column _titleSeeMore(String text){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(
              fontSize: 24,
              color: Color(0xff131118),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,),),
            const Text('Xem Thêm', style: TextStyle(
              fontSize: 14,
              color: Color(0xff131118),
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,),),
          ],
        ),
        const SizedBox(height: 12,),
      ],
    );
  }

  SizedBox _cardProduct(String type,){
    return SizedBox(
      height: 320,
      child: _isLoadingProducts
          ? const Center(child: CircularProgressIndicator())
          : Builder(
        builder: (context) {
          // Lọc sản phẩm có type = 'Nhẫn' và show = true
          List filteredProducts = _products
              .where((product) => product['type'] == type && product['show'] == 'true')
              .toList();

          // Giới hạn tối đa 10 sản phẩm
          List displayProducts = filteredProducts.length > 10
              ? filteredProducts.sublist(0, 10)
              : filteredProducts;

          return displayProducts.isEmpty
              ? const Center(child: Text('Không có sản phẩm phù hợp'))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayProducts.length,
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ProductCardListView(product: product),
              );
            },
          );
        },
      ),
    );
  }
}
