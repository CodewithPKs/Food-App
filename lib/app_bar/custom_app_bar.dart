
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Login/Controller/AuthController.dart';
import '../cart/cart_screen.dart';
import '../cart/controller/cart_provider.dart';
import '../cart/model/cart_model.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showDrawer;
  final bool showCallIcon;
  final bool showKrishiImage;
  final bool noInternet;
  final bool isHomepage;

  const CustomAppBar({
    Key? key,
    this.showDrawer = false,
    this.showCallIcon = false,
    this.showKrishiImage = true,
    this.noInternet = false,
    this.isHomepage  = true
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(300);
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController?.index = 0; // Set "MENU" as the initially selected tab
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: const Color(0xff1A1410),
            elevation: 0,
            leading: widget.isHomepage ? SizedBox() : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: SizedBox(
              height: kToolbarHeight * 1,
              child: Image.asset(
                'assets/halalLogo.png',
                fit: BoxFit.contain, // Ensures the image is fully visible
                filterQuality: FilterQuality.high,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.orange),
                onPressed: () {
                  // Navigator.pushNamed(context, '/cart');
                 // categoryService.addCategories(categories);
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: Colors.orange),
                onPressed: () {
                  // Navigator.pushNamed(context, '/cart');
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.orange),
                onPressed: () {
                  authProvider.signOut();

                  Navigator.pushReplacementNamed(context, '/');
                  // Navigator.pushNamed(context, '/cart');
                },
              ),
            ],
          ),
          // Bottom Section
          Container(
            color: const Color(0xff1A1410),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hello, ${authProvider.userData?['name'] ?? ''}",
                    style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                      },
                    ),
                    Consumer<CartProvider>(
                        builder: (BuildContext context, CartProvider provider, Widget? child) {
                          int cartItems = getTotalCartItems(provider.cartItems);
                          return cartItems > 0
                              ? Text('(${cartItems}) items', style: TextStyle(color: Colors.white, fontSize: 18),)
                              : const SizedBox();
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int getTotalCartItems(List<CartItem> cartItems) {
  int totalItems = 0;
  for (var item in cartItems) {
    totalItems += item.quantity;
  }
  return totalItems;
}






