import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  late final BooleRule boole;

  setUpAll(() {
    boole = const BooleRule(
      function: 'sin(x)*e^x',
      lowerBound: 2,
      upperBound: 4,
    );
  });

  group('BooleRule', () {
    test('Smoke test', () {
      expect(boole.lowerBound, equals(2));
      expect(boole.upperBound, equals(4));
      expect(boole.intervals, equals(32));

      // Actual approximation
      final results = boole.integrate();

      expect(results.result, const MoreOrLessEquals(-7.713, precision: 1.0e-4));
      expect(results.guesses.length, equals(boole.intervals + 1));
    });

    test('Guesses values', () {
      const integral = BooleRule(
        function: 'x^2',
        lowerBound: 0,
        upperBound: 8,
        intervals: 8,
      );

      expect(
        integral.integrate().guesses,
        orderedEquals(<double>[0, 1, 4, 9, 16, 25, 36, 49, 64]),
      );
    });

    test('Exact up to degree 5', () {
      // The integral from -1 to 3 is (3^6 - 1) / 6 - 2 * (3^3 + 1) / 3 + 4
      const integral = BooleRule(
        function: 'x^5-2*x^2+1',
        lowerBound: -1,
        upperBound: 3,
        intervals: 4,
      );

      expect(
        integral.integrate().result,
        MoreOrLessEquals((math.pow(3, 6) - 1) / 6 - 2 * 28 / 3 + 4),
      );
    });

    test('Reversed bounds', () {
      final results = const BooleRule(
        function: 'e^x',
        lowerBound: 2,
        upperBound: 0,
      ).integrate();

      expect(
        results.result,
        MoreOrLessEquals(1 - math.exp(2), precision: 1.0e-8),
      );
    });

    test('toString()', () {
      const strResult = 'sin(x)*e^x on [2.00, 4.00]\nUsing 32 intervals';
      expect(boole.toString(), equals(strResult));
    });

    test('Object comparison', () {
      const boole2 = BooleRule(
        function: 'sin(x)*e^x',
        lowerBound: 2,
        upperBound: 4,
      );

      expect(boole == boole2, isTrue);
      expect(boole2 == boole, isTrue);
      expect(boole, equals(boole2));
      expect(boole.hashCode, equals(boole2.hashCode));

      expect(
        boole ==
            const BooleRule(
              function: 'sin(x)*e^x',
              lowerBound: 0,
              upperBound: 4,
            ),
        isFalse,
      );

      expect(
        boole ==
            const BooleRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
              intervals: 4,
            ),
        isFalse,
      );

      expect(
        boole ==
            const SimpsonRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
            ),
        isFalse,
      );
    });

    group('Solutions tests', () {
      void verifyBooleRule(
        String function,
        double lowerBound,
        double upperBound,
        double expectedResult,
      ) {
        final result = BooleRule(
          function: function,
          lowerBound: lowerBound,
          upperBound: upperBound,
          intervals: 60,
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(expectedResult, precision: 1.0e-3),
        );
      }

      test('Test 1', () {
        verifyBooleRule('cos(x)-x^2', 2, 3, -7.101);
      });

      test('Test 2', () {
        verifyBooleRule('e^(x-1)/(x^2+3*x-8)', 4, 5.25, 1.769);
      });

      test('Test 3', () {
        verifyBooleRule('sin(x+2)*(x-1)+sqrt(x)', 3, 4, 0.235);
      });

      test('Test 4', () {
        verifyBooleRule('abs(x-2)*e^x', -2, 0, 2.323);
      });

      test('Test 5', () {
        verifyBooleRule('log(x+sqrt(x))', 1, 1.25, 0.195);
      });

      test('Test 6', () {
        verifyBooleRule('x', 1, 2, 1.5);
      });

      test('Test 7', () {
        verifyBooleRule('0', -1, 1, 0);
      });
    });

    test('Throws on invalid intervals', () {
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          intervals: 0,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          intervals: -4,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          intervals: 6,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          intervals: 30,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });

    test('Throws on non-finite bounds', () {
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: 0,
          upperBound: double.infinity,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: double.negativeInfinity,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const BooleRule(
          function: 'x',
          lowerBound: double.nan,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });
  });
}
