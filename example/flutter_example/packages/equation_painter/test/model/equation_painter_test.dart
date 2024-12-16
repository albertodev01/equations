import 'package:equation_painter/equation_painter.dart';
import 'package:equation_painter/src/model/equation_painter.dart';
import 'package:equations/equations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildPolynomialPainter({
    int range = 5,
    ColorArea colorArea = const (
      start: 5,
      end: 5,
      color: Colors.transparent,
    ),
    List<double> coefficients = const [1, 2, -3, -2],
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              key: const Key('EquationPainterWidget-Golden'),
              painter: EquationPainter(
                evaluator: (value) {
                  return Algebraic.fromReal(
                    coefficients,
                  ).realEvaluateOn(value).real;
                },
                range: range,
                colorArea: colorArea,
              ),
              size: const Size.square(200),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNonlinearPainter({
    int range = 5,
    ColorArea colorArea = const (
      start: 5,
      end: 5,
      color: Colors.transparent,
    ),
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: CustomPaint(
            key: const Key('EquationPainterWidget-Golden'),
            painter: EquationPainter(
              evaluator: (value) {
                return const Newton(
                  function: 'e^x+x^3',
                  x0: -1,
                ).evaluateOn(value).toDouble();
              },
              range: range,
              colorArea: colorArea,
            ),
            size: const Size.square(350),
          ),
        ),
      ),
    );
  }

  group('Golden tests - EquationPainter (no area)', () {
    testWidgets('Polynomial - low range', (tester) async {
      await tester.binding.setSurfaceSize(const Size(270, 270));

      await tester.pumpWidget(
        buildPolynomialPainter(
          range: 2,
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_polynomial_low.png'),
      );
    });

    testWidgets('Polynomial - default', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_polynomial.png'),
      );
    });

    testWidgets('Polynomial - high range', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          range: 9,
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_polynomial_high.png'),
      );
    });

    testWidgets('Polynomial - with edges', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(coefficients: [1, 0]),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_polynomial_edges.png'),
      );
    });

    testWidgets('Nonlinear - low range', (tester) async {
      await tester.pumpWidget(
        buildNonlinearPainter(
          range: 2,
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_nonlinear_low.png'),
      );
    });

    testWidgets('Nonlinear - default', (tester) async {
      await tester.pumpWidget(
        buildNonlinearPainter(),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_nonlinear.png'),
      );
    });

    testWidgets('Nonlinear - high range', (tester) async {
      await tester.pumpWidget(
        buildNonlinearPainter(
          range: 9,
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_nonlinear_high.png'),
      );
    });
  });

  group('Golden tests - EquationPainter (with area)', () {
    testWidgets('Color only', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: (
            color: Colors.lightGreen.withAlpha(80),
            start: -5,
            end: 5,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_area_color.png'),
      );
    });

    testWidgets('Color and ranges', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: (
            color: Colors.lightGreen.withAlpha(80),
            start: -1,
            end: 2,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_area_color_and_ranges.png'),
      );
    });

    testWidgets('Color and ranges swapped', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: (
            color: Colors.lightGreen.withAlpha(80),
            start: 2,
            end: -1,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile(
          'goldens/equation_painter_area_color_and_ranges_swapped.png',
        ),
      );
    });

    testWidgets('Color and left range only', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: (
            color: Colors.lightGreen.withAlpha(80),
            start: -1,
            end: 5,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile('goldens/equation_painter_area_color_left_range.png'),
      );
    });

    testWidgets('Color and right range only', (tester) async {
      await tester.pumpWidget(
        buildPolynomialPainter(
          colorArea: (
            color: Colors.lime.withAlpha(80),
            start: -5,
            end: 3.5,
          ),
        ),
      );
      await expectLater(
        find.byKey(const Key('EquationPainterWidget-Golden')),
        matchesGoldenFile(
          'goldens/equation_painter_area_color_right_range.png',
        ),
      );
    });
  });
}
