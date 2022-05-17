import 'package:flutter/widgets.dart';

/// TODO
class InheritedNavigation extends InheritedWidget {
  final ValueNotifier<int> navigationIndex;

  /// Creates an [InheritedWidget] that exposes a [ValueNotifier] object.
  const InheritedNavigation({
    super.key,
    required this.navigationIndex,
    required super.child,
  });

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

extension InheritednavigationExt on BuildContext {
  ValueNotifier<int> get navigationIndex =>
      InheritedNavigation.of(this).navigationIndex;
}
