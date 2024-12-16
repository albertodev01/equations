import 'package:equation_painter/src/model/types.dart';
import 'package:flutter/material.dart';

/// {@template equation_painter.EquationPainter}
/// A [CustomPainter] that creates a cartesian plane and draws any kind of
/// mathematical function on it. The [range] parameter, is used to define the
/// scale of the plane (in other words, the "zoom" level on the board).
/// {@endtemplate}
class EquationPainter extends CustomPainter {
  /// {@macro equation_painter.FunctionEvaluator}
  ///
  /// If this is `null`, the painter only draws a cartesian plane (without the
  /// function).
  final FunctionEvaluator? evaluator;

  /// The 'scale' of the chart.
  final int range;

  /// {@macro equation_painter.ColorArea}
  final ColorArea colorArea;

  /// {@macro equation_painter.EquationPainter}
  const EquationPainter({
    this.evaluator,
    this.range = 5,
    this.colorArea = const (
      color: Colors.transparent,
      start: 5,
      end: 5,
    ),
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawMainAxis(canvas, size);
    _drawAxis(canvas, size);

    // Drawing the function ONLY if there's an evaluator available
    if (evaluator != null) {
      _drawEquation(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant EquationPainter oldDelegate) {
    return range != oldDelegate.range ||
        evaluator != oldDelegate.evaluator ||
        colorArea != oldDelegate.colorArea;
  }

  void _drawMainAxis(Canvas canvas, Size size) {
    final blackThick = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draws the main X and Y axis
    canvas
      ..drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        blackThick,
      )
      ..drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        blackThick,
      );
  }

  void _drawAxis(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 1.0;

    // X and Y axis
    final scale = range;
    final distX = (size.width / 2) / scale;
    final distY = (size.height / 2) / scale;

    var prevPoint = Offset(distX, 0);
    var currPoint = Offset(0, distY);

    // Drawing the grid (with scaling)
    for (var i = -scale; i < scale; ++i) {
      if (i == 0) {
        continue;
      }

      canvas
        ..drawLine(prevPoint, Offset(prevPoint.dx, size.height), line)
        ..drawLine(currPoint, Offset(size.width, currPoint.dy), line);

      prevPoint = Offset(prevPoint.dx + distX, prevPoint.dy);
      currPoint = Offset(currPoint.dx, currPoint.dy + distY);
    }
  }

  void _drawEquation(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2.0;

    final area = Paint()
      ..color = colorArea.color
      ..strokeWidth = 1.0;

    var logy = 0.0;
    var logx = 0.0;

    final width = size.width;
    final height = size.height;

    var currPoint = Offset.zero;
    var prevPoint = Offset.zero;

    // In case the user entered the startPoint greater than the endPoint, we
    // swap the values
    var actualColorArea = colorArea;

    if (colorArea.start > colorArea.end) {
      actualColorArea = (
        start: colorArea.end,
        end: colorArea.start,
        color: colorArea.color,
      );
    }

    for (var i = 0; i < size.width; ++i) {
      logx = _screenToLog(Offset(i * 1.0, 0), width, height).dx;

      // Using '!' on 'plotMode' here is safe because this function is called
      // only if 'plotMode != null' (see the 'paint' method above)
      logy = evaluator!.call(logx);

      final pts = Offset(logx, logy);
      currPoint = Offset(i * 1.0, _logToScreen(pts, width, height).dy);

      if (currPoint.dx > 0) {
        canvas.drawLine(currPoint, prevPoint, line);
      }

      // Highlighting the area below the function ONLY if a color is defined
      if (actualColorArea.color != Colors.transparent) {
        final xAxis = Offset(currPoint.dx, size.height / 2);

        if (logx >= actualColorArea.start && logx <= actualColorArea.end) {
          canvas.drawLine(xAxis, currPoint, area);
        }
      }

      prevPoint = currPoint;
    }
  }

  Offset _screenToLog(Offset screenPoint, double width, double height) {
    return Offset(
      -range + (screenPoint.dx / width) * (range + range),
      -range + (height - screenPoint.dy) * (range + range),
    );
  }

  Offset _logToScreen(Offset logPoint, double width, double height) {
    return Offset(
      width * (logPoint.dx + range) / (range + range),
      height - height * (logPoint.dy + range) / (range + range),
    );
  }
}
