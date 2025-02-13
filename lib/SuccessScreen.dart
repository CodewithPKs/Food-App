import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class SuccessScreen extends StatefulWidget {
final String ordrID;

SuccessScreen({ required this.ordrID});
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  bool _showOrderInfo = false;
  bool _moveToTop = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _moveToTop = true;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _showOrderInfo = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
     // backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _moveToTop ? 60 : MediaQuery.of(context).size.height / 2 - 100,
            left: screenWidth / 2.5 - 100,
            child: Lottie.asset(
              'assets/success.json',
              width: 300,
              height: 300,
              repeat: true,
            ),
          ),

          if (_showOrderInfo)
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Order Placed Successfully!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Order ID: ${widget.ordrID}",
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                    SizedBox(height: 50,),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        "Order Details",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
