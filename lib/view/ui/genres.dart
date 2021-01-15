import 'package:flutter/material.dart';

class Genres extends StatelessWidget {
  final List<dynamic> genres;

  const Genres(this.genres);

  Widget buildItem(int index) {
    return Chip(
      backgroundColor: Colors.grey.withOpacity(0.03),
      label: Text(genres[index]['name'],
          style: TextStyle(
            fontSize: 21,
            color: const Color(0xFF1E88E5),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      children: new List.generate(
        genres.length,
        (index) => buildItem(index),
      ),
    );
  }
}
