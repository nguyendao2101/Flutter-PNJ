import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/get_data_view_model.dart';
import '../../app_bar/list_product_app_bar.dart';
import '../product_card/product_card_grid_view.dart';
import '../product_card/product_card_list_view.dart';

class CollectionProduct extends StatefulWidget {
  final String idCollection;
  const CollectionProduct({super.key, required this.idCollection,});

  @override
  State<CollectionProduct> createState() => _CollectionProductState();
}

class _CollectionProductState extends State<CollectionProduct> {
  final controllerGetData = Get.put(GetDataViewModel());
  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = true;

  List<Map<String, dynamic>> _collectionproducts = [];
  bool _isLoadingCollectionProducts = true;

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCollectionProducts();
  }

  Future<void> _loadProducts() async {
    await controllerGetData.fetchProducts();
    setState(() {
      _products = controllerGetData.products;
      _isLoadingProducts = false;
      _filterProducts(); // Lọc sản phẩm ngay khi có dữ liệu
    });
  }

  Future<void> _loadCollectionProducts() async {
    await controllerGetData.fetchCollectionProduct();
    setState(() {
      _collectionproducts = controllerGetData.collection;
      _isLoadingCollectionProducts = false;
      _filterProducts(); // Lọc sản phẩm khi có dữ liệu collection
    });
  }

  void _filterProducts() {
    if (_products.isEmpty || _collectionproducts.isEmpty) return;

    // Tìm collection phù hợp với idCollection
    var selectedCollection = _collectionproducts.firstWhere(
          (collection) => collection['id'] == widget.idCollection,
      orElse: () => {},
    );

    if (selectedCollection.isNotEmpty && selectedCollection['listProduct'] != null) {
      List<String> listProductIds = List<String>.from(selectedCollection['listProduct']);

      setState(() {
        _filteredProducts = _products.where((product) {
          return listProductIds.contains(product['id']);
        }).toList();
      });
    }
  }

  String getCollectionName() {
    if (_collectionproducts.isEmpty) return "Không tìm thấy BST";

    var selectedCollection = _collectionproducts.firstWhere(
          (collection) => collection['id'] == widget.idCollection,
      orElse: () => {},
    );

    return selectedCollection.isNotEmpty ? selectedCollection['name'] : "Không tìm thấy BST";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ListProductAppBar(context: context, title: getCollectionName(),),
      body: _isLoadingProducts || _isLoadingCollectionProducts
          ? const Center(child: CircularProgressIndicator())
          : _filteredProducts.isEmpty
          ? const Center(child: Text("Không có sản phẩm nào"))
          : GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.54,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ProductCardGridView(product: product);
            },
      ),
    );
  }
}

