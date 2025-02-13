import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';

class AppExitAlertDialog extends StatelessWidget {
  const AppExitAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Exit App',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Lottie.asset("assets/exit.json", height: MediaQuery.sizeOf(context).height * .04),
        ],
      ),
      content: Text(
        'Confirm',
      ),
      actions: <Widget>[
        SizedBox(
          width: MediaQuery.sizeOf(context).width * .18,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            style: ButtonStyle(
              backgroundColor:
              WidgetStateProperty.all<Color>(Colors.red),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Same value as AlertDialog
                ),
              ),
            ),
            child: Text(
              'Exit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * .2,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(KrishiColors.primary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: Text(
               'Cancle',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
