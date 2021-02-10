import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final Color borderColor;
  final double size;
  final MainAxisAlignment mainAxisAlignment;

  const StarRating({
    this.starCount = 5,
    this.rating = .0,
    this.color,
    this.borderColor,
    this.size,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  Widget _buildStar(int index) {
    Icon icon;

    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: borderColor,
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: size,
      );
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: mainAxisAlignment,
      children: new List.generate(
        starCount,
        (index) => _buildStar(index),
      ),
    );
  }
}
