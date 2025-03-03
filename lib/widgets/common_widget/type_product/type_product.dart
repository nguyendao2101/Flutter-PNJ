import 'package:flutter/material.dart';

class TypeProduct extends StatelessWidget {
  final String typeProduct;
  const TypeProduct({super.key, required this.typeProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(typeProduct),
      ),
    );
  }
}
