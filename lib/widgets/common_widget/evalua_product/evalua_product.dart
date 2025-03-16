import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/by_cart_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../view_model/evalua_product_view_model.dart';
import '../../../view_model/profile_view_model.dart';
import '../../app_bar/personal_apbar.dart';

class EvaluaProduct extends StatefulWidget {
  final Map<String, dynamic> product;
  const EvaluaProduct({super.key, required this.product});

  @override
  State<EvaluaProduct> createState() => _EvaluaProductState();
}

class _EvaluaProductState extends State<EvaluaProduct> {
  final controllerId = Get.put(ByCartViewModel());
  final controller = Get.put(EvaluaProductViewModel());
  final controllerPro = Get.put(ProfileViewModel());

  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  final NumberFormat currencyFormat = NumberFormat("#,###", "vi_VN");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarProfile(title: 'Evaluate'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hiển thị sản phẩm
            Container(
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
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.product['productImg'][0],
                          height: 80,
                          width: 110,
                          placeholder: (context, url) => const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 130,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product['nameProduct'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff1C1B1F),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${currencyFormat.format(widget.product['sizePrice'][0]['price'])} đ',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xffA02334),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Đánh giá sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rate this Product:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Write a Comment:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xffA02334)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_commentController.text.isNotEmpty &&
                              _rating > 0) {
                            try {
                              await controller.addOrderToFirestore(
                                content: _commentController.text,
                                emailUser: controllerId.userId.toString(),
                                star: _rating,
                                idProduct: widget.product['id'],
                                idUser: controllerId.userId.toString(),
                                nameProduct: widget.product['nameProduct'],
                                nameUser:
                                controllerPro.userData['fullName'] ?? 'User',
                              );

                              setState(() {
                                _rating = 0.0;
                                _commentController.clear();
                              });

                              Get.back();
                              Get.snackbar(
                                'Success',
                                'You have successfully rated',
                                snackPosition: SnackPosition.TOP,
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to submit rating: $e',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please provide a rating and a comment',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffA02334),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Evaluate',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
