import 'package:equations_solver/routes/utils/collapsible/collapsible.dart';
import 'package:flutter/material.dart';

/// The secondary region of a [Collapsible] widget.
///
/// This widgets wraps the contents of the [Collapsible].
class SecondaryRegion extends StatelessWidget {
  /// The height between the first and the second regions.
  final double heightBetweenRegions;

  /// The child widget to be inserted in the contents part of the [Collapsible]
  /// widget.
  final Widget child;

  /// Creates a [SecondaryRegion] widget.
  const SecondaryRegion({
    Key? key,
    required this.child,
    required this.heightBetweenRegions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Spacing between the two regions.
        SizedBox(
          height: heightBetweenRegions,
        ),

        // The contents of the second region.
        Row(
          children: [
            Expanded(
              child: child,
            ),
          ],
        ),
      ],
    );
  }
}
