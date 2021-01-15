import 'package:equations/equations.dart';

/// TODO
abstract class QRDecomposition<T, R> {
  /// TODO
  final Matrix<T> source;

  /// TODO
  const QRDecomposition(this.source);

  /// TODO
  T getDataAt(List<T> matrix, int row, int col) =>
      matrix[source.columnCount * row + col];

  /// TODO
  void setDataAt(List<T> matrix, int row, int col, T value) =>
      matrix[source.columnCount * row + col] = value;

  /// Factors the matrix as the product of an orthogonal matrix `Q` and an upper
  /// triangular matrix `R`.
  ///
  /// The returned list contains `Q` at index 0 and `R` at index 1.
  List<R> decompose() {
    final matrixQR = source.toList();

    final rDiagonal = getDiagonal(matrixQR);
    final matrixQ = getQ(matrixQR, rDiagonal);
    final matrixR = getR(matrixQR, rDiagonal);

    return [
      matrixQ,
      matrixR,
    ];
  }

  /// TODO
  List<T> getDiagonal(List<T> flattenedSource);

  /// TODO
  R getR(List<T> flattenedSource, List<T> diagonal);

  /// TODO
  R getQ(List<T> flattenedSource, List<T> diagonal);
}
