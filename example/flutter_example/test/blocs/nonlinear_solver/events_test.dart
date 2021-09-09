import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'NonlinearBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const singlePoint = SinglePointMethod(
        function: '',
        initialGuess: '',
        method: SinglePointMethods.newton,
      );

      const bracketing = BracketingMethod(
        function: '',
        lowerBound: '',
        upperBound: '',
        method: BracketingMethods.bisection,
      );

      expect(singlePoint.props.length, equals(5));
      expect(bracketing.props.length, equals(6));

      expect(
        const SinglePointMethod(
          function: '',
          initialGuess: '',
          method: SinglePointMethods.newton,
        ),
        equals(singlePoint),
      );

      expect(
        const BracketingMethod(
          function: '',
          lowerBound: '',
          upperBound: '',
          method: BracketingMethods.bisection,
        ),
        equals(bracketing),
      );

      expect(
        const NonlinearClean(),
        equals(const NonlinearClean()),
      );

      expect(
        const NonlinearClean().props.length,
        equals(2),
      );
    });

    test(
      "Making sure that 'SinglePointMethod.resolve' actually resolves to "
      'the correct values',
      () {
        expect(
          SinglePointMethod.resolve('newton'),
          equals(SinglePointMethods.newton),
        );
        expect(
          SinglePointMethod.resolve('NewTOn'),
          equals(SinglePointMethods.newton),
        );
        expect(
          SinglePointMethod.resolve('steffensen'),
          equals(SinglePointMethods.steffensen),
        );
        expect(
          SinglePointMethod.resolve('stefFenSEn'),
          equals(SinglePointMethods.steffensen),
        );

        expect(
          () => SinglePointMethod.resolve('abc'),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      "Making sure that 'BracketingMethod.resolve' actually resolves to "
      'the correct values',
      () {
        expect(
          BracketingMethod.resolve('secant'),
          equals(BracketingMethods.secant),
        );
        expect(
          BracketingMethod.resolve('brent'),
          equals(BracketingMethods.brent),
        );
        expect(
          BracketingMethod.resolve('bisection'),
          equals(BracketingMethods.bisection),
        );

        expect(
          () => BracketingMethod.resolve(''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test("Making sure that all events are subtypes of 'NonlinearEvent'", () {
      expect(
        const SinglePointMethod(
          function: '',
          initialGuess: '',
          method: SinglePointMethods.newton,
        ),
        isA<NonlinearEvent>(),
      );

      expect(
        const BracketingMethod(
          function: '',
          lowerBound: '',
          upperBound: '',
          method: BracketingMethods.bisection,
        ),
        isA<NonlinearEvent>(),
      );
    });
  });
}
