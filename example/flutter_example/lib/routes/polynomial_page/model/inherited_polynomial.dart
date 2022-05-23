import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [PolynomialState] object.
class InheritedPolynomial extends InheritedWidget {
  /// The state of the polynomial page.
  final PolynomialState polynomialState;

  /// Creates an [InheritedWidget] that exposes a [PolynomialState] object.
  const InheritedPolynomial({
    super.key,
    required this.polynomialState,
    required super.child,
  });

  /// Retrieves the closest [InheritedPolynomial] instance up in the tree.
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

/// Extension method on [BuildContext] that allows getting a reference to the
///[PolynomialState] up in the tree using [InheritedPolynomial].
extension InheritedPolynomialExt on BuildContext {
  /// Uses [InheritedPolynomial] to retrieve a [PolynomialState] object.
  PolynomialState get polynomialState =>
      InheritedPolynomial.of(this).polynomialState;
}
