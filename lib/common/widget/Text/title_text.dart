import 'package:flutter/material.dart';


class KrishiProductTitleText extends StatelessWidget {
  const KrishiProductTitleText({
    Key? key,
    required this.title,
    this.smallSize = false,
    this.maxLines = 2,
    this.textAlign,
  }) : super(key: key);

  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    //final textTheme = smallSize ? TTextTheme.lightTextTheme : TTextTheme.lightTextTheme;

    return Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 16),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  TextStyle? _getTextStyle(TextTheme textTheme) {
    return smallSize
        ? textTheme.titleSmall?.copyWith(color: Colors.white)
        : textTheme.titleLarge?.copyWith(color: Colors.white);
  }

}