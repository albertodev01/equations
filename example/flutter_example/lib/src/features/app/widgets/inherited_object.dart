import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [T] object.
class InheritedObject<T> extends InheritedWidget {
  /// The object exposed to the sub-tree.
  final T object;

  /// Creates an [InheritedWidget] that exposes a [T] object.
  const InheritedObject({
    required this.object,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedObject] instance up in the tree and
  /// returns `null` in case [InheritedObject] is not found.
  static InheritedObject<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedObject<T>>();
  }

  /// Retrieves the closest [InheritedObject] instance up in the tree.
  static InheritedObject<T> of<T>(BuildContext context) {
    final widget = maybeOf<T>(context);
    assert(widget != null, "No 'InheritedObject<T>' found above in the tree.");

    return widget!;
  }

  @override
  bool updateShouldNotify(covariant InheritedObject<T> oldWidget) {
    return object != oldWidget.object;
  }
}
