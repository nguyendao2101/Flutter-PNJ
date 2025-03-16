import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../view_model/get_data_view_model.dart';
import '../../app_bar/list_product_app_bar.dart';
import '../product_card/product_card_grid_view.dart';

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
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 50000000;
  final double _maxPriceDefault = 50000000;

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
      _filterProducts();
    });
  }

  Future<void> _loadCollectionProducts() async {
    await controllerGetData.fetchCollectionProduct();
    setState(() {
      _collectionproducts = controllerGetData.collection;
      _isLoadingCollectionProducts = false;
      _filterProducts();
    });
  }

  void _filterProducts() {
    if (_products.isEmpty || _collectionproducts.isEmpty) return;

    var selectedCollection = _collectionproducts.firstWhere(
          (collection) => collection['id'] == widget.idCollection,
      orElse: () => {},
    );

    if (selectedCollection.isNotEmpty && selectedCollection['listProduct'] != null) {
      List<String> listProductIds = List<String>.from(selectedCollection['listProduct']);

      setState(() {
        _filteredProducts = _products.where((product) {
          int price = product['sizePrice'][0]['price'] ?? 0;
          return listProductIds.contains(product['id']) &&
              price >= _selectedMinPrice &&
              price <= _selectedMaxPrice;
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

  void _showFilterBottomSheet(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        double tempMinPrice = _selectedMinPrice;
        double tempMaxPrice = _selectedMaxPrice;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Price", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text("${currencyFormat.format(tempMinPrice.toInt())} - ${currencyFormat.format(tempMaxPrice.toInt())} đ",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(tempMinPrice, tempMaxPrice),
                    min: 0,
                    max: _maxPriceDefault,
                    divisions: 100,
                    labels: RangeLabels(
                      "${currencyFormat.format(tempMinPrice.toInt())} đ",
                      "${currencyFormat.format(tempMaxPrice.toInt())} đ",
                    ),
                    activeColor: Colors.red,
                    onChanged: (RangeValues values) {
                      setState(() {
                        tempMinPrice = values.start;
                        tempMaxPrice = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedMinPrice = tempMinPrice;
                        _selectedMaxPrice = tempMaxPrice;
                      });
                      _filterProducts();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ListProductAppBar(context: context, title: getCollectionName(),),
      body: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          Expanded(
            child: _isLoadingProducts || _isLoadingCollectionProducts
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
          ),
        ],
      ),
    );
  }
}
