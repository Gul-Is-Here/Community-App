import 'package:flutter/material.dart';

import '../constants/color.dart';

Widget buildJummaTile(String title, String time, IconData icon) {
  return Expanded(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal.shade50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          // contentPadding: const EdgeInsets.all(4),
          title: Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(
              fontSize: 13,
              fontFamily: popinsSemiBold,
              color: primaryColor,
            ),
          ),
          subtitle: Text(
            textAlign: TextAlign.center,
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: popinsRegulr,
            ),
          ),
          leading: Icon(icon, color: primaryColor, size: 30),
        ),
      ),
    ),
  );
}
