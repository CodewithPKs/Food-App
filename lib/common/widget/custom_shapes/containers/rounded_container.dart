
import 'package:flutter/cupertino.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';


class KrishiRoundedContainer extends StatelessWidget {
  const KrishiRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius=   KrishiSizes.cardRadiusLg,
    this.child,
    this.showBorder  =false,
    this.borderColor=KrishiColors.borderPrimary,
    this.margin,
    this.padding,
    this.backgroundColor = KrishiColors.white, this.gradient,
  });

  final double? width;
  final double? height;
  final double radius;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        gradient: gradient,
      ),
      child: child,
    );
  }
}
