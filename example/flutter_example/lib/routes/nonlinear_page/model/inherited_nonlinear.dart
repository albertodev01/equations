import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [NonlinearState] object.
class InheritedNonlinear extends InheritedWidget {
  /// The state of the nonlinear solvers page.
  final NonlinearState nonlinearState;

  /// Creates an [InheritedWidget] that exposes a [NonlinearState] object.
  const InheritedNonlinear({
    super.key,
    required this.nonlinearState,
    required super.child,
  });

  /// Retrieves the closest [InheritedNonlinear] instance up in the tree.
  static InheritedNonlinear of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedNonlinear>();
    assert(ref != null, "No 'InheritedNonlinear' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNonlinear oldWidget) {
    return nonlinearState != oldWidget.nonlinearState;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
///[NonlinearState] up in the tree using [InheritedNonlinear].
extension InheritedNonlinearExt on BuildContext {
  /// Uses [InheritedNonlinear] to retrieve a [NonlinearState] object.
  NonlinearState get nonlinearState =>
      InheritedNonlinear.of(this).nonlinearState;
}
