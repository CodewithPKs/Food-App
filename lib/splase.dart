import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Login/Controller/AuthController.dart';
import 'Login/Screen/LoginScreen.dart';
import 'bottom_nav_bar/krishi_bottom_nav_bar.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLogin();
  }

  Future<void> _checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    await Future.delayed(Duration(seconds: 2));

    if (userId != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KrishiBottomNavBar()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.orange,)),
    );
  }
}
