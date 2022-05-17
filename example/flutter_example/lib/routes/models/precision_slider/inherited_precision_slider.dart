import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/precision_slider/precision_slider_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedPrecisionSlider extends InheritedWidget {
  final PrecisionSliderState precisionState;

  /// Creates an [InheritedWidget] that exposes a [NumberSwitcherState] object.
  const InheritedPrecisionSlider({
    super.key,
    required this.precisionState,
    required super.child,
  });

  static InheritedPrecisionSlider of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedPrecisionSlider>();
    assert(ref != null, "No 'InheritedPlotZoom' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedPrecisionSlider oldWidget) {
    return precisionState != oldWidget.precisionState;
  }
}

extension InheritedPrecisionStateExt on BuildContext {
  PrecisionSliderState get precisionState =>
      InheritedPrecisionSlider.of(this).precisionState;
}
