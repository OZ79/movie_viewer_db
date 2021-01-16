import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config.dart';

class Companies extends StatelessWidget {
  final List<dynamic> companies;

  const Companies(this.companies);

  Widget buildItem(int index) {
    final logoUrl = '$IMAGE_URL_92${companies[index]['logo_path']}';

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey.withOpacity(0.1),
      child: Image.network(logoUrl, width: 40, height: 40, fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    companies.removeWhere((element) => element['logo_path'] == null);

    return Wrap(
      spacing: 40,
      children: List.generate(
        companies.length,
        (index) => buildItem(index),
      ),
    );
  }
}
