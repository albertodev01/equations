import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/utils/plot_widget/equation_drawer_widget.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [PlotZoomState] object.
class InheritedPlotZoom extends InheritedWidget {
  /// The zoom state of a [EquationDrawerWidget].
  final PlotZoomState plotZoomState;

  /// Creates an [InheritedWidget] that exposes a [PlotZoomState] object.
  const InheritedPlotZoom({
    required this.plotZoomState,
    required super.child,
    super.key,
  });

  /// Retrieves the closest [InheritedPlotZoom] instance up in the tree.
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

/// Extension method on [BuildContext] that allows getting a reference to the
/// [PlotZoomState] up in the tree using [InheritedPlotZoomExt].
extension InheritedPlotZoomExt on BuildContext {
  /// Uses [InheritedPlotZoomExt] to retrieve a [PlotZoomState] object.
  PlotZoomState get plotZoomState => InheritedPlotZoom.of(this).plotZoomState;
}
