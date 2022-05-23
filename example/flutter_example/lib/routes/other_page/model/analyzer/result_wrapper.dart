import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/complex_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/matrix_result_wrapper.dart';

/// Base abstract type for classes that wrap a series of values. Current
/// subtypes are:
///
///  - [MatrixResultWrapper]
///  - [ComplexResultWrapper]
abstract class ResultWrapper {
  /// Initializes a [ResultWrapper].
  const ResultWrapper();
}
