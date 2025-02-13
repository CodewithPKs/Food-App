import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class EmptyCartCard extends StatelessWidget {
  const EmptyCartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const Spacer(
          flex: 2,
        ),

        // Empty Cart Image
        SizedBox(
          // height: 275,
          // width: 300,
          child: Center(
            child: Lottie.asset(
              'assets/empitycart.json',
              fit: BoxFit.cover,
              height: 275,
              width: 300,
            ),
          ),
        ),


        SizedBox(height: 16,),
        // No Order Placed Yet
        Text(
          'Your Cart is Empty',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        // Place Your First Order
        // Text(
        //   'Add the ',
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.black.withOpacity(0.6),
        //   ),
        // ),

        Spacer(flex: 4,)


      ],
    );
  }

}
