import 'package:flutter/material.dart';

class ProductCardListColumn extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCardListColumn({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('product card list view column'),
      ),
    );
  }
}
