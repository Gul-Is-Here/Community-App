
import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';

class FeatureWidgeticons extends StatelessWidget {
  final  String icons;
   void Function()  onTap;
    FeatureWidgeticons({ required this.icons, required this.onTap,
    
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: lightColor,
          ),
          child: IconButton(
              onPressed: onTap, icon: Image.asset(icons))),
    );
  }
}
