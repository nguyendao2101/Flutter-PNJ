import 'package:flutter/material.dart';
import 'package:flutter_pnj/widgets/common_widget/button/bassic_button.dart';
import 'package:intl/intl.dart';
import '../../app_bar/list_product_app_bar.dart';
import '../product_card/product_card_grid_view.dart';

class TypeProduct extends StatefulWidget {
  final List<Map<String, dynamic>> productDetail;
  final String typeProduct;

  const TypeProduct({super.key, required this.typeProduct, required this.productDetail});

  @override
  _TypeProductState createState() => _TypeProductState();
}

class _TypeProductState extends State<TypeProduct> {
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 50000000;
  final double _maxPriceDefault = 50000000;
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredProducts();
  }

  void _updateFilteredProducts() {
    setState(() {
      filteredProducts = widget.productDetail
          .where((product) {
        int price = product['sizePrice'][0]['price'] ?? 0;
        return product['type'] == widget.typeProduct &&
            product['show'] == 'true' &&
            price >= _selectedMinPrice &&
            price <= _selectedMaxPrice;
      })
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
      filteredProducts = widget.productDetail.where((product) {
      int price = product['sizePrice'][0]['price'] ?? 0;
      return product['type'] == widget.typeProduct &&
          product['show'] == 'true' &&
          price >= _selectedMinPrice &&
          price <= _selectedMaxPrice;
    }).toList();
      final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");


    return Scaffold(
      appBar: ListProductAppBar(
        context: context,
        title: widget.typeProduct,
      ),
      body: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterBottomSheet(context, currencyFormat);
            },
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Không có sản phẩm phù hợp'))
                : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.54,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCardGridView(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context,NumberFormat currencyFormat) {
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
                      const Text(
                        "Filter",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed:(){
                          Navigator.pop(context);
                      },
                      ),

                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Price", style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff131118),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,),),
                      Text("${currencyFormat.format(tempMinPrice.toInt())} - ${currencyFormat.format(tempMaxPrice.toInt())} đ",style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xff131118),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,),),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(tempMinPrice, tempMaxPrice),
                    min: 0,
                    max: _maxPriceDefault,
                    divisions: 100,
                    labels: RangeLabels(
                      "${tempMinPrice.toInt()} VND",
                      "${tempMaxPrice.toInt()} VND",
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
                  BasicAppButton(onPressed: (){
                    setState(() {
                      _selectedMinPrice = tempMinPrice;
                      _selectedMaxPrice = tempMaxPrice;
                    });
                    print("Min: $_selectedMinPrice, Max: $_selectedMaxPrice");
                    _updateFilteredProducts();
                    Navigator.pop(context);
                    setState(() {});
                  }, title: 'Apply', sizeTitle: 14, colorButton: const Color(0xffAC3843), radius: 20, height: 44,),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
