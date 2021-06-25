import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/nonlinear_solver/bloc/events.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

/// The coverage report generated by `flutter test --coverage` doesn't take into
/// account those lines where a `const` constructor has a call to `super`. This
/// is something expected by the VM so very likely this behavior won't change.
///
/// In order to achieve 100% code coverage, this file calls some constructors
/// containing `super` calls **WITHOUT** the `const` keyword. In this way, the
/// coverage report tool can mark as "covered" even constructors with `super`
/// calls.
void main() {
  group('Testing constructors of the classes', () {
    test('Exceptions constructors', () {
      expect(
        SinglePointMethod(
          function: '',
          initialGuess: '',
          method: SinglePointMethod.resolve('newton'),
        ),
        isA<SinglePointMethod>(),
      );
      expect(
        BracketingMethod(
          function: '',
          upperBound: '',
          lowerBound: '',
          method: BracketingMethod.resolve('secant'),
        ),
        isA<BracketingMethod>(),
      );
      expect(
        NonlinearClean(),
        isA<NonlinearClean>(),
      );
    });

    test('Exception objects comparison', () {
      final testException = AlgebraicException('message');

      expect(testException.message, equals('message'));
      expect(testException.messagePrefix, equals('AlgebraicException'));
    });
  });
}