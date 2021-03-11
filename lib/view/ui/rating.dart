import 'package:flutter/material.dart';
import 'package:movie_viewer_db/view/ui/star_rating.dart';

class Rating extends StatelessWidget {
  final double rating;

  const Rating(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      StarRating(
        rating: rating * 0.5,
        size: 20,
        color: Colors.yellow.shade700,
        borderColor: Colors.yellow.shade700,
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        rating.toString(),
        style: TextStyle(fontSize: 16, color: const Color(0xFF1E88E5)),
      )
    ]);
  }
}
