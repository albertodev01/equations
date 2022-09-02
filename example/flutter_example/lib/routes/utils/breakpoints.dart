import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_analyzer_results.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_input.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_output.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/plot_widget/equation_drawer_widget.dart';
import 'package:equations_solver/routes/utils/result_cards/bool_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';

/// When the viewport is horizontally smaller than [bottomNavigationBreakpoint],
/// tabs are used. When larger, a navigation rail is shown.
const bottomNavigationBreakpoint = 950.0;

/// When there is more horizontal space than [extraBackgroundBreakpoint], an
/// additional background image is added to the [EquationScaffold] scaffold.
const extraBackgroundBreakpoint = 1300.0;

/// Determines whether the contents should stay on one or two column(s).
const doubleColumnPageBreakpoint = 1100.0;

/// The maximum size (width and height) of a [EquationDrawerWidget].
const maxWidthPlot = 600.0;

/// The minimum available space required to show the chart.
const minimumChartWidth = 350;

/// The width of a single column in the [MatrixAnalyzerResults] page when there
/// are multiple columns in the page.
///
/// We want to add a padding of `30` on both sides, hence the `30 * 2`.
const matricesPageColumnWidth = cardWidgetsWidth + 30 * 2;

/// The width of a single column in the [ComplexNumberAnalyzerResult] page when
/// there are multiple columns in the page.
///
/// We want to add a padding of `30` on both sides, hence the `30 * 2`.
const complexNumbersPageColumnWidth = cardWidgetsWidth + 30 * 2;

/// The width of the cards widgets: [RealResultCard], [ComplexResultCard] and
/// [BoolResultCard].
const cardWidgetsWidth = 275.0;

/// The width of a [PolynomialInputField] widget.
const polynomialInputFieldWidth = 70.0;

/// The width of dropdown boxes in the [NonlinearBody] page
const nonlinearDropdownWidth = 200.0;

/// The width of dropdown boxes in the [SystemBody] page
const systemDropdownWidth = 250.0;

/// The width of dropdown boxes in the [IntegralBody] page
const integralDropdownWidth = 200.0;

/// The width of a [PrecisionSlider] widget.
const precisonSliderWidth = 300.0;

/// The width of a [SystemInputField] widget.
const systemInputFieldSize = 60.0;

/// The length of an [EquationInput] widget used inside a [NonlinearDataInput]
/// to parse the algorithm values.
const nonlinearValuesWidth = 80.0;

/// The length of an [EquationInput] widget used inside a [IntegralDataInput] to
/// parse the values of the lower and upper integration limits.
const integrationBoundsWidth = 80.0;

/// The width of the [ComplexNumberInput] input widgets.
const complexInputWidth = 65.0;

/// The width of a [TableRow] in the [MatrixOutput] widget.
const matrixOutputWidth = 70.0;
