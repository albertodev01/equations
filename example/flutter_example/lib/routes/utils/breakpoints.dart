import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';

/// When the viewport is horizontally smaller than [bottomNavigationBreakpoint],
/// tabs are used. When larger, a navigation rail is shown.
const bottomNavigationBreakpoint = 950.0;

/// When there is more horizontal space than [extraBackgroundBreakpoint], an
/// additional background image is added to the [EquationScaffold] scaffold.
const extraBackgroundBreakpoint = 1300.0;

/// Determines whether the contents should stay on one or two column(s).
const polynomialPageBreakpoint = 1100.0;

/// The maximum size (width and height) of a [PlotWidget].
const maxWidthPlot = 600.0;
