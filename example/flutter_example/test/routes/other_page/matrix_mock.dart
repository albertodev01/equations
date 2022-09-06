import 'package:equations/equations.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/matrix_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:flutter/material.dart';

import '../mock_wrapper.dart';

class MockMatrixOther extends StatelessWidget {
  /// Returns a pre-built [MatrixResultWrapper] object.
  static MatrixResultWrapper mockMatrixResult() {
    return MatrixResultWrapper(
      eigenvalues: const [
        Complex.fromReal(5.37288),
        Complex.fromReal(-0.372281),
      ],
      rank: 2,
      determinant: -2,
      trace: 5,
      inverse: RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          -2,
          1,
          1.5,
          -0.5,
        ],
      ),
      cofactorMatrix: RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          4,
          -3,
          -2,
          1,
        ],
      ),
      transpose: RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          1,
          3,
          2,
          4,
        ],
      ),
      characteristicPolynomial: Algebraic.fromReal([1, -5, -2]),
      isIdentity: true,
      isDiagonal: true,
      isSymmetric: false,
    );
  }

  /// The [TextEditingController]s for the inputs.
  final List<TextEditingController>? controllers;

  /// The minimum value of the [NumberSwitcherState].
  final int min;

  /// Whether initializing the state with mock data
  final bool matrixMockData;

  /// The child.
  final Widget child;

  /// Creates a [MockMatrixOther] widget.
  const MockMatrixOther({
    super.key,
    this.min = 1,
    this.matrixMockData = false,
    this.child = const MatrixOtherBody(),
    this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    final state = OtherState();

    if (matrixMockData) {
      state.matrixAnalyze(
        matrix: const ['-2', '5', '1', '3'],
        size: 2,
      );
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
          child: InheritedNumberSwitcher(
            numberSwitcherState: NumberSwitcherState(
              min: min,
              max: 4,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
