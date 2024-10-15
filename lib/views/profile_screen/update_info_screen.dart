import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Profile"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          
          },
          child: Text('Edit Profile'),
        ),
      ),
    );
  }
}
