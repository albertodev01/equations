import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [IntegralState] object.
class InheritedIntegral extends InheritedWidget {
  /// The state of the numerical integration page.
  final IntegralState integralState;

  /// Creates an [InheritedWidget] that exposes a [IntegralState] object.
  const InheritedIntegral({
    super.key,
    required this.integralState,
    required super.child,
  });

  /// Retrieves the closest [InheritedIntegral] instance up in the tree.
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

/// Extension method on [BuildContext] that allows getting a reference to the
///[IntegralState] up in the tree using [InheritedIntegral].
extension InheritedNonlinearExt on BuildContext {
  /// Uses [InheritedIntegral] to retrieve a [IntegralState] object.
  IntegralState get integralState => InheritedIntegral.of(this).integralState;
}
