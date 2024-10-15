import 'package:flutter/material.dart';

import '../constants/color.dart';

class PersonnelInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const PersonnelInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style:
                      const TextStyle(fontFamily: popinsSemiBold, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style:
                      const TextStyle(fontFamily: popinsSemiBold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
