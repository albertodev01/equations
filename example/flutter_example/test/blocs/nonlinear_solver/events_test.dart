import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
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
          SinglePointMethod.resolve(NonlinearDropdownItems.newton),
          equals(SinglePointMethods.newton),
        );
        expect(
          SinglePointMethod.resolve(NonlinearDropdownItems.steffensen),
          equals(SinglePointMethods.steffensen),
        );
      },
    );

    test(
      "Making sure that 'BracketingMethod.resolve' actually resolves to "
      'the correct values',
      () {
        expect(
          BracketingMethod.resolve(NonlinearDropdownItems.secant),
          equals(BracketingMethods.secant),
        );
        expect(
          BracketingMethod.resolve(NonlinearDropdownItems.brent),
          equals(BracketingMethods.brent),
        );
        expect(
          BracketingMethod.resolve(NonlinearDropdownItems.bisection),
          equals(BracketingMethods.bisection),
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
