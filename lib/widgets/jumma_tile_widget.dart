import 'package:flutter/material.dart';

import '../constants/color.dart';

Widget buildJummaTile(String title, String time, IconData icon) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.teal.shade50,
    child: ListTile(
      contentPadding: const EdgeInsets.all(4),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontFamily: popinsSemiBold,
          color: primaryColor,
        ),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontFamily: popinsRegulr,
        ),
      ),
      leading: Icon(icon, color: Colors.teal, size: 30),
    ),
  );
}
