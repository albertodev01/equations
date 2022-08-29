import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

/// An [InheritedWidget] that exposes a [ValueNotifier] object.
class InheritedNavigation extends InheritedWidget {
  /// The non-empty list of navigation items.
  final List<NavigationItem> navigationItems;

  /// The optional [FloatingActionButton].
  final FloatingActionButton? fab;

  /// The [TabController] that drives the tab positioning and animation.
  final TabController tabController;

  /// The navigation state.
  final ValueNotifier<int> navigationIndex;

  /// Creates an [InheritedWidget] that exposes a [ValueNotifier] object.
  const InheritedNavigation({
    required this.navigationIndex,
    required this.navigationItems,
    required this.fab,
    required this.tabController,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedNavigation] instance up in the tree.
  static InheritedNavigation of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedNavigation>();
    assert(ref != null, "No 'InheritedNavigation' found above in the tree.");

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNavigation oldWidget) {
    return navigationIndex != oldWidget.navigationIndex;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
/// [InheritedNavigation] up in the tree using the [BuildContext].
extension InheritednavigationExt on BuildContext {
  /// Uses [BuildContext] to retrieve a [InheritedNavigation] object.
  InheritedNavigation get inheritedNavigation => InheritedNavigation.of(this);
}
