import 'package:flutter/material.dart';

class ProductCardGridView extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCardGridView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('product card grid view'),
      ),
    );
  }
}
