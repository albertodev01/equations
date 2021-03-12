import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:flutter/material.dart';

class PlotterPainter<T> extends CustomPainter {
  final PlotMode<T>? plotMode;
  final int range;
  final int _xmax;
  final int _xmin;
  final int _ymax;
  final int _ymin;
  const PlotterPainter({
    required this.plotMode,
    this.range = 5,
  })  : _xmax = range,
        _ymax = range,
        _xmin = -range,
        _ymin = -range;

  @override
  void paint(Canvas canvas, Size size) {
    _drawMainAxis(canvas, size);
    _drawAxis(canvas, size);

    if (plotMode != null) {
      _drawEquation(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant PlotterPainter<T> oldDelegate) {
    return (range != oldDelegate.range) || (plotMode != oldDelegate.plotMode);
  }

  void _drawMainAxis(Canvas canvas, Size size) {
    var blackThick = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    canvas
      ..drawLine(Offset(0, size.height / 2),
          Offset(size.width, size.height / 2), blackThick)
      ..drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height),
          blackThick);
  }

  void _drawAxis(Canvas canvas, Size size) {
    var line = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 1.0;

    var scale = range;
    var distX = (size.width / 2) / scale;
    var distY = (size.height / 2) / scale;

    var prevPoint = Offset(distX, 0);
    var currPoint = Offset(0, distY);

    for (var i = -scale; i < scale; ++i) {
      if (i == 0) continue;

      canvas
        ..drawLine(prevPoint, Offset(prevPoint.dx, size.height), line)
        ..drawLine(currPoint, Offset(size.width, currPoint.dy), line);

      prevPoint = Offset(prevPoint.dx + distX, prevPoint.dy);
      currPoint = Offset(currPoint.dx, currPoint.dy + distY);
    }
  }

  void _drawEquation(Canvas canvas, Size size) {
    var line = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2.0;

    var logy = 0.0;
    var logx = 0.0;

    var width = size.width;
    var height = size.height;

    var currPoint = Offset(0, 0);
    var prevPoint = Offset(0, 0);

    for (var i = 0; i < size.width; ++i) {
      logx = _screenToLog(Offset(i * 1.0, 0), width, height).dx;
      logy = plotMode!.evaluateOn(logx);

      var pts = Offset(logx, logy);
      currPoint = Offset(i * 1.0, _logToScreen(pts, width, height).dy);

      if (currPoint.dx > 0) {
        canvas.drawLine(currPoint, prevPoint, line);
      }

      prevPoint = currPoint;
    }
  }

  Offset _screenToLog(Offset screenPoint, double width, double height) {
    return Offset(
      _xmin + (screenPoint.dx / width) * (_xmax - _xmin),
      _ymin + (height - screenPoint.dy) * (_ymax - _ymin),
    );
  }

  Offset _logToScreen(Offset logPoint, double width, double height) {
    return Offset(
      width * (logPoint.dx - _xmin) / (_xmax - _xmin),
      height - height * (logPoint.dy - _ymin) / (_ymax - _ymin),
    );
  }
}
