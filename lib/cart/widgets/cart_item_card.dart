import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Product/controller/product_provider.dart';
import '../../common/widget/Text/title_text.dart';
import '../../common/widget/buttons/quantity_button_card.dart';

import '../../constants/sizes.dart';
import '../controller/cart_provider.dart';
import '../model/cart_model.dart';

class CartItemCard extends StatelessWidget {
  final bool isBuyNow;

  const CartItemCard({super.key, required this.isBuyNow});

  void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: KrishiSizes.mdSideSpacing),
      child: Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartProvider, child) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              CartItem item = cartProvider.cartItems[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Item Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.imageSrc,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/chicken.jpeg',
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item Title
                              KrishiProductTitleText(
                                title: item.title,
                                maxLines: 1,
                                //overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),


                              // Row(
                              //   children: [
                              //     Text(
                              //       '\$ ${item.price.toStringAsFixed(0)}',
                              //       style: const TextStyle(
                              //         color: Colors.orange,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //     const SizedBox(width: 10),
                              //   ],
                              // ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Consumer<ProductProvider>(
                                    builder: (BuildContext context, ProductProvider productProvider, Widget? child) {
                                      return QuantityButtonCard(
                                        onQuantityDecrease: () {
                                          if (item.quantity > 1) {
                                            productProvider.decreaseQuantity(variantId: item.variantId);
                                            cartProvider.updateCartItemQuantity(item.variantId, item.quantity - 1);
                                          } else {
                                            showWarning(context, "Quantity cannot be less than 1");
                                          }
                                        },
                                        onQuantityIncrease: () {
                                          productProvider.increaseQuantity(variantId: item.variantId);
                                          cartProvider.updateCartItemQuantity(item.variantId, item.quantity + 1);
                                        },
                                        quantity: item.quantity.toString(),
                                      );
                                    },
                                  ),

                                 Row(
                                   children: [

                                     Text(
                                       'Total: ',
                                       style: const TextStyle(
                                         color: Colors.white,
                                         fontSize: 20,
                                       ),
                                     ),

                                     Text(
                                       '\$${(item.price * item.quantity).toStringAsFixed(0)}',
                                       style: const TextStyle(
                                         color: Colors.orange,
                                         fontWeight: FontWeight.w400,
                                         fontSize: 22,
                                       ),
                                     ),
                                     
                                     SizedBox(width: 12,),
                                     
                                     Container(
                                       padding: EdgeInsets.all(5),
                                       child: InkWell(onTap: () { cartProvider.removeFromCart(index: index);},child:  Icon(Icons.delete_outline_outlined, color: Colors.white70, size: 18,)),
                                       decoration: BoxDecoration(
                                         color: Colors.red.withOpacity(0.5),
                                         borderRadius: BorderRadius.circular(8)
                                       ),
                                     )
                                   ],
                                 )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Remove Icon
                    // if (!isBuyNow)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Text(
                          '\$ ${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

