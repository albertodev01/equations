import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/analyzers/complex_analyzer.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/analyzers/matrix_analyzer.dart';
import 'package:equations_solver/routes/other_page/model/other_result.dart';
import 'package:flutter/widgets.dart';

/// Holds the state of the [OtherPage] page.
class OtherState extends ChangeNotifier {
  var _state = const OtherResult();

  /// The current state.
  OtherResult get state => _state;

  /// Analyzes a matrix from a series of String coefficients.
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

      _state = OtherResult(
        results: resultWrapper,
      );
    } on Exception {
      _state = const OtherResult();
    }

    notifyListeners();
  }

  /// Analyzes a complex number parsing the real and the imaginary parts.
  void complexAnalyze({
    required String realPart,
    required String imaginaryPart,
  }) {
    try {
      final resultWrapper = ComplexNumberAnalyzer(
        realPart: realPart,
        imaginaryPart: imaginaryPart,
      ).process();

      _state = OtherResult(
        results: resultWrapper,
      );
    } on Exception {
      _state = const OtherResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    _state = const OtherResult();
    notifyListeners();
  }
}
