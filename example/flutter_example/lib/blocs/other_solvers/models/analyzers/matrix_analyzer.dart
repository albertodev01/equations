import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';

/// Analyzes a matrix and computes various results:
///
///  - the transposed matrix
///  - the cofactor matrix
///  - the inverse matrix
///  - the trace
///  - the rank
///  - the characteristic polynomial
///  - the eigenvalues
///  - the determinant
class MatrixDataAnalyzer extends Analyzer<AnalyzedMatrix> {
  /// The size of the matrix.
  final int size;

  /// The flattened representation of the matrix.
  final List<String> flatMatrix;

  /// Creates a [MatrixDataAnalyzer] object.
  const MatrixDataAnalyzer({
    required this.size,
    required this.flatMatrix,
  });

  @override
  AnalyzedMatrix process() {
    // Building the matrix
    final data = valuesParser(flatMatrix);
    final matrix = RealMatrix.fromFlattenedData(
      rows: size,
      columns: size,
      data: data,
    );

    return AnalyzedMatrix(
      transpose: matrix.transpose(),
      cofactorMatrix: matrix.cofactorMatrix(),
      inverse: matrix.inverse(),
      trace: matrix.trace(),
      rank: matrix.rank(),
      characteristicPolynomial: matrix.characteristicPolynomial(),
      eigenvalues: matrix.eigenvalues(),
      determinant: matrix.determinant(),
    );
  }

  @override
  List<Object?> get props => [
        size,
        flatMatrix,
      ];
}
