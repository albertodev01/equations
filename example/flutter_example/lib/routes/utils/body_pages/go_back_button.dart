import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This button simply goes back to the previous page.
class GoBackButton extends StatelessWidget {
  /// Creates a [GoBackButton] widget.
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      splashRadius: 24,
      onPressed: () => context.pop(),
    );
  }
}
