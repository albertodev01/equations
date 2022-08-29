import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/scaffold_contents.dart';
import 'package:flutter/material.dart';

/// The rail navigation view of the [EquationScaffold] used when the viewport
/// is big enough.
class RailNavigationWidget extends StatelessWidget {
  /// Creates a [RailNavigationWidget] widget.
  const RailNavigationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('RailNavigationLayout-Scaffold'),
      body: ScaffoldContents(
        body: RailNavigation(
          tabController: context.inheritedNavigation.tabController,
          navigationItems: context.inheritedNavigation.navigationItems,
        ),
      ),
      floatingActionButton: context.inheritedNavigation.fab,
    );
  }
}
