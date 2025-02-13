import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';



class KrishiShadowStyle{

  static final verticalProductShadow = BoxShadow(
    color: KrishiColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadow = BoxShadow(
    color: KrishiColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}