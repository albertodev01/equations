import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_result.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NonlinearType' enum", () {
    test('Properties values', () {
      expect(NonlinearType.values.length, equals(2));
      expect(SinglePointMethods.values.length, equals(2));
      expect(BracketingMethods.values.length, equals(3));
    });
  });

  group("Testing the 'NonlinearState' class", () {
    test('Initial values', () {
      final nonlinearState = NonlinearState(NonlinearType.singlePoint);

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state, equals(const NonlinearResult()));
    });

    test('Making sure that s. point equations can be solved and cleared', () {
      var count = 0;
      final nonlinearState = NonlinearState(NonlinearType.singlePoint)
        ..addListener(() => ++count);

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state, equals(const NonlinearResult()));

      nonlinearState.solveWithSinglePoint(
        function: 'x-2',
        precision: 1.0e-10,
        initialGuess: '2',
        method: SinglePointMethods.newton,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state.nonlinear, isNotNull);
      expect(count, equals(1));

      nonlinearState.clear();

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state, equals(const NonlinearResult()));
      expect(count, equals(2));

      nonlinearState.solveWithSinglePoint(
        function: 'x-2',
        precision: 1.0e-10,
        initialGuess: '2',
        method: SinglePointMethods.steffensen,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state.nonlinear, isNotNull);
      expect(count, equals(3));
    });

    test('Making sure that bracketing equations can be solved and cleared', () {
      var count = 0;
      final nonlinearState = NonlinearState(NonlinearType.bracketing)
        ..addListener(() => ++count);

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state, equals(const NonlinearResult()));

      nonlinearState.solveWithBracketing(
        function: 'x-2',
        precision: 1.0e-10,
        upperBound: '1',
        lowerBound: '1',
        method: BracketingMethods.bisection,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state.nonlinear, isNotNull);
      expect(count, equals(1));

      nonlinearState.clear();

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state, equals(const NonlinearResult()));
      expect(count, equals(2));

      nonlinearState.solveWithBracketing(
        function: 'x-2',
        precision: 1.0e-10,
        upperBound: '1',
        lowerBound: '1',
        method: BracketingMethods.brent,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state.nonlinear, isNotNull);
      expect(count, equals(3));
    });

    test('Making sure that exceptions are handled - Single point', () {
      var count = 0;
      final nonlinearState = NonlinearState(NonlinearType.singlePoint)
        ..addListener(() => ++count);

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state, equals(const NonlinearResult()));

      nonlinearState.solveWithSinglePoint(
        function: '',
        precision: 1.0e-10,
        initialGuess: '',
        method: SinglePointMethods.newton,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state.nonlinear, isNull);
      expect(count, equals(1));

      nonlinearState.solveWithSinglePoint(
        function: 'x^2',
        precision: 1.0e-10,
        initialGuess: '',
        method: SinglePointMethods.newton,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.singlePoint));
      expect(nonlinearState.state.nonlinear, isNull);
      expect(count, equals(2));
    });

    test('Making sure that exceptions are handled - Bracketing', () {
      var count = 0;
      final nonlinearState = NonlinearState(NonlinearType.bracketing)
        ..addListener(() => ++count);

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state, equals(const NonlinearResult()));

      nonlinearState.solveWithBracketing(
        function: 'x-2',
        precision: 1.0e-10,
        lowerBound: '',
        upperBound: '1',
        method: BracketingMethods.bisection,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state.nonlinear, isNull);
      expect(count, equals(1));

      nonlinearState.solveWithBracketing(
        function: 'x-2',
        precision: 1.0e-10,
        lowerBound: '0',
        upperBound: '',
        method: BracketingMethods.bisection,
      );

      expect(nonlinearState.nonlinearType, equals(NonlinearType.bracketing));
      expect(nonlinearState.state.nonlinear, isNull);
      expect(count, equals(2));
    });
  });
}
