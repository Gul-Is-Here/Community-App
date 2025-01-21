import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Globals {
  var userId = ''.obs;
  var accessToken = ''.obs;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
}

final globals = Globals();
