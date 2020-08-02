import 'dart:collection';

class Matrix {

  final List<List<double>> _matrix;

  const Matrix(List<List<double>> source) : _matrix = source;

  List<List<double>> get matrix => UnmodifiableListView(_matrix);

}