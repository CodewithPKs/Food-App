import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../../Email/EmailService.dart';
import '../../../Login/Controller/AuthController.dart';
import '../../../common/widget/buttons/custom_elevated_button.dart';
import '../../../constants/colors.dart';
import '../../../key.dart';
import '../../controller/cart_provider.dart';
import '../../model/cart_model.dart';
import '../../service/cart_service.dart';

class PayOnlineCard extends StatefulWidget {

  final VoidCallback onTap;
  final PaymentOption paymentOption;
  final double amount;
  final double discountAmount;

  final bool isBuyNow;
  final CartProvider cartProvider;

  const PayOnlineCard({
    super.key,
    required this.onTap,
    required this.paymentOption,
    required this.amount,
    required this.discountAmount,
    required this.isBuyNow,
    required this.cartProvider,
  });

  @override
  State<PayOnlineCard> createState() => _PayOnlineCardState();
}

class _PayOnlineCardState extends State<PayOnlineCard> {

  late String orderID = '';

  Map<String, dynamic>? paymentIntentData;

  late bool isLoading = false;

  showPaymentSheet() async {
    try {

      await Stripe.instance.presentPaymentSheet().then((val) async {
         await storePaymentData(paymentIntentData!);


         Navigator.pushNamed(context, "/success_screen", arguments: {"orderID": orderID});
         paymentIntentData = null;

      }).onError((error , sTrace) {
        if(kDebugMode) {
          print(' exception $error and ${sTrace.toString()}');
        }

        showDialog(context: context, builder: (c) => AlertDialog(content: Text("Cancellerd"),));
      });

    }
    on StripeException catch(error) {
      if(kDebugMode) {
        print(' exception $error');
      }

      showDialog(context: context, builder: (c) => AlertDialog(content: Text("Cancellerd"),));
    }
    catch (e, s) {
      if(kDebugMode) {
        print(' exception $s');
      }
      print('error $e');
    }

  }

