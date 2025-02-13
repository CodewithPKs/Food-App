import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderProcessingDialog extends StatelessWidget {
  const OrderProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {

    log('Order Processing Dialog....');

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0
          )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black,
              )
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SpinKitFadingCircle(
                    color: Colors.white,
                    size: 26,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Processing your order...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

showOrderProcessingDialog({
  required BuildContext context,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const OrderProcessingDialog();
    }
  );
}