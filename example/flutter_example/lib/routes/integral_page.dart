import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// This page contains a series of integral evaluation algorithms. There only
/// is a single page where the user writes the equation and chooses the
/// algorithm to evaluate the integral.
///
/// The function is drawn on a cartesian plane and the area is highlighted.
class IntegralPage extends StatefulWidget {
  /// Creates a [IntegralPage] widget.
  const IntegralPage({super.key});

  @override
  State<IntegralPage> createState() => _IntegralPageState();
}

class _IntegralPageState extends State<IntegralPage> {
  /*
   * These controllers are exposed to the subtree with [InheritedTextController]
   * because the scaffold uses tabs and when swiping, the controllers get
   * disposed.
   *
   * In order to keep the controllers alive (and thus persist the text), we need
   * to save theme here, which is ABOVE the tabs.
   */
  final integralControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (final controller in integralControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedIntegral(
      integralState: IntegralState(),
      child: InheritedDropdownValue(
        dropdownValue: ValueNotifier<String>(
          IntegralDropdownItems.simpson.name,
        ),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: InheritedTextControllers(
            textControllers: integralControllers,
            child: const EquationScaffold(
              body: IntegralBody(),
            ),
          ),
        ),
      ),
    );
  }
}
