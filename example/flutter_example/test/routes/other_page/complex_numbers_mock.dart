import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:flutter/material.dart';

import '../mock_wrapper.dart';

class MockComplexNumbers extends StatelessWidget {
  /// The [TextEditingController]s for the inputs.
  final List<TextEditingController>? controllers;

  /// Whether initializing the state with mock data
  final bool complexMockData;

  /// The child.
  final Widget child;

  /// Creates a [MockComplexNumbers] widget.
  const MockComplexNumbers({
    super.key,
    this.controllers,
    this.complexMockData = false,
    this.child = const ComplexNumberOtherBody(),
  });

  @override
  Widget build(BuildContext context) {
    final state = OtherState();

    if (complexMockData) {
      state.complexAnalyze(realPart: '-3', imaginaryPart: '5');
    }

    final actualControllers = controllers ??
        [
          TextEditingController(),
          TextEditingController(),
        ];

    return MockWrapper(
      child: InheritedOther(
        otherState: state,
        child: InheritedTextControllers(
          textControllers: actualControllers,
          child: child,
        ),
      ),
    );
  }
}
