import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/cart/service/cart_service.dart';

import '../Button/shemerTextButton.dart';
import '../app_bar/custom_app_bar.dart';
import 'bottom_sheets/checkout_bottom_sheet.dart';
import 'controller/cart_provider.dart';
import 'empty_cart_card.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/delivery_details_card.dart';

import 'widgets/order_details_card.dart';

class CartScreen extends StatefulWidget {

  final bool isDeeplink;

  const CartScreen({super.key, this.isDeeplink = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  bool isLoading = false;

  ScrollController _scrollController = ScrollController();

  late CartProvider cartProvider;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    cartProvider = Provider.of<CartProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartProvider.updateTotalCartPrice();
    });

    fetchRequiredData();



    setState(() {
      isLoading = false;
    });
  }

  fetchRequiredData() async {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String languageCode = Localizations.localeOf(context).languageCode;

      String specialDiscountDocName = languageCode == 'hi'
          ? 'SpecialDiscountHindi'
          : 'SpecialDiscount';

      await cartProvider.fetchSpecialDiscountOffer(context, specialDiscountDocName);
      await cartProvider.fetchCoupons(languageCode);

      await Future.wait([
        // cartProvider.fetchUserAddress(),
        cartProvider.fetchCrops(),
        cartProvider.fetchFreeProduct(),
      ]);
    });
  }

  Map<String, dynamic>? frequntly;
  Map<String, dynamic>? frequntlyHi;


  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider cartProvider, Widget? child) {

       double discount =  cartProvider.isSpecialDiscountApply
            ? double.parse(cartProvider.specialDiscountOffer!.discountPercentage.replaceFirst('₹', '').trim())
            : cartProvider.discountAmount;

     double totalamount =  cartProvider.totalCartPrice - double.parse(discount.toStringAsFixed(2) );

        // ignore: deprecated_member_use
        return Scaffold(

            // backgroundColor: Colors.white,

            appBar: CustomAppBar(isHomepage : false),

            body: cartProvider.cartItems.isEmpty
                ?
            EmptyCartCard()
                :
            Stack(
              children: [

                CustomScrollView(
                  controller: _scrollController,
                  slivers: [

                    // SliverToBoxAdapter(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8),
                    //     child: DeliveryDetailsCard(showDeliveryTime: false),
                    //   ),
                    // ),

                    // Cart Items
                    SliverToBoxAdapter(
                      child: CartItemCard(
                        isBuyNow: false,
                      )
                    ),

                    // Free Product Card
                    // if (cartProvider.freeProduct != null && cartProvider.freeVariant != null)
                    //   FreeProductCard(),

                    // Discount Card
                    // SliverToBoxAdapter(
                    //   child: CartDiscountCard()
                    // ),

                    // Order Details
                    SliverToBoxAdapter(
                        child: OrderDetailsCard(
                          totalItems: cartProvider.cartItems.length,
                          amount: cartProvider.totalCartPrice,
                          discountAmount: cartProvider.isSpecialDiscountApply
                              ? double.tryParse(cartProvider.specialDiscountOffer!.discountPercentage.replaceFirst('₹', '').trim()) ?? 30
                              : cartProvider.discountAmount,
                          mrp: cartProvider.totalCartMRP,
                          paymentOption: PaymentOption.payOnline,
                        )
                    ),



                    // Recommeded Products
                  ],
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // cartProvider.coupons.isNotEmpty
                      //     ?
                      // AllCouponUnlockCard(
                      //   isAllCouponUnlocked: cartProvider.isAllCouponUnlocked(),
                      // )
                      //     :
                      // SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "\$ ${totalamount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),

                                // Text(
                                //   "₹${cartProvider.totalCartPrice.toStringAsFixed(2)}",
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black54,
                                //     decoration: TextDecoration.lineThrough,
                                //     decorationColor: Colors.black,
                                //     decorationThickness: 2,
                                //   ),
                                // )
                              ],
                            ),

                            Flexible(
                              child: ShimmerTextButton(
                                onTap: () {
                                  showCheckoutBottomSheet(context);
                                },
                                height: MediaQuery.sizeOf(context).height * 0.06,
                                width:  MediaQuery.sizeOf(context).width * 0.6,
                                // title: "${AppLocalizations.of(context)?.Checkout ?? ''}"
                                title:  "Place Order",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),

        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
