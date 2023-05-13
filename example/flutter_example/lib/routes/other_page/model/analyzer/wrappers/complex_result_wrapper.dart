import 'package:equations/equations.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/result_wrapper.dart';

/// Wrapper that holds a series of data about a [Complex] value.
final class ComplexResultWrapper implements ResultWrapper {
  /// The polar representation of the complex number.
  final PolarComplex polarComplex;

  /// The complex conjugate.
  final Complex conjugate;

  /// The complex reciprocal.
  final Complex reciprocal;

  /// The modulus/aboslute value.
  final double abs;

  /// The square root of the complex number.
  final Complex sqrt;

  /// The phase.
  final double phase;

  /// Creates an [ComplexResultWrapper] object..
  const ComplexResultWrapper({
    required this.polarComplex,
    required this.conjugate,
    required this.reciprocal,
    required this.abs,
    required this.sqrt,
    required this.phase,
  });
}
