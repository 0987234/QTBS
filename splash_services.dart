import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/UI/module/Student/student%20registration/login.dart';
import 'package:test_project/posts/post_Screen.dart';

class SplashServices {
  final String selectRoute;

  SplashServices({required this.selectRoute});
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => postscreen())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen(
                        selectRoute: '',
                        fee: '',
                        bus: '',
                      ))));
    }
  }
}
