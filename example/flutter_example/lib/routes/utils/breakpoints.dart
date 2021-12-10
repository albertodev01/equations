import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_analyzer_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';

/// When the viewport is horizontally smaller than [bottomNavigationBreakpoint],
/// tabs are used. When larger, a navigation rail is shown.
const bottomNavigationBreakpoint = 950.0;

/// When there is more horizontal space than [extraBackgroundBreakpoint], an
/// additional background image is added to the [EquationScaffold] scaffold.
const extraBackgroundBreakpoint = 1300.0;

/// Determines whether the contents should stay on one or two column(s).
const doubleColumnPageBreakpoint = 1100.0;

/// The maximum size (width and height) of a [PlotWidget].
const maxWidthPlot = 600.0;

/// Determines whether the [MatrixAnalyzerResults] widget should show data in
/// one or two columns.
const matricesPageDoubleColumn = 1200.0;

/// The width of a single column in the [MatrixAnalyzerResults] page when there
/// are multiple columns in the page.
///
/// We want to add a padding of `30` on both sides, hence the `30 * 2`.
const matricesPageColumnWidth = cardWidgetsWidth + 30 * 2;

/// The width of a single column in the [ComplexNumberAnalyzerResult] page when
/// there are multiple columns in the page.
///
/// We want to add a padding of `30` on both sides, hence the `30 * 2`.
const complexPageColumnWidth = cardWidgetsWidth + 30 * 2;

/// The width of the cards widgets: [RealResultCard], [ComplexResultCard] and
/// [BoolResultCard].
const cardWidgetsWidth = 275.0;
