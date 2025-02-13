import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class QuantityButtonCard extends StatelessWidget {

  final VoidCallback onQuantityDecrease;
  final VoidCallback onQuantityIncrease;
  final String quantity;
  final double? betweenGap;

  const QuantityButtonCard({super.key, required this.onQuantityDecrease, required this.onQuantityIncrease, required this.quantity, this.betweenGap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius
              .circular(8),
          // border: Border.fromBorderSide(
          //     BorderSide(
          //         color: Colors.black
          //     )
          // )
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [

            // Quantity Decrease Button
            _customQuantityButton(
              onTap: onQuantityDecrease,
              icon: Icons.remove,
              color: Colors.orange,
            ),

            SizedBox(width: betweenGap ?? 20),

            // Item Quantity
            Text(
                quantity,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall!.copyWith(color: Colors.white, fontSize: 18)
            ),

            SizedBox(width: betweenGap ?? 20),

            // Quantity Increase Button
            _customQuantityButton(
              onTap: onQuantityIncrease,
              icon: Icons.add,
              color: KrishiColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customQuantityButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.fromBorderSide(
                BorderSide(
                    color: Colors.white24,
                    width: 1.5
                )
            )
        ),
        child: Icon(
          icon,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
