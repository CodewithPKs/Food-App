import 'package:flutter/cupertino.dart';

import '../../../../constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class KrishiPrimaryHeaderContainer extends StatelessWidget {
  const KrishiPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KrishiCurvedEdgeWidget(
      // child: SizedBox(
      //   height: 300,
        child: Container(
          color: KrishiColors.primary,
          padding: const EdgeInsets.only(bottom: 0),

            child: Stack(
              children: [
                Positioned(
                  top: -150, right: -250, child: KrishiCircularContainer(backgroundColor: KrishiColors.textWhite.withOpacity(0.1),),),
                Positioned(
                  top: 100, right: -300, child: KrishiCircularContainer(backgroundColor: KrishiColors.textWhite.withOpacity(0.1),),),
                child,
              ],
            // ),
        ),
      ),
    );
  }
}