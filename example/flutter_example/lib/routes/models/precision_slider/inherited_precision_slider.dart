import 'package:equations_solver/routes/models/precision_slider/precision_slider_state.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [PrecisionSliderState] object.
class InheritedPrecisionSlider extends InheritedWidget {
  /// The slider state.
  final PrecisionSliderState precisionState;

  /// Creates an [InheritedWidget] that exposes a [PrecisionSliderState] object.
  const InheritedPrecisionSlider({
    super.key,
    required this.precisionState,
    required super.child,
  });

  /// Retrieves the closest [InheritedPrecisionSlider] instance up in the tree.
  static InheritedPrecisionSlider of(BuildContext context) {
    final ref =
        context.dependOnInheritedWidgetOfExactType<InheritedPrecisionSlider>();
    assert(
      ref != null,
      "No 'InheritedPrecisionSlider' found above in the tree.",
    );

    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedPrecisionSlider oldWidget) {
    return precisionState != oldWidget.precisionState;
  }
}

/// Extension method on [BuildContext] that allows getting a reference to the
/// [PrecisionSliderState] up in the tree using [InheritedPrecisionSlider].
extension InheritedPrecisionStateExt on BuildContext {
  /// Uses [InheritedPrecisionSlider] to retrieve a [PrecisionSliderState]
  /// object.
  PrecisionSliderState get precisionState =>
      InheritedPrecisionSlider.of(this).precisionState;
}
