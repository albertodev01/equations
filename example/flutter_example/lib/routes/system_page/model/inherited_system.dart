import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [SystemState] object.
class InheritedSystem extends InheritedWidget {
  /// The state of the polynomial page.
  final SystemState systemState;

  /// Creates an [InheritedWidget] that exposes a [SystemState] object.
  const InheritedSystem({
    required this.systemState,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedSystem] instance up in the tree.
  static InheritedSystem of(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<InheritedSystem>();
    assert(ref != null, "No 'InheritedSystem' found above in the tree.");

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedSystem oldWidget) {
    return systemState != oldWidget.systemState;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
///[SystemState] up in the tree using [InheritedSystem].
extension InheritedSystemExt on BuildContext {
  /// Uses [InheritedSystem] to retrieve a [SystemState] object.
  SystemState get systemState => InheritedSystem.of(this).systemState;
}
