import 'package:flutter/material.dart';

class ProductCardListColumn extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCardListColumn({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12, // Màu bóng
              blurRadius: 4, // Độ mờ của bóng
              spreadRadius: 0, // Độ lan rộng của bóng
              offset: Offset(0, 3), // Dịch chuyển bóng xuống dưới
            )
          ],
        ),

        child: Row(
          children: [
            Image.network(product['productImg'][0] ?? '',
              width: 120,
              height: 100,
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Expanded(
                  child: Text(product['nameProduct'] ?? 'No data',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff131118),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
