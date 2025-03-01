import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingDisplay extends StatelessWidget {
  final double rating; // Điểm đánh giá trung bình
  final int totalReviews; // Tổng số lượt đánh giá

  ProductRatingDisplay({required this.rating, required this.totalReviews});

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
        SizedBox(width: 8),
        Text('($totalReviews đánh giá)', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
