import 'package:equation_painter/src/model/equation_painter.dart';
import 'package:flutter/widgets.dart';

/// {@template equation_painter.FunctionEvaluator}
/// Signature of a function that returns the evaluation of a function at a given
/// point. For example, this code evaluates `x^2 - 3` on `x` = 5:
///
/// ```dart
/// final FunctionEvaluator parabola = (double value) => value*value - 3;
/// print(parabola(8)); // 61
/// ```
/// {@endtemplate}
typedef FunctionEvaluator = double Function(double value);

/// {@template equation_painter.ColorArea}
/// Used by [EquationPainter] to determine the color and the width of the area
/// to highlight below or above a function.
/// {@endtemplate}
typedef ColorArea = ({
  Color color,
  double start,
  double end,
});
