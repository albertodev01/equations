import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget shows a [bool] value into a [Card] widget.
class BoolResultCard extends StatelessWidget {
  /// The value to be displayed.
  final bool value;

  /// Text to be displayed in front of the boolean value.
  final String leading;

  /// Creates a [BoolResultCard] widget.
  const BoolResultCard({
    super.key,
    required this.value,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final localizedValue = value ? context.l10n.yes : context.l10n.no;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: cardWidgetsWidth,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading$localizedValue'),
            ),
          ),
        ),
      ),
    );
  }
}
