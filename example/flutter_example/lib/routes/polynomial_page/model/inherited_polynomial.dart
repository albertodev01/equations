import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedPolynomial extends InheritedWidget {
  /// The state of the polynomial page.
  final PolynomialState polynomialState;

  /// Creates an [InheritedWidget] that exposes a [PolynomialState] object.
  const InheritedPolynomial({
    super.key,
    required this.polynomialState,
    required super.child,
  });

  static InheritedPolynomial of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedPolynomial>();
    assert(ref != null, "No 'InheritedPolynomial' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedPolynomial oldWidget) {
    return polynomialState != oldWidget.polynomialState;
  }
}

extension InheritedPolynomialExt on BuildContext {
  PolynomialState get polynomialState =>
      InheritedPolynomial.of(this).polynomialState;
}
