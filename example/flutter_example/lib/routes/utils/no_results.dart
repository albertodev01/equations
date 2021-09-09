import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';

/// A very simple widget that simply states inside a [Text] that there are no
/// results to display.
class NoResults extends StatelessWidget {
  /// Creates a [NoResults] widget.
  const NoResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 35, 80, 15),
        child: Text(
          context.l10n.no_solutions,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
