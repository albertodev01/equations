import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'english_strings.dart';
import 'french_strings.dart';
import 'italian_strings.dart';

void main() {
  void checklocalizedStringsLengths({
    required AppLocalizations appLocalizations,
    required List<String> localizedValues,
  }) {
    final values = [
      appLocalizations.appTitle,
      appLocalizations.polynomials,
      appLocalizations.functions,
      appLocalizations.systems,
      appLocalizations.integrals,
      appLocalizations.interpolation,
      appLocalizations.other,
      appLocalizations.firstDegree,
      appLocalizations.secondDegree,
      appLocalizations.thirdDegree,
      appLocalizations.fourthDegree,
      appLocalizations.anyDegree,
      appLocalizations.solution,
      appLocalizations.solutions,
      appLocalizations.chart,
      appLocalizations.solve,
      appLocalizations.clean,
      appLocalizations.cancel,
      appLocalizations.no_solutions,
      appLocalizations.no_chart,
      appLocalizations.no_discriminant,
      appLocalizations.polynomial_error,
      appLocalizations.wrong_input,
      appLocalizations.tap_more,
      appLocalizations.discriminant,
      appLocalizations.fraction,
      appLocalizations.single_point,
      appLocalizations.bracketing,
      appLocalizations.precision,
      appLocalizations.convergence,
      appLocalizations.efficiency,
      appLocalizations.not_computed,
      appLocalizations.nonlinear_error,
      appLocalizations.row_reduction,
      appLocalizations.factorization,
      appLocalizations.iterative,
      appLocalizations.size,
      appLocalizations.matrix_size1,
      appLocalizations.matrix_size2,
      appLocalizations.matrix_size3,
      appLocalizations.matrix_size4,
      appLocalizations.matrix_description,
      appLocalizations.vector_description,
      appLocalizations.sor_w,
      appLocalizations.jacobi_initial,
      appLocalizations.singular_matrix_error,
      appLocalizations.invalid_values,
      appLocalizations.matrices,
      appLocalizations.linear,
      appLocalizations.analyze,
      appLocalizations.results,
      appLocalizations.wait_a_moment,
      appLocalizations.rank,
      appLocalizations.trace,
      appLocalizations.transpose,
      appLocalizations.determinant,
      appLocalizations.inverse,
      appLocalizations.cofactor,
      appLocalizations.characteristicPolynomial,
      appLocalizations.eigenvalues,
      appLocalizations.properties,
      appLocalizations.complex_numbers,
      appLocalizations.phase,
      appLocalizations.abs,
      appLocalizations.conjugate,
      appLocalizations.reciprocal,
      appLocalizations.sqrt,
      appLocalizations.length,
      appLocalizations.angle_deg,
      appLocalizations.angle_rad,
      appLocalizations.polar_coordinates,
      appLocalizations.yes,
      appLocalizations.no,
      appLocalizations.diagonal,
      appLocalizations.symmetric,
      appLocalizations.identity,
      appLocalizations.url_error,
      appLocalizations.version,
      appLocalizations.input_allowed_values,
      appLocalizations.input_allowed_numbers,
      appLocalizations.input_allowed_fractions,
      appLocalizations.input_allowed_constants,
      appLocalizations.input_allowed_functions,
      appLocalizations.input_allowed_multiplication_sign,
      appLocalizations.more_digits,
      appLocalizations.nonlinear_error,
    ];

    expect(values.length, equals(86));
    expect(values.length, equals(localizedValues.length));

    for (var i = 0; i < values.length; ++i) {
      values[i] = localizedValues[i];
    }
  }

  testWidgets('Making sure that localization works on context', (tester) async {
    late final AppLocalizations? localizations;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            localizations = AppLocalizations.of(context);

            return const SizedBox();
          },
        ),
      ),
    );

    expect(localizations, isNotNull);
  });

  testWidgets('Making sure that English is correctly loaded', (tester) async {
    late AppLocalizations localizations;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            localizations = AppLocalizations.of(context);

            return const SizedBox();
          },
        ),
      ),
    );

    expect(localizations.localeName, equals('en'));
    checklocalizedStringsLengths(
      appLocalizations: localizations,
      localizedValues: englishStrings.values.toList(growable: false),
    );
  });

  testWidgets('Making sure that Italian is correctly loaded', (tester) async {
    late AppLocalizations localizations;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('it'),
        home: Builder(
          builder: (context) {
            localizations = AppLocalizations.of(context);

            return const SizedBox();
          },
        ),
      ),
    );

    expect(localizations.localeName, equals('it'));
    checklocalizedStringsLengths(
      appLocalizations: localizations,
      localizedValues: italianStrings.values.toList(growable: false),
    );
  });

  testWidgets('Making sure that French is correctly loaded', (tester) async {
    late AppLocalizations localizations;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Builder(
          builder: (context) {
            localizations = AppLocalizations.of(context);

            return const SizedBox();
          },
        ),
      ),
    );

    expect(localizations.localeName, equals('fr'));
    checklocalizedStringsLengths(
      appLocalizations: localizations,
      localizedValues: frenchStrings.values.toList(growable: false),
    );
  });
}
