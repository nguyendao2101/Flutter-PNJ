import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/widgets/common/image_extention.dart';
import 'package:flutter_pnj/widgets/common_widget/rating/product_rating_detail.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../view_model/evalua_product_view_model.dart';
import '../../../view_model/home_view_model.dart';
import '../../app_bar/detai_product_app_bar.dart';
import '../button/bassic_button_inter.dart';
import '../evalua_product/comment_evalua.dart';

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> productDetail;
  const ProductDetail({super.key, required this.productDetail});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<String> imageUrls = [];
  int selectedImageIndex = 0;

  List<Map<String, dynamic>> sizePriceList = [];
  int selectedSizeIndex = 0;
  bool isShowingDescription = true;
  final controller = Get.put(HomeViewModel());
  final controllerEva = Get.put(EvaluaProductViewModel());
  TextEditingController _commentUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    var productImgData = widget.productDetail['productImg'];

    // Kiểm tra dữ liệu có tồn tại không
    if (productImgData != null && productImgData is List) {
      imageUrls = List<String>.from(productImgData);
    }
    var rawData = widget.productDetail['sizePrice'] as List<dynamic>?;
    if (rawData != null) {
      sizePriceList = rawData.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");

    return Scaffold(
      appBar: DetaiProductAppBar(context: context,),
      body: imageUrls.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Nếu không có ảnh, hiển thị loading
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.3),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imageUrls[selectedImageIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth; // Lấy chiều rộng màn hình
                  double totalImageWidth = (80 * imageUrls.length) + (10 * (imageUrls.length - 1)); // Tổng chiều rộng ảnh

                  return Align(
                    alignment: totalImageWidth < screenWidth ? Alignment.center : Alignment.centerLeft, // Căn giữa nếu ảnh chưa đủ
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImageIndex = index; // Cập nhật ảnh lớn
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedImageIndex == index ? const Color(0xffAC3843) : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageUrls[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.productDetail['nameProduct'] ?? 'No data',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff131118),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProductRatingDetail(rating: 4.2,),
            ),
            const SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${currencyFormat.format(sizePriceList[selectedSizeIndex]['price'])} VNĐ",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff131118),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                  ),
                  const SizedBox(width: 12,),
                  Text(
                    " ${currencyFormat.format(sizePriceList[selectedSizeIndex]['price']*1.2)} VNĐ ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.grey,
                      decorationThickness: 1.5,
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '-20%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '(Giá sản phẩm thay đổi tùy trọng lượng vàng và đá)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff131118),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '*Vui lòng chọn size',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff131118),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sizePriceList.length,
                  itemBuilder: (context, index) {
                    bool isOutOfStock = sizePriceList[index]['stock'] == 0;
                    bool isSelected = selectedSizeIndex == index;

                    return GestureDetector(
                      onTap: () {
                        if (!isOutOfStock) {
                          setState(() {
                            selectedSizeIndex = index;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? Colors.grey.shade200
                              : (isSelected ? const Color(0xffAC3843) : Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            "${sizePriceList[index]['size']}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isOutOfStock ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '*Nhấn để được tư vấn',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff131118),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: (){},
                      child: Image.asset(ImageAsset.zalo)),
                  const SizedBox(width: 12,),
                  GestureDetector(
                      onTap: (){},
                      child: Image.asset(ImageAsset.callPhoneNumber)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20,left: 60),
                  child: BassicButtonInter(onPressed: () {
                    controller.addToShoppingCart(widget.productDetail,sizePriceList[selectedSizeIndex]['size']);
                  },
                    title: 'Thêm vào giỏ hàng', sizeTitle: 14, height: 44, fontW: FontWeight.w500,
                    colorButton: const Color(0xffAC3843), radius: 10,),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleFavorite(widget.productDetail);
                    },
                    child: Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Màu nền xám nhạt
                          shape: BoxShape.circle,  // Hình tròn
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2), // Đổ bóng nhẹ
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6), // Khoảng cách bên trong
                        child: Icon(
                          controller.isFavorite(widget.productDetail)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.isFavorite(widget.productDetail)
                              ? Colors.red
                              : Colors.grey,
                          size: 24, // Kích thước icon
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                _buildToggleButton("Mô tả sản phẩm", true),
                const SizedBox(width: 10),
                _buildToggleButton("Bình luận", false),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),

            // Hiển thị nội dung tùy theo trạng thái
            isShowingDescription ? _buildProductDescription()
                : EvaluationScreen(product: widget.productDetail,),
            const SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isDescription) {
    bool isSelected = isShowingDescription == isDescription;
    return GestureDetector(
      onTap: () {
        setState(() {
          isShowingDescription = isDescription;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5, // Chiếm nửa màn hình
        // padding: const EdgeInsets.symmetric(vertical: 12), // Căn giữa chiều dọc
        alignment: Alignment.center, // Căn giữa chữ
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontFamily: 'Inter',
                fontWeight: isSelected ? FontWeight.w500 :  FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8,),
            Container(
              height: 4,
              color: isSelected ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }


  Widget _buildProductDescription() {
    return Text(
      widget.productDetail['description'],
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xff131118),
        fontFamily: 'Inter',
        fontWeight: FontWeight.w200,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildCommentsSection() {
    return const Text(
      "Đây là phần bình luận...",
      style: TextStyle(fontSize: 16),
    );
  }

}
