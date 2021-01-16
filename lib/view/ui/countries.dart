import 'package:flutter/material.dart';
import 'package:movie_viewer_db/util/util.dart';

class Countries extends StatelessWidget {
  final List<dynamic> countries;

  const Countries(this.countries);

  Widget buildItem(int index) {
    return Chip(
      backgroundColor: Colors.grey.withOpacity(0.03),
      avatar: Text(Util.countryCodeToFlag(countries[index]['iso_3166_1']),
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
      label: Text(countries[index]['name'],
          style: TextStyle(
            fontSize: 18,
            color: const Color(0xFF1E88E5),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: new List.generate(
        countries.length,
        (index) => buildItem(index),
      ),
    );
  }
}
