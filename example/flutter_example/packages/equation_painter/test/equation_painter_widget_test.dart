import 'package:equation_painter/src/equation_painter_widget.dart';
import 'package:equation_painter/src/state/inherited_painter_zoom_state.dart';
import 'package:equation_painter/src/state/painter_zoom_state.dart';
import 'package:equations/equations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late final Widget equationDrawerWidget;
  final equation = Algebraic.fromReal([1, 2, -3, -2]);

  setUpAll(() {
    equationDrawerWidget = Center(
      child: SizedBox(
        width: 300,
        height: 400,
        child: EquationPainterWidget(
          evaluator: (value) => equation.realEvaluateOn(value).real,
        ),
      ),
    );
  });

  group("Testing the 'EquationDrawerWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: equationDrawerWidget,
            ),
          ),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(Body), findsOneWidget);
      expect(find.byType(InheritedPainterZoomState), findsOneWidget);
    });
  });

  group('Golden tests - EquationPainterWidget', () {
    testWidgets('EquationPainterWidget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: InheritedPainterZoomState(
                painterZoomState: PainterZoomState(
                  minValue: 2,
                  maxValue: 10,
                  initial: 5,
                ),
                child: equationDrawerWidget,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(EquationPainterWidget),
        matchesGoldenFile('goldens/equation_painter_widget.png'),
      );
    });

    testWidgets('EquationPainterWidget - zoom', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: InheritedPainterZoomState(
                painterZoomState: PainterZoomState(
                  minValue: 2,
                  maxValue: 10,
                  initial: 5,
                ),
                child: equationDrawerWidget,
              ),
            ),
          ),
        ),
      );

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(60, 0));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(EquationPainterWidget),
        matchesGoldenFile('goldens/equation_painter_widget_zoom.png'),
      );
    });
  });
}
