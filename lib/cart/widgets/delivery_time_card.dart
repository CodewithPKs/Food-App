import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import '../../constants/colors.dart';
import '../controller/cart_provider.dart';
import '../model/delivery_detail_model.dart';

class DeliveryTimeCard extends StatelessWidget {

  const DeliveryTimeCard({super.key});

  @override
  Widget build(BuildContext context) {

    String deliveredBy = 'Delivered By';
    String freeDelivery ='FREE DELIVERY';

    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider provider, Widget? child) {
        return StreamBuilder(
            stream: provider.fetchDeliveryDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  children: [
                    Text(
                      '${provider.savedDeliveryDateTime}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          color: Colors.black54,
                          thickness: 1.5,
                        ),
                      ),
                    ),

                    Flexible(
                      child: Text(
                        freeDelivery,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: KrishiColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                );
              }
              else if (snapshot.hasError) {
                return const SizedBox();
              }
              else if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox();
              }

              List<DeliveryDetailModel> data = snapshot.data!;

              String rawTime = provider.calculateDeliveryTime(
                  customerPincode: provider.userModel?.pincode ?? '',
                  deliveryDetails: data
              );

              String deliveryDate = provider.calculateDeliveryDate(rawTime);

              // String deliveryTime = rawTime == '' ? ' - ' : rawTime;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                provider.setSavedDeliveryDateTime('$deliveredBy $deliveryDate');
              });

              return Row(
                children: [
                  Text(
                    '$deliveredBy $deliveryDate',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      height: 18,
                      child: VerticalDivider(
                        color: Colors.black54,
                        thickness: 1.5,
                      ),
                    ),
                  ),

                  Flexible(
                    child: Text(
                      freeDelivery,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: KrishiColors.primary
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              );

            }
        );
      },
    );
  }
}
