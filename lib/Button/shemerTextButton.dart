import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';



class ShimmerTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double? borderRadius;
  final Widget? customTitle;

  const ShimmerTextButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.width,
    required this.height,
    this.borderRadius,
    this.customTitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.orangeAccent,
              highlightColor: Colors.orange.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
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
                alignment: Alignment.center,
              ),
            ),
            customTitle ?? Text(
              title,
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}