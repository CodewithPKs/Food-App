import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({Key? key});

  static const String quantityDescription = '1 ltr';
  static const String discountedPrice = '₹90';
  static const String originalPrice = '₹120';
  static const String offPercentage = '27% OFF';

  static const String productImage = 'assets/images/Product Image/Product.png';
  static const String productName = 'Product Name';
  static const String supplierName = 'Supplier: Supplier Name';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //_buildProductInfo(),
          const Divider(height: 24, thickness: 1),
          const Text(
            'Choose a Size:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildOptionsList(context),
          ),
        ],
      ),
    );
  }

  // Widget _buildProductInfo() {
  //   return SizedBox(
  //     height: 200,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildProductImage(),
  //         Expanded(
  //           child: _buildProductDetails(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  //
  // Widget _buildProductImage() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(4),
  //       border: Border.all(
  //         color: Colors.grey, // Border color
  //         width: 1, // Border width
  //       ),
  //     ),
  //     child: Image.asset(
  //       productImage,
  //       height: 100,
  //       width: 100,
  //     ),
  //   );
  // }
  //
  // Widget _buildProductDetails() {
  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     // Remove the fixed height
  //     // height: 500,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         _buildProductInfo(),
  //         const Divider(height: 24, thickness: 1),
  //         const Text(
  //           'Choose a Size:',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Expanded(
  //           child: _buildOptionsList(context as BuildContext),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOptionsList(BuildContext context) {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuantityRow(),
                const SizedBox(height: 8),
                _buildPriceInfoRow(),
                const SizedBox(height: 8),
                _buildQuantityDropdown(),
              ],
            ),
            trailing: _buildAddToCartButton(),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildQuantityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityDescription(),
      ],
    );
  }

  Widget _buildQuantityDescription() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quantityDescription,
          style: TextStyle(
            fontSize: 25,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfoRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceText(discountedPrice, 20, Colors.green),
        _buildPriceText(
            originalPrice, 16, Colors.grey, [TextDecoration.lineThrough]),
        _buildDiscountContainer(offPercentage),
      ],
    );
  }

  Widget _buildPriceText(String text, double fontSize, Color color,
      [List<TextDecoration>? decorations]) {
    return Row(
      children: [
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            decoration: decorations != null ? decorations[0] : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildQuantityDropdown() {
    return Row(
      children: [
        const Text('Quantity: '),
        DropdownButton<String>(
          items: ['1', '2', '3', '4', '5'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            // Handle quantity selection
          },
          value: '1', // Set default value or quantity
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement 'Add to Cart' functionality
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff07833D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Add to Cart',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