  makeIntentForPayment(amount , currency) async {
    try {

      Map<String, dynamic>? paymentInfo = {
        "amount" : (int.parse(amount) * 100).toString(),
        "currency" : currency,
        "payment_method_types[]" : "card",
        'description': 'Test Purchase',

        "shipping[name]": "John Doe",
        "shipping[address][line1]": "123 Main Street",
        "shipping[address][city]": "Mumbai",
        "shipping[address][state]": "MH",
        "shipping[address][postal_code]": "400001",
        "shipping[address][country]": "IN",

      };

      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: paymentInfo,
          headers: {
            "Authorization" : "Bearer $secretKey",
            "Content-Type" : "Application/x-www-form-urlencoded"
          }
      );

      print("respomse of api  : ${response.body}");

      return jsonDecode(response.body);

    } catch (e, s) {
      if(kDebugMode) {
        print(' exception $s');
      }
      print('error $e');
    }
  }

  PaymentSheet(amount , currency) async {
    try {
      print('tapping.........');
      setState(() => isLoading = true);
      paymentIntentData = await makeIntentForPayment(amount, currency);


      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              allowsDelayedPaymentMethods: true,
              paymentIntentClientSecret: paymentIntentData!["client_secret"],
            style: ThemeMode.dark,
              merchantDisplayName : "Empire Halal Platters",
            // appearance: const PaymentSheetAppearance(
            //   colors: PaymentSheetAppearanceColors(
            //     background: Colors.black,
            //     primary: Colors.black,
            //     componentBackground: Colors.white,
            //     primaryText: Colors.white,
            //     secondaryText: Colors.white,
            //     placeholderText: Colors.black,
            //   ),
            //   shapes: PaymentSheetShape(
            //     borderRadius: 10.0, // Rounded corners
            //   ),
            //   primaryButton: PaymentSheetPrimaryButtonAppearance(
            //     colors: PaymentSheetPrimaryButtonTheme(
            //       dark : PaymentSheetPrimaryButtonThemeColors(
            //       background: Colors.orange, // Orange button background
            //       text: Colors.white, // White button text
            //     ),),
            //     shapes: PaymentSheetPrimaryButtonShape(
            //       blurRadius: 8.0, // Rounded button corners
            //       shadow: PaymentSheetShadowParams(
            //         color: Colors.black,
            //         opacity: 0.5,
            //
            //       ),
            //     ),
            //   ),
            // ),

          )
      ).then((val) {
        print('value $val');
      });

      await showPaymentSheet();


    } catch (e) {
      if(kDebugMode) {
        print(' exception $e');
      }
      print('error $e');
    }
  }

  Future<void> storePaymentData(Map<String, dynamic> paymentData) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    List<CartItem> cartItems = await CartService.getCartItems();
    List<Map<String, dynamic>> orderItems = cartItems.map((item) => {
      'title': item.title,
      'quantity': item.quantity,
      'price': item.price,
      'image': item.imageSrc,
    }).toList();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference orderCounterRef = firestore.collection('order_metadata').doc('order_counter');




    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(orderCounterRef);

      int lastOrderNumber = 0;
      if (counterSnapshot.exists) {
        lastOrderNumber = counterSnapshot.get('last_order_number') ?? 0;
      }

      int newOrderNumber = lastOrderNumber + 1;
      String newOrderId = '#ORD-$newOrderNumber';

      setState(() {
        orderID = newOrderId;
      });

      Map<String, dynamic> orderData = {
        'orderId': newOrderId,
        'totalAmount': widget.cartProvider.totalCartPrice.toStringAsFixed(2),
        'userEmail': authProvider.userData?['email'] ?? '',
        'userName': authProvider.userData?['name'] ?? '',
        'userPhone': authProvider.userData?['phone'] ?? '',
        'order_item': orderItems,
        'payementID' : paymentData['id']
      };

      // Send email
      await EmailService.sendOrderEmail(orderData);

      DocumentReference newOrderRef = firestore.collection('payments').doc();
      transaction.set(newOrderRef, {
        'orderId': newOrderId,
        'amount': paymentData['amount'],
        'currency': paymentData['currency'],
        'paymentIntentId': paymentData['id'],
        'totalAmount': widget.cartProvider.totalCartPrice.toStringAsFixed(2),
        'order_item': orderItems,
        'userEmail': authProvider.userData?['email'] ?? '',
        'userName': authProvider.userData?['name'] ?? '',
        'userPhone': authProvider.userData?['phone'] ?? '',
        'created_at': Timestamp.now(),
      });

      transaction.set(orderCounterRef, {'last_order_number': newOrderNumber});

      setState(() => isLoading = false);
      // Prepare order data for email
    });



    widget.cartProvider.clearCart();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("${widget.cartProvider.getCartItems()} 1");
    print("${widget.cartProvider.cartItems} 2");
    print("${widget.cartProvider.cartItem} 3");
  }

  @override
  Widget build(BuildContext context) {

   //final num coins = calculateCoins(widget.amount - widget.discountAmount);

    final double price = widget.amount - widget.discountAmount;

    return isLoading ?  Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white,),
      ),
    ) : Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.orange.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // Text(widget.cartProvider.cartItems)

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Pay Online Heading
                          Text(
                            "Pay Online",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 3),

                          // Pay Online Amount
                          Row(
                            children: [

                              // Total Amount to Pay via Pay Online
                              Text(
                                '\$ ${price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(width: 10),

                              if (widget.discountAmount.toInt() != 0 )

                                // Total Amount
                                Text(
                                  '\$ ${widget.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      widget.paymentOption == PaymentOption.payOnline
                          ?
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: KrishiColors.orangeLight,
                              width: 1.5,
                            ),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.orangeAccent,
                        ),
                      )
                          :
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: KrishiColors.grey,
                              width: 1.5,
                            ),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: KrishiColors.grey,
                        ),
                      )
                    ],
                  ),
                ),

                if (widget.paymentOption == PaymentOption.payOnline)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.discountAmount.toInt() != 0)
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 16,
                              color: KrishiColors.orangeLight,
                            ),

                            const SizedBox(width: 5),

                            // Text(
                            //   '${AppLocalizations.of(context)!.Applied} \$ ${widget.discountAmount} ${AppLocalizations.of(context)!.Coupon_Dis}',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.orange,
                            //   ),
                            // ),
                          ],
                        ),

                      const SizedBox(height: 5),

                      // Coins Applied Text
                      // if (coins.toInt() != 0)
                      //   Row(
                      //     children: [
                      //       Icon(
                      //         Icons.check,
                      //         size: 16,
                      //         color: KrishiColors.primary,
                      //       ),
                      //
                      //       const SizedBox(width: 5),
                      //
                      //     ],
                      //   ),

                      const SizedBox(height: 10),
                    ],
                  ),

                // Saved amount on online payment
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Party-Emoji.json',
                        width: 30,
                        height: 30,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        '\$ ${(widget.discountAmount).toStringAsFixed(0)} save extra',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                if (widget.paymentOption == PaymentOption.payOnline)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Consumer<CartProvider>(
                        builder: (BuildContext context, CartProvider provider, Widget? child) {
                          return CustomElevatedButton(
                            onTap: () {
                              PaymentSheet(
                                  provider.totalCartPrice.round().toString(),
                                  "USD"
                              );
                            },
                            titleWidget:  provider.isPaying
                                ?
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                                :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pay \$ ${price.toStringAsFixed(2)}',
                                  style: GoogleFonts.sora(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 5),

                              ],
                            ),
                            isLoading: provider.isPaying,
                            title: '',
                          );
                        },
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





