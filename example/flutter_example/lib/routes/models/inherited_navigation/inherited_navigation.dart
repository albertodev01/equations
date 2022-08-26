import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [ValueNotifier] object.
class InheritedNavigation extends InheritedWidget {
  /// The navigation state.
  final ValueNotifier<int> navigationIndex;

  /// Creates an [InheritedWidget] that exposes a [ValueNotifier] object.
  const InheritedNavigation({
    required this.navigationIndex,
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
/// [ValueNotifier] up in the tree using [InheritedNavigation].
extension InheritednavigationExt on BuildContext {
  /// Uses [InheritedNavigation] to retrieve a [ValueNotifier] object.
  ValueNotifier<int> get navigationIndex =>
      InheritedNavigation.of(this).navigationIndex;
}
