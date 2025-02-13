import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../controller/cart_provider.dart';
import '../model/cart_model.dart';
import '../service/cart_service.dart';


class OrderDetailsCard extends StatelessWidget {

  final double mrp;
  final double amount;
  final double discountAmount;
  final int totalItems;
  final PaymentOption paymentOption;

  const OrderDetailsCard({
    super.key,
    required this.amount,
    required this.discountAmount,
    required this.totalItems,
    required this.mrp,
    this.paymentOption = PaymentOption.payOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider provider, Widget? child) {

        num coins = 0;
        String price = (amount - discountAmount - coins).toStringAsFixed(2);

        double totalDiscount = double.parse(discountAmount.toStringAsFixed(2)) + double.parse(mrp.toString()) + double.parse(coins.toString());

        double totalClsDis = totalDiscount - double.parse(amount.toString());
        double totalCOD = double.parse(price) + coins ;
        int cartItems = getTotalCartItems(provider.cartItems);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GestureDetector(
            onTap: provider.togglePriceDetailsExpansion,
            child: Column(
              children: [
                !provider.isPriceDetailsExpanded
                    ?
                Container(
                  // color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Item MRP
                      _customInfoRow(
                        context: context,
                        title: '${"Price"} ($cartItems ${cartItems == 1 ? '${'Item'}' : '${'Items'}'})',
                        value: mrp.toStringAsFixed(2),
                      ),

                      // Delivery Charges
                      _customDiscountRow(
                          title: 'Delivery Charges',
                          value: 'FREE',
                          showMinus: false,
                      ),

                      // Item Price Discount
                      _customDiscountRow(
                        value: '${(mrp - amount).toStringAsFixed(2)}', title: '',
                      ),

                      // Item Price Discount
                      if (discountAmount.toInt() > 0)
                        _customDiscountRow(
                            title: 'Coupon Discount ${provider.couponTextController.text != '' ? '(${provider.couponTextController.text})' : ''}' ,
                            value: discountAmount.toStringAsFixed(2)
                        ),

                      // Coin Discount
                      // if(paymentOption == PaymentOption.payOnline)
                      //   _customDiscountRow(
                      //     title: AppLocalizations.of(context)?.krishiCoins ?? 'Krishi Coins',
                      //     value: coins.toStringAsFixed(0),
                      //   ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                border: Border.symmetric(horizontal: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5
                                ))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: KrishiColors.white,
                                  ),
                                ),

                                Text(
                                  paymentOption == PaymentOption.payOnline ? '\$ $price' : '\$ $totalCOD',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: KrishiColors.white,
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${"Save"} \$ ${totalClsDis.toStringAsFixed(2)} ${"On this Order"}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: KrishiColors.primary
                        ),
                      )
                    ],
                  ),
                )
                    :
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 24,
                      ),

                      const Spacer(),

                      Text(
                        paymentOption == PaymentOption.payOnline ? '\$ $price' : '₹ $totalCOD',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 30,)

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _customInfoRow({
    required BuildContext context,
    required String title,
    String? value,
    double? fontSize,
    Color? color,
    Widget? customText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: KrishiColors.white,
            ),
          ),

          customText ??
              Text(
                "\$ $value",
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  color: color ?? KrishiColors.white,
                ),
              ),
        ],
      ),
    );
  }

  Widget _customDiscountRow({
    required String title,
    required String value,
    bool showMinus = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: KrishiColors.primary,
            ),
          ),

          Text(
            "${showMinus ? '- ₹' : ''}$value",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: KrishiColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  int getTotalCartItems(List<CartItem> cartItems) {
    int totalItems = 0;

    for (var item in cartItems) {
      totalItems += item.quantity;
    }
    return totalItems;
  }

}