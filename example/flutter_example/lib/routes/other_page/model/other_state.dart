import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/analyzers/complex_analyzer.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/analyzers/matrix_analyzer.dart';
import 'package:equations_solver/routes/other_page/model/other_result.dart';
import 'package:flutter/widgets.dart';

/// Holds the state of the [OtherPage] page.
class OtherState extends ChangeNotifier {
  var state = const OtherResult();

  /// Tries to solve a polynomial equation with the given coefficients.
  void matrixAnalyze({
    required List<String> matrix,
    required int size,
  }) {
    try {
      // Parsing coefficients
      final resultWrapper = MatrixDataAnalyzer(
        flatMatrix: matrix,
        size: size,
      ).process();

      state = OtherResult(
        results: resultWrapper,
      );
    } on Exception {
      state = const OtherResult();
    }

    notifyListeners();
  }

  void complexAnalyze({
    required String realPart,
    required String imaginaryPart,
  }) {
    try {
      final resultWrapper = ComplexNumberAnalyzer(
        realPart: realPart,
        imaginaryPart: imaginaryPart,
      ).process();

      state = OtherResult(
        results: resultWrapper,
      );
    } on Exception {
      state = const OtherResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    state = const OtherResult();
    notifyListeners();
  }
}
