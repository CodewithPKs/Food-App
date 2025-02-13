import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../Login/Controller/AuthController.dart';
import '../app_bar/custom_app_bar.dart';
import '../cart/controller/cart_provider.dart';
import '../cart/model/cart_model.dart';


class Homenewscreen extends StatefulWidget {
  const Homenewscreen({super.key});

  @override
  State<Homenewscreen> createState() => _HomenewscreenState();
}

class _HomenewscreenState extends State<Homenewscreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Column(
        children: [
          // TabBar
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "MENU"),
                Tab(text: "MY ORDERS"),
                Tab(text: "ORDER TRACKING"),
                Tab(text: "SUPPORT"),
              ],
            ),
          ),

          // Expanded TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // MENU Tab (Categories Grid)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No categories found.'));
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 0.6,
                      ),
                      padding: const EdgeInsets.all(6.0),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                  category: doc.id,
                                  imageUrl: doc['imageUrl'],
                                  name: doc['name'],
                                ),
                              ),
                            );
                          },
                          child: MenuCard(imageUrl: doc['imageUrl'], name: doc['name']),
                        );
                      },
                    );
                  },
                ),

                // MY ORDERS Tab
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('payments')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.orange)),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No Orders found.',
                            style: TextStyle(color: Colors.orange)),
                      );
                    }

                    var orders = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index].data() as Map<String, dynamic>;
                        return OrderCard(order: order);
                      },
                    );
                  },
                ),

                // ORDER TRACKING Tab
                const Center(child: Text("Order Tracking Screen", style: TextStyle(color: Colors.white, fontSize: 16))),

                // SUPPORT Tab
                const Center(child: Text("Support Screen", style: TextStyle(color: Colors.white, fontSize: 16))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.orange, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['orderId']}',
                style: TextStyle(color: Colors.orange, fontSize: 16)),
            Text('User: ${order['userName']} - ${order['userEmail']}',
                style: TextStyle(color: Colors.white)),
            Text('Total Amount: \$${order['totalAmount']}',
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 5),
            Text('Items:', style: TextStyle(color: Colors.orange)),
            Column(
              children: (order['order_item'] as List)
                  .map<Widget>((item) => ListTile(
                leading: Image.network(item['image'], height: 40, errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/chicken.jpeg',
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  );
                },),
                title: Text(item['title'],
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                    'Qty: ${item['quantity']} | Price: \$${item['price']}',
                    style: TextStyle(color: Colors.white70)),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}




class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String name;

  const MenuCard({super.key, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // Slightly larger radius
            child: SizedBox(
              height: 160, // Increased height
              width: 160,  // Increased width
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/chicken.jpeg',
                    fit: BoxFit.cover,
                    height: 160,
                    width: 140,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18, // Slightly larger font size
            ),
          ),
        ],
      ),
    );
  }
}





class ProductListScreen extends StatelessWidget {
  final String category;
  final String imageUrl;
  final String name;

  ProductListScreen({required this.category, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isHomepage : false),
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/chicken.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 160,
                  );
                },
              ),
              Positioned(
                right: 0,
                left: 0,
                top: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.info_outline, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('category', isEqualTo: category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return foodCard(
                      name: doc['name'],
                      des: doc['description'],
                      image: doc['imageUrl'],
                      price: doc['price'].toString(),
                      productId: doc.id,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class foodCard extends StatelessWidget {
  final String name;
  final String des;
  final String image;
  final String price;
  final String productId;

  const foodCard({
    Key? key,
    required this.name,
    required this.des,
    required this.image,
    required this.price,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItem = cartProvider.cartItems.firstWhere(
          (item) => item.productId == productId,
      orElse: () => CartItem(
        variant: productId,
        imageSrc: image,
        productId: productId,
        title: name,
        variantId: productId,
        quantity: 0,
        price: double.parse(price),
        mrp: double.parse(price),
      ),
    );

    void addToCart() {
      if (cartItem.quantity == 0) {
        cartProvider.addToCart(
          item: cartItem.copyWith(quantity: 1),
          collectionId: 'cart',
          category: 'food',
        );
      } else {
        cartProvider.updateCartItemQuantity(cartItem.variantId, cartItem.quantity + 1);
      }
    }

    void removeFromCart() {
      if (cartItem.quantity > 1) {
        cartProvider.updateCartItemQuantity(cartItem.variantId, cartItem.quantity - 1);
      } else {
        //cartProvider.removeFromCart( index: null);
      }
    }

    return Container(
      color: Colors.black54,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.network(
                  image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/chicken.jpeg',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Text(
                    des,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  Text(
                    '\$ $price',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ],
              ),
            ],
          ),
          cartItem.quantity == 0
              ? IconButton(
            onPressed: addToCart,
            icon: Icon(Icons.shopping_bag_outlined),
            color: Colors.orange,
          )
              : Row(
            children: [
              IconButton(
                onPressed: removeFromCart,
                icon: Icon(Icons.remove_circle_outline),
                color: Colors.orange,
              ),
              Text(
                cartItem.quantity.toString(),
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: addToCart,
                icon: Icon(Icons.add_circle_outline),
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}





