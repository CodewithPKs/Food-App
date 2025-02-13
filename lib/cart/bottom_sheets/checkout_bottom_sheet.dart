import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:untitled/cart/bottom_sheets/widgets/pay_online_card.dart';

import '../controller/cart_provider.dart';
import '../service/cart_service.dart';
import '../widgets/customer_counting_card.dart';
import '../widgets/order_details_card.dart';

class CheckoutBottomSheet extends StatefulWidget {

  final ScrollController scrollController;

  const CheckoutBottomSheet({super.key, required this.scrollController});

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {

  late CartProvider cartProvider;


  PaymentOption _paymentOption = PaymentOption.payOnline;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);

    // cartProvider.initializeRazorpay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider provider, Widget? child) {

        double discount =  provider.isSpecialDiscountApply
            ? double.parse(provider.specialDiscountOffer!.discountPercentage.replaceFirst('₹', '').trim())
            : provider.discountAmount;

        return Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border.all(color: Colors.orange, width: 0.5)
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  PayOnlineCard(
                    onTap: () {
                      setState(() {
                        _paymentOption = PaymentOption.payOnline;
                      });
                    },
                    paymentOption: _paymentOption,
                    amount: cartProvider.totalCartPrice,
                    discountAmount: provider.isSpecialDiscountApply ? discount : cartProvider.discountAmount,
                    isBuyNow: false,
                    cartProvider: provider,
                  ),

                  const SizedBox(height: 5),

                  // CashOnDeliveryCard(
                  //   onTap: () {
                  //     setState(() {
                  //       _paymentOption = PaymentOption.cashOnDelivery;
                  //     });
                  //   },
                  //   paymentOption: _paymentOption,
                  //   amount: cartProvider.totalCartPrice,
                  //   discountAmount: provider.isSpecialDiscountApply ? discount : cartProvider.discountAmount,
                  //   isBuyNow: false,
                  //   cartProvider: provider,
                  // ),
                  //
                  // const SizedBox(height: 5),

                  OrderDetailsCard(
                    totalItems: provider.cartItems.length,
                    amount: provider.totalCartPrice,
                    discountAmount: provider.isSpecialDiscountApply
                        ? double.parse(provider.specialDiscountOffer!.discountPercentage.replaceFirst('₹', '').trim())
                        : provider.discountAmount,
                    mrp: provider.totalCartMRP,
                    paymentOption: _paymentOption,
                  ),

                  const SizedBox(height: 5),


                  const SizedBox(height: 20),

                  CustomerCountingCard(
                    provider: cartProvider,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            )
        );
      },
    );
  }

}

void showCheckoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableActuator(
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.25,
          maxChildSize: 0.8,
          expand: false,

          builder: (BuildContext context, ScrollController scrollController) {
            return CheckoutBottomSheet(
              scrollController: scrollController,
            );
          },
        ),
      );
    },
  );
}