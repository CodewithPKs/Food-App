import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Widget? titleWidget;
  final bool isLoading;
  final double? width;
  final double? height;

  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.title,
    this.titleWidget,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width - 30,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.orangeAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          color: Colors.transparent,
        ),
        child: titleWidget ??
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
    );
  }

  static TextStyle getTitleStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}

