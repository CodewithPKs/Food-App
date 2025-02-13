import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/cart/bottom_sheets/widgets/current_product_details_card.dart';
import 'package:untitled/cart/bottom_sheets/widgets/pay_online_card.dart';

import '../controller/cart_provider.dart';
import '../model/cart_model.dart';
import '../service/cart_service.dart';
import '../widgets/customer_counting_card.dart';
import '../widgets/delivery_details_card.dart';
import '../widgets/order_details_card.dart';

class BuyNowBottomSheet extends StatefulWidget {

  final CartItem item;
  final ScrollController scrollController;
  const BuyNowBottomSheet({
    super.key,
    required this.item,
    required this.scrollController,
  });

  @override
  State<BuyNowBottomSheet> createState() => _BuyNowBottomSheetState();
}

class _BuyNowBottomSheetState extends State<BuyNowBottomSheet> {

  late CartProvider cartProvider;


  PaymentOption _paymentOption = PaymentOption.payOnline;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);

    // cartProvider.initializeRazorpay(context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((context) async {
      await Future.delayed(Duration(seconds: 3));
      cartProvider.setCartItem(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider provider, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
          
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 5),
              
              Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      DeliveryDetailsCard(showDeliveryTime: false),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),

                      CurrentProductDetailsCard(
                         item: widget.item,
                      ),

                      PayOnlineCard(
                        onTap: () {
                          setState(() {
                            _paymentOption = PaymentOption.payOnline;
                          });
                        },
                        paymentOption: _paymentOption,
                        amount: double.parse(widget.item.price.toString()) * (provider.cartItem?.quantity ?? 1),
                        discountAmount: cartProvider.singleProductDiscountAmount,
                        isBuyNow: true,
                        cartProvider: provider,
                      ),

                      const SizedBox(height: 5),



                      const SizedBox(height: 5),

                      OrderDetailsCard(
                        totalItems: 1,
                        amount: double.parse(widget.item.price.toString()) * (provider.cartItem?.quantity ?? 1),
                        discountAmount: provider.singleProductDiscountAmount,
                        mrp: double.parse(widget.item.mrp.toString()) * (provider.cartItem?.quantity ?? 1),
                        paymentOption: _paymentOption,
                      ),

                      const SizedBox(height: 5),


                      const SizedBox(height: 20),

                      CustomerCountingCard(
                        provider: cartProvider,
                      ),

                      const SizedBox(height: 10),
                    ],
                  )
              ),
            ],
          ),
        );
      },
    );
  }
}

void showBuyNowBottomSheet({
  required BuildContext context,
  required CartItem item,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableActuator(
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return BuyNowBottomSheet(
              scrollController: scrollController,
              item: item
            );
          },
        ),
      );
    },
  );
}