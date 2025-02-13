import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:untitled/Login/Controller/AuthController.dart';
import 'package:untitled/Product/controller/product_provider.dart';
import 'package:untitled/cart/controller/cart_provider.dart';
import 'package:untitled/splase.dart';
import 'SuccessScreen.dart';
import 'bottom_nav_bar/controller/nav_bar_provider.dart';
import 'bottom_nav_bar/krishi_bottom_nav_bar.dart';
import 'home/HomeNewScreen.dart';
import 'key.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Stripe.publishableKey = PublishableKey;
  await Stripe.instance.applySettings();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => NavBarProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],

      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halal Empire',
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff1A1410)),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    onGenerateRoute: (settings) {
    switch (settings.name) {
    case '/':
    return MaterialPageRoute(builder: (context) => SplashScreen());
    case '/success_screen':
      final args = settings.arguments as Map<String, dynamic>?;
    return MaterialPageRoute(builder: (context) => SuccessScreen(ordrID: args?['orderID'] ?? '',));
    default:
    return MaterialPageRoute(builder: (context) => KrishiBottomNavBar());
    }
       }

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Map<String, dynamic>? paymentIntentData;

  showPaymentSheet() async {
    try {

      await Stripe.instance.presentPaymentSheet().then((val) {
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

      paymentIntentData = await makeIntentForPayment(amount, currency);


      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              allowsDelayedPaymentMethods: true,
              paymentIntentClientSecret: paymentIntentData!["client_secret"],
              style: ThemeMode.dark,
              merchantDisplayName : "Empire Halal Platters"
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => PaymentSheet("50", "USD"),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
