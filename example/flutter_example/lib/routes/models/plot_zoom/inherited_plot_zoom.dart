import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:flutter/widgets.dart';

/// TODO
class InheritedPlotZoom extends InheritedWidget {
  final PlotZoomState plotZoomState;

  /// Creates an [InheritedWidget] that exposes a [NumberSwitcherState] object.
  const InheritedPlotZoom({
    super.key,
    required this.plotZoomState,
    required super.child,
  });

  static InheritedPlotZoom of(BuildContext context) {
    final ref = context.dependOnInheritedWidgetOfExactType<InheritedPlotZoom>();
    assert(ref != null, "No 'InheritedPlotZoom' found above in the tree.");
    return ref!;
  }

  @override
  bool updateShouldNotify(covariant InheritedPlotZoom oldWidget) {
    return plotZoomState != oldWidget.plotZoomState;
  }
}

extension InheritedPlotZoomExt on BuildContext {
  PlotZoomState get plotZoomState => InheritedPlotZoom.of(this).plotZoomState;
}
