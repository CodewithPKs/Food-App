import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../model/cart_model.dart';
import '../model/coupon_model.dart';
import '../model/delivery_detail_model.dart';
import '../model/free_product_model.dart';
import '../model/free_variant_model.dart';
import '../model/special_discount_model.dart';

class CartService {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;




  static final String CART_KEY = 'cart';

 static Future<List<CartItem>> getCartItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data = pref.getStringList(CART_KEY) ?? [];
    List<CartItem> cartItems = data.map((item) {
      log('Cart Item Data - $item');
      return CartItem.fromJson(json.decode(item));
    }).toList();
    return cartItems;
  }

  Future<void> saveCartItems(List<CartItem> cartItems) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final cartData = cartItems.map((item) => json.encode(item.toMap())).toList();
    await pref.setStringList(CART_KEY, cartData);
    //saveUserCartStatus(cartItems);
  }


  Stream<List<DeliveryDetailModel>> fetchDeliveryDetails() async* {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('DynamicSection')
          .doc('Delivery Details')
          .collection('States')
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;

      List<DeliveryDetailModel> list = docs.map((data) =>
          DeliveryDetailModel.fromJson(data.data())).toList();

      yield list;
    } catch (e) {
      log('Error fetching delivery details: $e');
      yield [];
    }
  }

  Future<Map<String, List<String>>> fetchCrops() async {
    try {
      DocumentSnapshot docSnapshot = await firestore
          .collection('CropOption')
          .doc('cropData')
          .get();

      List<String> cropList = List<String>.from(docSnapshot['croplist']);
      List<String> cropListHi = List<String>.from(docSnapshot['croplistHi']);

      cropList.sort((a, b) => a.compareTo(b));
      cropListHi.sort((a, b) => a.compareTo(b));

      return {
        'cropList': cropList,
        'cropListHi': cropListHi,
      };
    } catch (e) {
      log('Error fetching crops: $e');
      return {};
    }
  }

  Future<FreeVariantModel?> fetchProductData(String productId) async {
    final String graphqlEndpoint = 'https://3d6a19.myshopify.com/admin/api/2024-04/graphql.json';
    final String accessToken = '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';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString('language_code') ?? '';

    final query = '''
        query TranslatedProduct(\$product_id: ID!, \$locale: String!, \$imgLength: Int!, \$varLength: Int!) {
          product(id: \$product_id) {
            title
            tags
            description
            translations(locale: \$locale) {
              key
              value
            }
            images(first: \$imgLength) {
              edges {
                node {
                  src
                }
              }
            }
            status
            variants(first: \$varLength) {
              edges {
                node {
                  price
                  title
                  compareAtPrice
                  id
                }
              }
            }
          }
        }
      ''';

    final Map<String, dynamic> variables = {
      'product_id': "gid://shopify/Product/$productId",
      'locale': languageCode,
      'imgLength': 6,
      'varLength': 6,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Shopify-Access-Token': accessToken,
    };

    try {
      final response = await http.post(
        Uri.parse(graphqlEndpoint),
        headers: headers,
        body: jsonEncode({'query': query, 'variables': variables}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> productDetails = jsonDecode(
            response.body)['data']['product'];

        Map<String, dynamic> data = {
          'freeProductTitle': productDetails['title'] ?? '',
          'freeVarientTitle': productDetails['variants']['edges'][0]['node']['title'] ??
              '',
          'freeVariantId': productDetails['variants']['edges'][0]['node']['id'] ??
              '',
          'freeVariantQuantity': 1,
          'freeVariantPrice': double.parse(
              productDetails['variants']['edges'][0]['node']['price'] ?? '0'),
          'freeVariantImage': productDetails['images']['edges'][0]['node']['src'] ??
              '',
        };

        FreeVariantModel variantModel = FreeVariantModel.fromJson(data);

        return variantModel;
      } else {
        log('Failed to fetch product data: ${response.statusCode}');
        return null;
      }
    } catch (e, stace) {
      log('An error occurred while fetching product data (cart): $e\n$stace');
      return null;
    }
  }

  Future<FreeProductModel?> fetchFreeProduct() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('DynamicSection')
          .doc('FreeProduct')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        FreeProductModel freeProductModel = FreeProductModel.fromJson(data);
        return freeProductModel;
      }

      return null;
    } catch (e, stace) {
      log('Error Fetching Free Products :- $e\n$stace');
      return null;
    }
  }

  Future<SpecialDiscountOfferModel?> fetchSpecialDiscountOffer(BuildContext context, String specialDiscountDocName) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('DynamicSection')
          .doc(specialDiscountDocName)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        SpecialDiscountOfferModel specialDiscountOfferModel = SpecialDiscountOfferModel
            .fromJson(data);
        return specialDiscountOfferModel;
      }

      return null;
    } catch (e, stace) {
      log('Error Fetching Special Discount Offer :- $e\n$stace');
      return null;
    }
  }

  Future<List<CouponModel>> fetchCoupons() async {

    log('Fetching Coupons from Server...');

    final url = 'https://3d6a19.myshopify.com/admin/api/2023-10/graphql.json';

    final String query = '''
    query {
      discountNodes(first:200){
        edges{
          node{
            id
            discount{
              ... on DiscountCodeBasic{
                title
                summary
                status
              }
            }
          }
        }
      }
    }
    ''';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Shopify-Access-Token': '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',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<dynamic> couponList = data['data']['discountNodes']['edges'];

        log('Parsing Coupons..');
        List<CouponModel> coupons = couponList.map((coupon) => CouponModel.fromJson(coupon['node']['discount'])).toList();
        log('Coupons Parsed..!!');

        List<CouponModel> activeCoupons = [];

        activeCoupons = coupons.where((coupon) => coupon.status.toUpperCase() == 'ACTIVE').toList();

        log('All Coupons fetched from Server Successfully :)');

        return activeCoupons;

      } else {
        log('Error fetching coupons :- ${response.body}');
        return [];
      }
    } catch (e, stace) {
      log('Unexpected error while fetching coupons :- $e\n$stace');
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchCouponDescription(String languageCode) async {
    try {
      log('Fetching Coupon Decription from Firebase..');

      List<Map<String, String>> couponDescriptions = [];

      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('Discount Coupons').get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;

      for (var doc in docs) {
        if (doc.exists) {
          final data = doc.data();
          String title = data['name'] ?? doc.id;
          String couponDescription = languageCode == 'hi' ? data['hindiDesc'] ??
              '' : data['englishDesc'] ?? '';
          couponDescriptions.add({
            'title': title,
            'desc': couponDescription,
          });
        } else {
          couponDescriptions.add({
            'title': doc.id,
            'desc': 'NA',
          });
        }
      }

      log('Coupon Description fetched from firebase succussfully :)');

      return couponDescriptions;
    } catch (e, stace) {
      log('Error fetching discount desciptions :- $e\n$stace');
      return [];
    }
  }

  Future<int> fetchCouponCount(String couponTitle) async {
    int count = 0;

    String cId = '';

    if (cId == '') return 0;

    final url = 'https://3d6a19.myshopify.com//admin/api/2023-10/orders.json?customer_id=$cId';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Shopify-Access-Token': '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',
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var val in data['orders']) {
          for (var coup in val['discount_codes']) {
            if (coup['code'] == couponTitle) {
              count++;
            }
          }
        }
      }
    } catch (e) {
      log('Error fetching coupon count :- $e');
    }

    return count;
  }

  Future<void> sendPaymentFailedData({
    required String number,
    required String paymentID,
    required double amount,
    required String error,
  }) async {
    try {
      await firestore.collection('PaymentsFailed').doc(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()).set({
        'number': number,
        'paymentID': paymentID,
        'amount': amount,
        'error': error,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Payment data added successfully');
    } catch (e) {
      print('Error adding payment data: $e');
    }
  }

  // Future<String?> processShopifyOrder({
  //   required BuildContext context,
  //   required Map<String, dynamic> orderData,
  //   required List<Map<String, dynamic>> items,
  //   required String mobileNumber,
  //   required String paymentId,
  //   required String financialStatus,
  //   required PaymentOption paymentOption,
  //   required double totalCartPrice,
  //   required double discountAmount,
  //
  //   required double addableCoins,
  //   required num coins,
  // }) async {
  //   try {
  //
  //     final data = orderData['order'];
  //
  //     // Map<String, dynamic> checkoutPayload = {
  //     //   "items": items,
  //     //   "total_price": totalCartPrice,
  //     //   "activity_date": NetcoreService.getFormattedDateTimeForNetcore(),
  //     //   "itemcount": data['line_items'].length,
  //     // };
  //
  //     // await NetcoreService.checkoutEvent(checkoutPayload);
  //
  //     http.Response orderResponse = await http.post(
  //       Uri.parse('https://3d6a19.myshopify.com/admin/api/2024-04/orders.json'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'X-Shopify-Access-Token': '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',
  //       },
  //       body: jsonEncode(orderData),
  //     );
  //
  //     log('Order Response - ${orderResponse.body}');
  //
  //     if (orderResponse.statusCode == 201) {
  //       Map<String, dynamic> orderResponseBody = jsonDecode(orderResponse.body);
  //
  //       String orderId = orderResponseBody['order']['id'].toString();
  //       String kskId = orderResponseBody['order']['name'].toString();
  //
  //       log('Order ID - $orderId');
  //       log('KSK ID - $kskId');
  //
  //       if (paymentId.length != 0 && orderId != 0) {
  //
  //         log('Order Processed Succesfully :)');
  //
  //         if (paymentOption == PaymentOption.payOnline) {
  //           num removedCoins = coins;
  //
  //           await removeCoins(removedCoins, coins, kskId);
  //
  //           num addCoin = krishiCoins + addableCoins;
  //
  //           await addCoins(addCoin, addableCoins, kskId);
  //
  //           await capturePayment(paymentId, totalCartPrice - coins,  mobileNumber, kskId );
  //         }
  //
  //
  //
  //
  //
  //         int customId = await searchCustomerId(orderId.toString());
  //
  //         await UpdateDocument({'CustomerId': customId.toString()});
  //
  //         // Map<String, dynamic> productPurchasePayload = {
  //         //   "ship_country": data['shipping_address']['country'],
  //         //   // "discount_codes": "",
  //         //   "shippingcost": 0,
  //         //
  //         //   "items": items,
  //         //  // "items.brand": "Katyayani Organics",
  //         //
  //         //   "name": data['billing_address']['first_name'] + " " + data['billing_address']['last_name'],
  //         //   "received_at": NetcoreService.getFormattedDateTimeForNetcore(),
  //         //   // "current_total_tax": "",
  //         //   "shippingmethod": paymentOption.name,
  //         //   "payment_gateway_names": paymentOption == PaymentOption.cashOnDelivery ? 'COD' : "Razorpay",
  //         //   "activity_date": NetcoreService.getFormattedDateTimeForNetcore(),
  //         //   "orderid": orderId,
  //         //   // "order_status_url": "",
  //         //   "ship_city": data['shipping_address']['city'],
  //         //   "shippingaddress": data['shipping_address']['address1'],
  //         //   // "source_name": "",
  //         //   "currency": "INR",
  //         //   // "merchant_of_record_app_id": "",
  //         //   "current_total_discounts": discountAmount,
  //         //   "updated_at": NetcoreService.getFormattedDateTimeForNetcore(),
  //         //   "billingaddress": data['billing_address']['address1'],
  //         //   // "source_identifier": "",
  //         //   // "source_url": "",
  //         //   // "location_id": "",
  //         //   "itemcount": items.length,
  //         //   "created_at": NetcoreService.getFormattedDateTimeForNetcore(),
  //         //   "discount": discountAmount,
  //         //   "ship_region": data['shipping_address']['city'],
  //         //   // "payment_details": "",
  //         //   // "orderno": "",
  //         //   "amount": totalCartPrice,
  //         // };
  //         //
  //         // NetcoreService.productPurchaseEvent(productPurchasePayload);
  //
  //         return kskId;
  //       }
  //     }
  //
  //     if (paymentId.length != 0) {
  //       log('Order Error (1) - ${orderResponse.body}');
  //
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Warning', style: TextStyle(color: Colors.white)),
  //             content: SingleChildScrollView(
  //               child: ListBody(
  //                 children: <Widget>[
  //                   Text('Your payment was successful but order was not placed. Your PaymentId $paymentId is this to get your money refunded',
  //                       style: TextStyle(color: Colors.white)),
  //                 ],
  //               ),
  //             ),
  //             backgroundColor: Colors.red,
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('OK', style: TextStyle(color: Colors.white)),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //
  //       await sendPaymentFailedData(number: mobileNumber,
  //         paymentID: paymentId,
  //         amount: totalCartPrice,
  //         error: orderResponse.body,
  //       );
  //     }
  //
  //     else {
  //       log('Order Error (2) - ${orderResponse.body}');
  //       await sendPaymentFailedData(number: mobileNumber,
  //           paymentID: paymentId,
  //           amount: totalCartPrice,
  //           error: orderResponse.body);
  //
  //       Utils.showAlertDialog(context: context, title: 'Your Order is not Completed ${orderResponse.body}');
  //     }
  //
  //     return null;
  //   }
  //
  //   catch (e, stace) {
  //     log('Order Error (3) - ${e.toString()}\n$stace');
  //
  //     await sendPaymentFailedData(
  //       number: mobileNumber,
  //       paymentID: paymentId,
  //       amount: totalCartPrice,
  //       error: e.toString()
  //     );
  //
  //     Utils.showAlertDialog(context: context, title: 'An unexpected error occurred: $e');
  //
  //     return null;
  //   }
  // }

  Future<int> searchCustomerId(String orderId) async {
    final url = 'https://3d6a19.myshopify.com/admin/api/2024-04/orders/$orderId.json';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Shopify-Access-Token': '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',
    };

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['order']['customer']['id'];
    }
    else {
      print('Error: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to load id');
    }
  }

  Future<void> capturePayment(String paymentIdi, num amount, String phonenumber, String orderID) async {
    String keyId = 'rzp_live_feWmTKJJqoSW9z';
    String keySecret = '9idtdZiqyocLk70Ld8IbjMR5';

    String paymentId = paymentIdi;

    String url = 'https://api.razorpay.com/v1/payments/$paymentId/capture';

    Map<String, dynamic> requestBody = {
      "amount": amount * 100,
      "currency": "INR"
    };

    String requestBodyJson = jsonEncode(requestBody);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Basic ' +
              base64Encode(utf8.encode('$keyId:$keySecret'))
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        log('Payment Successfull :)');
        log('Payment Response - ${response.body}');

        await UpdatePayment(paymentIdi, amount * 100 , phonenumber, orderID);
      } else {
        log('Failed to capture payment: ${response.body}');
      }
    } catch (e) {
      log('Error capturing payment: $e');
    }
  }

  // Future<void> addCoins(num purchaseCoins, num coin, String kskId) async {
  //   if (purchaseCoins == 0) return;
  //
  //   String? mobileNumber = await UserData.getMobileNumber();
  //
  //   CollectionReference coins = FirebaseFirestore.instance.collection(
  //       'UpdateInformationPage/' + mobileNumber! + '/coins');
  //
  //   DateTime now = DateTime.now();
  //
  //   DateTime thirtyDaysLater = now.add(Duration(days: 30));
  //
  //   Map<String, dynamic> coinData = {
  //     'expiry date': thirtyDaysLater.toString(),
  //     'value': purchaseCoins,
  //     'coin': coin,
  //     'timestamp': DateTime.now(),
  //     'status': "+",
  //     'through': kskId,
  //   };
  //
  //   try {
  //     await coins.add(coinData);
  //     print('Product added successfully!');
  //   } catch (e) {
  //     print('Error adding product: $e');
  //   }
  // }


  Future<void> UpdatePayment(String paymentId, num amount, String PhoneNumber, String OrderID) async {
    String keyId = 'rzp_live_feWmTKJJqoSW9z';
    String keySecret = '9idtdZiqyocLk70Ld8IbjMR5';

    String url = 'https://api.razorpay.com/v1/payments/$paymentId';

    Map<String, dynamic> requestBody = {
      "notes": {
        "payment_id": OrderID,
        "Customer_number": PhoneNumber,
        "Order_amount" : amount.toString()
      }
    };

    String requestBodyJson = jsonEncode(requestBody);

    try {
      http.Response response = await http.patch(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Basic ' +
              base64Encode(utf8.encode('$keyId:$keySecret'))
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        log('Payment Successfull update:)');
        log('Payment Response - ${response.body}');
      } else {
        log('Failed to capture payment: ${response.body}');
      }
    } catch (e) {
      log('Error capturing payment: $e');
    }
  }

  Future<void> removeCoins(num removedCoins, num coin, String kskId) async {
    if (removedCoins == 0) return;

    String? mobileNumber = "";

    CollectionReference coins = FirebaseFirestore.instance.collection(
        'UpdateInformationPage/' + mobileNumber! + '/coins');

    DateTime now = DateTime.now();

    DateTime thirtyDaysLater = now.add(Duration(days: 30));

    Map<String, dynamic> coinData = {
      'expiry date': thirtyDaysLater.toString(),
      'value': removedCoins,
      'coin': coin,
      'timestamp': DateTime.now(),
      'status': "-",
      'through': kskId,
    };

    try {
      await coins.add(coinData);

      print('Product added successfully!');
    } catch (e) {
      print('Error adding product: $e');
    }
  }
}

enum PaymentOption {
  payOnline,
  cashOnDelivery,
}

enum PaymentApp {
  phonePe,
  googlePay,
  paytm
}