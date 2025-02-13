import 'package:flutter/material.dart';


import 'package:provider/provider.dart';


import '../controller/cart_provider.dart';
import 'delivery_time_card.dart';


class DeliveryDetailsCard extends StatelessWidget {

  final bool showDeliveryTime;

  const DeliveryDetailsCard({super.key, required this.showDeliveryTime});

  @override
  Widget build(BuildContext context) {

    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider provider, Widget? child) {

        String pincode = provider.userModel?.pincode ?? '';
        String address = provider.userModel?.address ?? '';
        String city = provider.userModel?.city ?? '';

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.white24,
              width: 0.5
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Delivery Details Heading
              // Text(
              //   '${AppLocalizations.of(context)?.Delivery_Details ?? ''} :',
              //   style: TextStyle(
              //     color: KrishiColors.primary,
              //     fontSize: 16 * screenWidth / 375,
              //     fontWeight: FontWeight.bold
              //   ),
              // ),
              //
              // SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [

                          // Deliver To
                          Text(
                            'Deliver To',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white
                            ),
                          ),

                          // Name and Pincode
                          Text(
                            "${provider.userModel?.name ?? 'Stephen J.'}${'89104'}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      // Address
                      Text(
                        '3351 Denali Preserve, St: Located in Las Vegas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),

                  InkWell(
                    onTap: () {
                      //showEditAddressDialog(context, 'Change Button');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: Colors.grey,
                            width: 1.5
                          )
                        )
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (showDeliveryTime) ...[
                const SizedBox(height: 5),

                Divider(
                  color: Colors.black54,
                ),

                const SizedBox(height: 5),

                DeliveryTimeCard(),
              ]
            ],
          ),
        );
      },
    );
  }
}
