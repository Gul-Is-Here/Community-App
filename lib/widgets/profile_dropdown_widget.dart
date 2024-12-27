import 'package:flutter/material.dart';

import '../constants/color.dart';

Widget buildDropdownField({
  required String label,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: lightColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelStyle: TextStyle(color: Color(0xFF0F7A3F)),
      ),
      child: SizedBox(
        height: 20,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            onChanged: onChanged,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontFamily: popinsSemiBold, fontSize: 13),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}
