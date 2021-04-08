import 'package:flutter/material.dart';
import 'package:equations_solver/localization/localization.dart';

/// A very simple widget that simply states inside a [Text] that there is no
/// discriminant value to display.
class NoDiscriminant extends StatelessWidget {
  /// Creates a [NoDiscriminant] widget.
  const NoDiscriminant();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 35, 80, 65),
        child: Text(
          context.l10n.no_discriminant,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
