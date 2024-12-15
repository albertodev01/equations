import 'package:equations_solver/src/features/app/models/breakpoints.dart';
import 'package:equations_solver/src/features/app/routes/routes.dart';
import 'package:equations_solver/src/features/app/widgets/equations_app_bar.dart';
import 'package:equations_solver/src/features/app/widgets/equations_bottom_navigation.dart';
import 'package:equations_solver/src/features/app/widgets/equations_drawer.dart';
import 'package:equations_solver/src/features/app/widgets/equations_rail_navigation.dart';
import 'package:equations_solver/src/features/app/widgets/inherited_object.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A wrapper of [Scaffold] that is used by [ShellRoute] to host a page with a
/// bottom navigation.
class ShellRouteScaffold extends StatefulWidget {
  /// The scaffold title at the center of the application bar.
  final String title;

  /// The scaffold content.
  final Widget child;

  /// Creates a [ShellRouteScaffold] widget.
  const ShellRouteScaffold({
    required this.title,
    required this.child,
    super.key,
  });

  @override
  State<ShellRouteScaffold> createState() => _ShellRouteScaffoldState();
}

class _ShellRouteScaffoldState extends State<ShellRouteScaffold> {
  final selectedTab = ValueNotifier<int>(0);

  bool desktopBreakpointCheck(BoxConstraints constraints) {
    return constraints.maxWidth >= desktopNavigationBarBreakpoint;
  }

  @override
  void initState() {
    super.initState();

    selectedTab.addListener(() async {
      switch (selectedTab.value) {
        case 0:
          await context.push(homeRoute);
        case 1:
          await context.push(nonlinearRoute);
        case 2:
          await context.push(systemsRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = EquationsAppBar(
      title: widget.title,
    );

    return InheritedObject<ValueNotifier<int>>(
      object: selectedTab,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = desktopBreakpointCheck(constraints);

          return Scaffold(
            appBar: appBar,
            drawer: const EquationsDrawer(),
            body: Row(
              children: [
                Expanded(
                  child: widget.child,
                ),
                if (isDesktop) const EquationsRailNavigation(),
              ],
            ),
            bottomNavigationBar:
                isDesktop ? null : const EquationsBottomNavigation(),
          );
        },
      ),
    );
  }
}
