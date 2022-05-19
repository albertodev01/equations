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
import 'package:flutter/material.dart';

import '../mock_wrapper.dart';

Widget mockNonlinearWidget({
  List<TextEditingController> textControllers = const [],
  NonlinearType nonlinearType = NonlinearType.singlePoint,
  Widget child = const NonlinearBody(),
  String? dropdownValue,
}) {
  return MockWrapper(
    child: InheritedNonlinear(
      nonlinearState: NonlinearState(nonlinearType),
      child: InheritedTextControllers(
        textControllers: textControllers,
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier(
              dropdownValue ?? NonlinearDropdownItems.newton.asString(),
            ),
            child: InheritedPrecisionSlider(
              precisionState: PrecisionSliderState(
                minValue: 2,
                maxValue: 10,
              ),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}
