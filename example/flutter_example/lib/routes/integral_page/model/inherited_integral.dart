import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedIntegral extends InheritedWidget {
  final IntegralState integralState;

  /// Creates an [InheritedWidget] that exposes a [NonlinearState] object.
  const InheritedIntegral({
    super.key,
    required this.integralState,
    required super.child,
  });

  static InheritedIntegral of(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<InheritedIntegral>();
    assert(ref != null, "No 'InheritedIntegral' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedIntegral oldWidget) {
    return integralState != oldWidget.integralState;
  }
}

extension InheritedNonlinearExt on BuildContext {
  IntegralState get integralState => InheritedIntegral.of(this).integralState;
}
