import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';

Widget buildTextField({
    required String label,
    required TextEditingController controller,
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 6,
        shadowColor: primaryColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
        child: TextFormField(
          cursorColor: primaryColor,
          controller: controller,
          onTap: onTap,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontFamily: popinsRegulr),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(
                color: Colors.grey.shade600, fontFamily: popinsSemiBold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
