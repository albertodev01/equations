import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/complex_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/matrix_result_wrapper.dart';

/// Interface type for classes that wrap a series of values. There currently are
/// two implementers are:
///
///  - [MatrixResultWrapper]
///  - [ComplexResultWrapper]
abstract interface class ResultWrapper {}
