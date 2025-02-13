import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/buttons/quantity_button_card.dart';
import '../../controller/cart_provider.dart';
import '../../model/cart_model.dart';
import '../../widgets/delivery_time_card.dart';

class CurrentProductDetailsCard extends StatelessWidget {

  final CartItem item;

  const CurrentProductDetailsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              // Product Image
              Image.network(
                item.imageSrc,
                height: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
              ),

              const SizedBox(width: 10),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Product Title
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Variant
                    Text(
                      item.variant.split('(').first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    // Product Price & Quantity
                    Consumer<CartProvider>(
                      builder: (BuildContext context, CartProvider provider, Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // Price
                            Row(
                              children: [
                                // Product MRP
                                Text(
                                  '₹${item.mrp.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    decoration: TextDecoration
                                        .lineThrough,
                                    decorationColor: Colors.grey,
                                  ),
                                ),

                                // Product Price
                                Text(
                                  ' ₹${item.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // Quantity
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: QuantityButtonCard(
                                onQuantityDecrease: provider.decreaseProductQuantity,
                                onQuantityIncrease: provider.increaseProductQuantity,
                                quantity: provider.cartItem?.quantity.toString() ?? '1',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Divider(
              color: Colors.grey,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: DeliveryTimeCard(),
          ),
        ],
      ),
    );
  }
}
