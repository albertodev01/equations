import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';

/// This page contains a series of polynomial equations solvers. There are 4
/// tabs dedicated to particular polynomial equations:
///
///  - Linear
///  - Quadratic
///  - Cubic
///  - Quartic
///
/// Each tab also features a [PlotWidget] which plots the function on a
/// cartesian plane.
class PolynomialPage extends StatefulWidget {
  /// Creates a [PolynomialPage] widget.
  const PolynomialPage({super.key});

  @override
  State<PolynomialPage> createState() => _PolynomialPageState();
}

class _PolynomialPageState extends State<PolynomialPage> {
  /*
   * These controllers are exposed to the subtree with [InheritedTextController]
   * because the scaffold uses tabs and when swiping, the controllers get
   * disposed.
   *
   * In order to keep the controllers alive (and thus persist the text), we need
   * to save theme here, which is ABOVE the tabs.
   */

  final linearControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final quadraticControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final cubicControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final quarticControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.firstDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(
          PolynomialType.linear,
        ),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: InheritedTextControllers(
            textControllers: linearControllers,
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.secondDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(
          PolynomialType.quadratic,
        ),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: InheritedTextControllers(
            textControllers: quadraticControllers,
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.thirdDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(
          PolynomialType.cubic,
        ),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: InheritedTextControllers(
            textControllers: cubicControllers,
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.fourthDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(
          PolynomialType.quartic,
        ),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: InheritedTextControllers(
            textControllers: quarticControllers,
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    for (final controller in linearControllers) {
      controller.dispose();
    }

    for (final controller in quadraticControllers) {
      controller.dispose();
    }

    for (final controller in cubicControllers) {
      controller.dispose();
    }

    for (final controller in quarticControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EquationScaffold.navigation(
      navigationItems: cachedItems,
    );
  }
}
