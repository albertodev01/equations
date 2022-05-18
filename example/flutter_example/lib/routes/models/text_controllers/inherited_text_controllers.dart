import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedTextControllers extends InheritedWidget {
  final List<TextEditingController> textControllers;

  /// Creates an [InheritedWidget] that exposes a [NumberSwitcherState] object.
  const InheritedTextControllers({
    super.key,
    required this.textControllers,
    required super.child,
  });

  static InheritedTextControllers of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedTextControllers>();
    assert(
        ref != null, "No 'InheritedTextControllers' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedTextControllers oldWidget) {
    return textControllers != oldWidget.textControllers;
  }
}

extension InheritedTextControllersExt on BuildContext {
  List<TextEditingController> get textControllers =>
      InheritedTextControllers.of(this).textControllers;
}
