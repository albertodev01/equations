import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedOther extends InheritedWidget {
  /// The state of the polynomial page.
  final OtherState otherState;

  /// Creates an [InheritedWidget] that exposes a [PolynomialState] object.
  const InheritedOther({
    super.key,
    required this.otherState,
    required super.child,
  });

  static InheritedOther of(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<InheritedOther>();
    assert(ref != null, "No 'InheritedOther' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedOther oldWidget) {
    return otherState != oldWidget.otherState;
  }
}

extension InheritedOtherExt on BuildContext {
  OtherState get otherState => InheritedOther.of(this).otherState;
}
