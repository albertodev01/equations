import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedNumberSwitcher extends InheritedWidget {
  final NumberSwitcherState numberSwitcherState;

  /// Creates an [InheritedWidget] that exposes a [NumberSwitcherState] object.
  const InheritedNumberSwitcher({
    super.key,
    required this.numberSwitcherState,
    required super.child,
  });

  static InheritedNumberSwitcher of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedNumberSwitcher>();
    assert(
      ref != null,
      "No 'InheritedNumberSwitcher' found above in the tree.",
    );
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNumberSwitcher oldWidget) {
    return numberSwitcherState != oldWidget.numberSwitcherState;
  }
}

extension InheritedNonlinearExt on BuildContext {
  NumberSwitcherState get numberSwitcherState =>
      InheritedNumberSwitcher.of(this).numberSwitcherState;
}
