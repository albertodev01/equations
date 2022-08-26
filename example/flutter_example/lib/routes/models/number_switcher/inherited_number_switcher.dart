import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [NumberSwitcherState] object.
class InheritedNumberSwitcher extends InheritedWidget {
  /// The number switcher state.
  final NumberSwitcherState numberSwitcherState;

  /// Creates an [InheritedWidget] that exposes a [NumberSwitcherState] object.
  const InheritedNumberSwitcher({
    required this.numberSwitcherState,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedNumberSwitcher] instance up in the tree.
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

/// Extension method on [BuildContext] that allows getting a reference to the
/// [ValueNotifier] up in the tree using [NumberSwitcherState].
extension InheritedNonlinearExt on BuildContext {
  /// Uses [InheritedNumberSwitcher] to retrieve a [ValueNotifier] object.
  NumberSwitcherState get numberSwitcherState =>
      InheritedNumberSwitcher.of(this).numberSwitcherState;
}
