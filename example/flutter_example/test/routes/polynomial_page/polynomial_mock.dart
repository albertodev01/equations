import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter/material.dart';

import '../mock_wrapper.dart';

class MockPolynomialWidget extends StatelessWidget {
  final List<TextEditingController> textControllers;
  final PolynomialType polynomialType;
  final Widget child;
  const MockPolynomialWidget({
    super.key,
    required this.textControllers,
    this.polynomialType = PolynomialType.linear,
    this.child = const PolynomialBody(),
  });

  @override
  Widget build(BuildContext context) {
    return MockWrapper(
      child: InheritedPolynomial(
        polynomialState: PolynomialState(polynomialType),
        child: InheritedTextControllers(
          textControllers: textControllers,
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
}
