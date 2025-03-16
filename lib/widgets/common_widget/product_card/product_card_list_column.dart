import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view/login_view.dart';
import 'package:flutter_pnj/widgets/common_widget/product_card/product_detail.dart';
import 'package:flutter_pnj/widgets/common_widget/rating/product_rating_display.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../view_model/home_view_model.dart';

class ProductCardListColumn extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCardListColumn({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCardListColumn> createState() => _ProductCardListColumnState();
}

class _ProductCardListColumnState extends State<ProductCardListColumn> {
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
                  imageUrl: widget.product['productImg']?.isNotEmpty == true ? widget.product['productImg'].first : 'https://storage.googleapis.com/duan-4904c.appspot.com/flutter_pnj/Trang%20s%E1%BB%A9c/B%C3%B4ng%20tai/11/gbxmxmy004922-bong-tai-vang-18k-dinh-da-cz-pnj-02.png?GoogleAccessId=firebase-adminsdk-v1s7v%40duan-4904c.iam.gserviceaccount.com&Expires=1893430800&Signature=skId0uhYKxXlF16CKqXnBKGrw21ZI9onCODbveScBugPGiXRFSWXQXdq4AUIKUUbwNFl6h1MMi0fz39PdfGTbH98Oe6MzJLMqPqNDawu5MYAgFqgQPZEzdx7zd9%2FAFaD8CED6mulA1I7lUNZ8CLNHSTrCI%2FcNUf7dylYLjyMQMcdK1wjeTszuja4VXfzSEfak9eLHRgIi%2FZ7adaZayWF6uux2aO75ek2753rCB77Y9PrBCO6c30bu4Wzo6U%2B73AdvCsNmYBv1xu3fhtmUBS0v%2B8RYdSAcOtfzmgoDGzrUpvP%2BovkSnHCkKuQA6KT%2BP6YOblMiK7EIDAgrXnfz21JTw%3D%3D',
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
                      widget.product['nameProduct'] ?? 'Không có tiêu đề',
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
                          '${widget.product['sizePrice'][0]['price']} đ',
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
    );
  }
}
