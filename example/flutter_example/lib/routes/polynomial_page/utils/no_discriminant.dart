import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';

/// A very simple widget stating that there is no discriminant value to display.
class NoDiscriminant extends StatelessWidget {
  /// Creates a [NoDiscriminant] widget.
  const NoDiscriminant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 35, 80, 15),
        child: Text(
          context.l10n.no_discriminant,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
