import 'package:flutter/cupertino.dart';

import 'curved_edges.dart';

class KrishiCurvedEdgeWidget extends StatelessWidget {
  const KrishiCurvedEdgeWidget({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: KrishiCustomCurvedEdges(),
      child: child,
    );
  }
}
