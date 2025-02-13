import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';



class KrishiCircularIcon extends StatelessWidget {
  const KrishiCircularIcon({
    super.key,
    this.width,
    this.height,
    this.size=KrishiSizes.lg,
    required this.icon,
    this.onPressed,
    this.color, this.backgroundcolor,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundcolor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundcolor !=null
          ? backgroundcolor!
        :KrishiColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: color, size: size,),),
    );
  }
}