import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../service/cart_service.dart';

class PaymentAppCard extends StatelessWidget {

  final VoidCallback onTap;
  final PaymentApp app;
  final bool isSelected;

  const PaymentAppCard({
    super.key,
    required this.onTap,
    required this.app,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 50 - 20) / 3,
        height: MediaQuery.of(context).size.height * 0.075,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
            color: isSelected ? KrishiColors.primary.withOpacity(0.35) : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.fromBorderSide(
                BorderSide(
                    color: isSelected ? KrishiColors.primary : Colors.grey.shade400,
                    width: 1
                )
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  foregroundImage: AssetImage(getPaymentAppIcon()),
                ),

                const SizedBox(width: 10),

                Flexible(
                  child: Text(
                    getPaymentAppName(),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),

            // if (isAvailable != null)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 10),
            //     child: Text(
            //       'Currently not available..!!',
            //       style: TextStyle(
            //         fontSize: 9,
            //         color: Colors.red
            //       ),
            //     ),
            //   )

          ],
        ),
      ),
    );
  }

  String getPaymentAppName() {
    switch (app) {
      case PaymentApp.googlePay: return 'Google Pay';

      case PaymentApp.phonePe: return 'PhonePe';

      case PaymentApp.paytm: return 'Paytm';

      default: return 'Other';
    }
  }

  String getPaymentAppIcon() {
    switch (app) {
      case PaymentApp.googlePay: return 'assets/icons/google-pay.png';

      case PaymentApp.phonePe: return 'assets/icons/phonepe.png';

      case PaymentApp.paytm: return 'assets/icons/paytm.png';

      default: return 'Other';
    }
  }
}