import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';


class KrishiRoundedImage extends StatelessWidget {
  const KrishiRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = KrishiSizes.sm,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: applyImageRadius
                  ? BorderRadius.circular(borderRadius)
                  : BorderRadius.zero,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: fit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
