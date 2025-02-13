import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';


class DiscountCard extends StatefulWidget {

  final VoidCallback applyCoupon;
  final bool isCouponEnabled;
  final String couponTitle;
  final String couponDescription;

  const DiscountCard({
    super.key,
    required this.applyCoupon,
    required this.isCouponEnabled,
    required this.couponTitle,
    required this.couponDescription,
  });

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.applyCoupon,
      child: Padding(
        padding: const EdgeInsets.only(right: 25, left: 5, top: 5),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _CustomDashedBorderPainter(_controller.value * 14),
              child: child,
            );
          },
          child: Container(
            height: double.minPositive,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: KrishiColors.light,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(KrishiSizes.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: KrishiColors.primary,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.yellow,
                            Colors.orange,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Flexible(
                            child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(right: 5),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(
                                  widget.couponTitle,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: KrishiColors.primary,
                                    letterSpacing: 5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),

                          Icon(
                            Icons.discount_sharp,
                            color: Colors.white,
                            size: KrishiSizes.iconLg,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: KrishiSizes.md,
                        vertical: KrishiSizes.sm,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.couponDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (!widget.isCouponEnabled)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text(
                          "Not Applicable",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _CustomDashedBorderPainter extends CustomPainter {

  final double phase;

  _CustomDashedBorderPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = KrishiColors.orangeLight
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final dashWidth = 8.0;
    final dashSpace = 6.0;
    final totalDashWidth = dashWidth + dashSpace;

    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    );

    final path = Path()..addRRect(rrect);

    final dashPath = Path();
    final metrics = path.computeMetrics().first;
    double distance = -phase % totalDashWidth;

    while (distance < metrics.length) {
      final start = distance;
      final end = (distance + dashWidth).clamp(0.0, metrics.length);
      dashPath.addPath(metrics.extractPath(start, end), Offset.zero);
      distance += totalDashWidth;
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CustomDashedBorderPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}