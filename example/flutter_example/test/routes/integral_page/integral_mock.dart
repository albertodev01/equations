import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:flutter/material.dart';

import '../mock_wrapper.dart';

Widget mockIntegralWidget({
  List<TextEditingController> textControllers = const [],
  Widget child = const IntegralBody(),
  String? dropdownValue,
}) {
  return MockWrapper(
    child: InheritedIntegral(
      integralState: IntegralState(),
      child: InheritedDropdownValue(
        dropdownValue: ValueNotifier<String>(
          dropdownValue ?? IntegralDropdownItems.simpson.asString(),
        ),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: child,
        ),
      ),
    ),
  );
}
