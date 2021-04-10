import 'package:flutter/material.dart';

/// This button simply goes back to the previous page.
class GoBackButton extends StatelessWidget {
  /// Creates a [_GoBackButton] widget.
  const GoBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
