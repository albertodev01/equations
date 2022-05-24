import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/models/precision_slider/inherited_precision_slider.dart';
import 'package:equations_solver/routes/models/precision_slider/precision_slider_state.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';

/// This page contains a series of nonlinear equations solvers. There are 2 tabs
/// that group a series of well-known root finding algorithms:
///
///  - Single point methods (like Newton's method)
///  - Bracketing methods (like secant method or bisection)
///
/// Each tab also features a [PlotWidget] which plots the function on a
/// cartesian plane.
class NonlinearPage extends StatefulWidget {
  /// Creates a [NonlinearPage] widget.
  const NonlinearPage({super.key});

  @override
  _NonlinearPageState createState() => _NonlinearPageState();
}

class _NonlinearPageState extends State<NonlinearPage> {
  /*
   * These controllers are exposed to the subtree with [InheritedTextController]
   * because the scaffold uses tabs and when swiping, the controllers get
   * disposed.
   *
   * In order to keep the controllers alive (and thus persist the text), we need
   * to save theme here, which is ABOVE the tabs.
   */

  final singlePointControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final bracketingControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.single_point,
      content: InheritedNonlinear(
        nonlinearState: NonlinearState(NonlinearType.singlePoint),
        child: InheritedDropdownValue(
          dropdownValue: ValueNotifier<String>(
            NonlinearDropdownItems.newton.name,
          ),
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 2,
              maxValue: 10,
              initial: 3,
            ),
            child: InheritedPrecisionSlider(
              precisionState: PrecisionSliderState(minValue: 1, maxValue: 15),
              child: InheritedTextControllers(
                textControllers: singlePointControllers,
                child: const NonlinearBody(
                  key: Key('NonlinearPage-SinglePoint-Body'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.bracketing,
      content: InheritedNonlinear(
        nonlinearState: NonlinearState(NonlinearType.bracketing),
        child: InheritedDropdownValue(
          dropdownValue: ValueNotifier<String>(
            NonlinearDropdownItems.bisection.name,
          ),
          child: InheritedPlotZoom(
            plotZoomState: PlotZoomState(
              minValue: 2,
              maxValue: 10,
              initial: 3,
            ),
            child: InheritedPrecisionSlider(
              precisionState: PrecisionSliderState(minValue: 1, maxValue: 15),
              child: InheritedTextControllers(
                textControllers: bracketingControllers,
                child: const NonlinearBody(
                  key: Key('NonlinearPage-Bracketing-Body'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    for (final controller in singlePointControllers) {
      controller.dispose();
    }

    for (final controller in bracketingControllers) {
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
