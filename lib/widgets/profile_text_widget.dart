import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';

Widget buildTextField({
  required String label,
  required TextEditingController controller,
  void Function()? onTap,
}) {
  return Container(
    // color: primaryColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 6,
        color: primaryColor.withOpacity(.4),
        shadowColor: primaryColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
        child: TextFormField(
          cursorColor: primaryColor,
          controller: controller,
          onTap: onTap,
          style: const TextStyle(
              color: Color(0xFF0E8041), fontSize: 13, fontFamily: popinsRegulr),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: lightColor,
            labelStyle: TextStyle(
                color: Color(0xFF0E8041),
                fontFamily: popinsRegulr,
                fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ),
  );
}
