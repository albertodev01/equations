import 'package:equations/equations.dart';
import 'package:equations/src/utils/exceptions/types/numerical_integration_exception.dart';
import 'package:petitparser/core.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

///There is a bug in the coverage report tool where `const` constructors aren't
/// recognized. When calling
///
///  - flutter test --coverage
///
/// the report says that the constructor of a certain class hasn't been covered.
/// This is a known error because, without the `const` constructor, the line is
/// reported as 'covered'
///
/// This class has the sole purpose to workaround the bug by calling the various
/// constructors without the `const` modifier. This file will be deleted as soon
/// as the Dart team fixes the issue.
///
///  - Issue: https://github.com/dart-lang/sdk/issues/38934
void main() {
  group('Testing constructors of the classes', () {
    test('Exceptions constructors', () {
      expect(
        AlgebraicException('Message'),
        isA<AlgebraicException>(),
      );
      expect(
        ComplexException('Message'),
        isA<ComplexException>(),
      );
      expect(
        MatrixException('Message'),
        isA<MatrixException>(),
      );
      expect(
        NonlinearException('Message'),
        isA<NonlinearException>(),
      );
      expect(
        NumericalIntegrationException('Message'),
        isA<NumericalIntegrationException>(),
      );
      expect(
        SystemSolverException('Message'),
        isA<SystemSolverException>(),
      );
    });

    test('Nonlinear constructors', () {
      expect(
        Bisection(function: 'x+1', a: 0, b: 0),
        isA<Bisection>(),
      );
      expect(
        Brent(function: 'x+1', a: 0, b: 0),
        isA<Brent>(),
      );
      expect(
        Chords(function: 'x+1', a: 0, b: 0),
        isA<Chords>(),
      );
      expect(
        Newton(function: 'x+1', x0: 0),
        isA<Newton>(),
      );
      expect(
        RegulaFalsi(function: 'x+1', a: 0, b: 0),
        isA<RegulaFalsi>(),
      );
      expect(
        Secant(function: 'x+1', firstGuess: 0, secondGuess: 0),
        isA<Secant>(),
      );
      expect(
        Steffensen(function: 'x+1', x0: 0),
        isA<Steffensen>(),
      );
    });

    test('Numerical integration constructors', () {
      expect(
        TrapezoidalRule(lowerBound: 0, upperBound: 0),
        isA<TrapezoidalRule>(),
      );
      expect(
        SimpsonRule(lowerBound: 0, upperBound: 0),
        isA<SimpsonRule>(),
      );
      expect(
        TrapezoidalRule(lowerBound: 0, upperBound: 0),
        isA<TrapezoidalRule>(),
      );
    });
  });
}
