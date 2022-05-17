import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedNonlinear extends InheritedWidget {
  /// The state of the polynomial page.
  final NonlinearState nonlinearState;

  /// Creates an [InheritedWidget] that exposes a [NonlinearState] object.
  const InheritedNonlinear({
    super.key,
    required this.nonlinearState,
    required super.child,
  });

  static InheritedNonlinear of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedNonlinear>();
    assert(ref != null, "No 'InheritedPolynomial' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNonlinear oldWidget) {
    return nonlinearState != oldWidget.nonlinearState;
  }
}

extension InheritedNonlinearExt on BuildContext {
  NonlinearState get nonlinearState =>
      InheritedNonlinear.of(this).nonlinearState;
}
