import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

/// This page contains a series of interpolation algorithms. The page contains
/// a series of inputs for the (x, y) points and a chart that plots the points.
class InterpolationPage extends StatefulWidget {
  /// Creates a [InterpolationPage] widget.
  const InterpolationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<InterpolationPage> createState() => _InterpolationPageState();
}

class _InterpolationPageState extends State<InterpolationPage> {
  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.linear,
      content: const Text('Linear approximation'),
    ),
    const NavigationItem(
      title: 'Lagrange',
      content: Text('Lagrange approximation'),
    ),
    const NavigationItem(
      title: 'Newton',
      content: Text('Newton approximation'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return EquationScaffold.navigation(
      navigationItems: cachedItems,
    );
  }
}
