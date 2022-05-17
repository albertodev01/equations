import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedSystem extends InheritedWidget {
  final SystemState systemState;

  /// Creates an [InheritedWidget] that exposes a [PolynomialState] object.
  const InheritedSystem({
    super.key,
    required this.systemState,
    required super.child,
  });

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

extension InheritedPolynomialExt on BuildContext {
  SystemState get systemState => InheritedSystem.of(this).systemState;
}
