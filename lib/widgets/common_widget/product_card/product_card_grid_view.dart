import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/login_view.dart';
import 'package:flutter_pnj/widgets/common_widget/product_card/product_detail.dart';
import 'package:flutter_pnj/widgets/common_widget/rating/product_rating_display.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../view_model/home_view_model.dart';
import '../rating/product_rating_detail.dart';

class ProductCardGridView extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCardGridView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCardGridView> createState() => _ProductCardGridViewState();
}

class _ProductCardGridViewState extends State<ProductCardGridView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeViewModel());
    final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              productDetail: widget.product,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12, // Màu bóng
                blurRadius: 4, // Độ mờ của bóng
                spreadRadius: 0, // Độ lan rộng của bóng
                offset: Offset(0, 3), // Dịch chuyển bóng xuống dưới
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.product['productImg'][0] ?? '',
                        height: 170,
                        width: 201,
                        placeholder: (context, url) => const SizedBox(
                            height: 24,
                            width: 24,
                            child: const CircularProgressIndicator(strokeWidth: 2)), // Hiển thị khi tải
                        errorWidget: (context, url, error) => const Icon(Icons.error), // Hiển thị khi lỗi
                        fit: BoxFit.fill, // Căn chỉnh hình ảnh
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleFavorite(widget.product);
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
                                controller.isFavorite(widget.product)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: controller.isFavorite(widget.product)
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['nameProduct'] ?? 'No data',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff131118),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          ' ${currencyFormat.format((widget.product['sizePrice'][0]['price']) * 1.2)} đ ',
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
                        const SizedBox(width: 8),
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
                    const SizedBox(height: 4),
                    Text(
                      '${currencyFormat.format((widget.product['sizePrice'][0]['price']))} đ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff131118),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ProductRatingDetail(rating: 4.2,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
