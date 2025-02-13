// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget{
//
//   final String title;
//
//   final AppBarActionButton? actionButton1;
//   final AppBarActionButton? actionButton2;
//   final AppBarActionButton? actionButton3;
//
//   final bool showCallIcon;
//   final bool showCartIcon;
//
//   final Widget? startWidget;
//   final Widget? endWidget;
//
//   const SimpleAppBar({
//     super.key,
//     required this.title,
//
//     this.actionButton1,
//     this.actionButton2,
//     this.actionButton3,
//
//     this.startWidget,
//     this.endWidget,
//
//     this.showCallIcon = true,
//     this.showCartIcon = false,
//   });
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//
//
//   int getTotalCartItems(List<CartItem> cartItems) {
//     int totalItems = 0;
//
//     for (var item in cartItems) {
//       totalItems += item.quantity;
//     }
//     return totalItems;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: KrishiColors.primary,
//       iconTheme: IconThemeData(color: Colors.white),
//       title: Text(
//         title,
//         style: TextStyle(
//           // fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         )
//       ),
//       actions: [
//
//         if (startWidget != null)
//           startWidget!,
//
//         if (actionButton1 != null)
//           Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: customActionButton(
//               icon: actionButton1!.icon,
//               onTap: actionButton1!.onTap
//             ),
//           ),
//
//         if (actionButton2 != null)
//           Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: customActionButton(
//                 icon: actionButton2!.icon,
//                 onTap: actionButton2!.onTap
//             ),
//           ),
//
//         if (actionButton3 != null)
//           Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: customActionButton(
//               icon: actionButton3!.icon,
//               onTap: actionButton3!.onTap
//             ),
//           ),
//
//         if (showCartIcon)
//           Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: InkWell(
//               onTap: () {
//                 Navigator.pushNamed(context, Routes.cart);
//               },
//               child: Stack(
//                 children: [
//                   InkWell(
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 12),
//                       child: const Icon(
//                         Icons.shopping_cart,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Consumer<CartProvider>(
//                     builder: (BuildContext context, CartProvider provider,
//                         Widget? child) {
//                       int cartItems = getTotalCartItems(provider.cartItems);
//
//                       return cartItems > 0
//                           ? Positioned(
//                         right: 5,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.red,
//                           radius: 8,
//                           child: Text(
//                             cartItems.toString(),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                             ),
//                           ),
//                         ),
//                       )
//                           : const SizedBox();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//         if (showCallIcon)
//           customActionButton(
//             icon: Icons.call,
//             onTap: () async {
//               await _makePhoneCall();
//             }
//           ),
//
//         if (endWidget != null)
//           endWidget!,
//
//         const SizedBox(width: 10),
//       ],
//     );
//   }
//
//   Widget customActionButton({
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           shape: BoxShape.circle,
//           border: Border.fromBorderSide(
//             BorderSide(
//               color: Colors.white,
//               width: 1.5,
//             )
//           )
//         ),
//         child: Icon(
//           icon,
//           color: Colors.white,
//           size: 14,
//         ),
//       ),
//     );
//   }
//
//   Future<void> _makePhoneCall() async {
//     String number = contactModel?.number ?? '+917000528397' ;
//
//     final Uri callUri = Uri(scheme: 'tel', path: number);
//     if (await canLaunchUrl(callUri)) {
//       await launchUrl(callUri);
//     } else {
//       debugPrint('Could not launch $callUri');
//     }
//   }
// }
//
// class AppBarActionButton {
//
//   final IconData icon;
//   final VoidCallback onTap;
//
//   AppBarActionButton({
//     required this.icon,
//     required this.onTap,
//   });
// }
