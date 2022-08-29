import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/scaffold_contents.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';

/// The bottom navigation view of the [EquationScaffold] used when the viewport
/// is small enough.
class BottomNavigationWidget extends StatelessWidget {
  /// Creates a [BottomNavigationWidget] widget.
  const BottomNavigationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('TabbedNavigationLayout-Scaffold'),
      body: const ScaffoldContents(
        body: TabbedNavigationLayout(),
      ),
      bottomNavigationBar: BottomNavigation(
        navigationItems: context.inheritedNavigation.navigationItems,
      ),
      floatingActionButton: context.inheritedNavigation.fab,
    );
  }
}
