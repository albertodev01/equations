import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';

/// A wrapper of [Text] simply stating that no results are available.
class NoResults extends StatelessWidget {
  /// Creates a [NoResults] widget.
  const NoResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 35, 80, 35),
        child: Text(
          context.l10n.no_solutions,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
