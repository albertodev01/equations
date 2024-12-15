import 'package:equations_solver/src/features/app/widgets/equations_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A wrapper of [Scaffold] that is used by [GoRoute] to host a page.
class RouteScaffold extends StatelessWidget {
  /// The scaffold title at the center of the application bar.
  final String title;

  /// The scaffold content.
  final Widget child;

  /// Creates a [RouteScaffold] widget.
  const RouteScaffold({
    required this.title,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EquationsAppBar(title: title),
      body: child,
    );
  }
}
