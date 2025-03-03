import 'package:flutter/material.dart';

import '../../app_bar/list_product_app_bar.dart';
import '../product_card/product_card_grid_view.dart';
import '../product_card/product_card_list_view.dart';

class TypeProduct extends StatelessWidget {
  final List<Map<String, dynamic>> productDetail;
  final String typeProduct;
  const TypeProduct({super.key, required this.typeProduct, required this.productDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ListProductAppBar(
        context: context,
        title: typeProduct,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(
          builder: (context) {
            // Lọc sản phẩm có type = typeProduct và show = true
            List filteredProducts = productDetail
                .where((product) => product['type'] == typeProduct && product['show'] == 'true')
                .toList();
            return filteredProducts.isEmpty
                ? const Center(child: Text('Không có sản phẩm phù hợp'))
                : Expanded(
                  child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số cột là 2
                  crossAxisSpacing: 8.0, // Khoảng cách giữa các cột
                  mainAxisSpacing: 16.0, // Khoảng cách giữa các hàng
                  childAspectRatio: 0.54, // Tỷ lệ chiều rộng / chiều cao
                                ),
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCardGridView(product: product);
                                },
                              ),
                );
          },
        ),
      ),
    );
  }
}
