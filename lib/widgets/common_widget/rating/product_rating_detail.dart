import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingDetail extends StatelessWidget {
  final double rating;

  ProductRatingDetail({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: rating, // Điểm đánh giá
          itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
          itemCount: 5, // Tổng số sao
          itemSize: 16.0, // Kích thước sao
          direction: Axis.horizontal,
        ),
        const SizedBox(width: 8),
        Text('$rating/5', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
