import 'package:flutter/material.dart';

import '../controller/cart_provider.dart';

class CustomerCountingCard extends StatelessWidget {

  final CartProvider provider;

  const CustomerCountingCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: provider.fetchCustomCounting(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return provider.countingImage != null && provider.countingText != null
              ?
            _buildCountingCard(
              context: context,
              countingText: provider.countingText!,
              countingImage: provider.countingImage!
            )
              :
            const SizedBox();
          }
          else if (snapshot.hasError) {
            return const SizedBox();
          }
          else if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }

          Map<String, dynamic> data = snapshot.data!;

          String countingText = data['text'] ?? '';
          String countingImage = data['image'] ?? '';

          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.setCountingData(countingText, countingImage);
          });

          return _buildCountingCard(
            context: context,
            countingText: countingText,
            countingImage: countingImage
          );
        }
    );
  }

  Widget _buildCountingCard({required BuildContext context, required String countingText, required String countingImage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          countingText,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.orange,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 15),

        Image.network(
          countingImage,
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.75,
          errorBuilder: (context, error, stace) {
            return const SizedBox();
          },
        )
      ],
    );
  }
}
