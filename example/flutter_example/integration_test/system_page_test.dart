import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var needsOpenPage = true;

  const matrixCoefficients = [
    16,
    -12,
    -12,
    -16,
    -12,
    25,
    1,
    -4,
    -12,
    1,
    17,
    14,
    -16,
    -4,
    14,
    57,
  ];
  const knownValues = [7, 3, 6, -2];

  Future<void> testRowReduction(
    WidgetTester tester, [
    int size = 1,
  ]) async {
    if (needsOpenPage) {
      // Opening the system page
      await tester.tap(find.byKey(const Key('SystemsLogo-Container')));
      await tester.pumpAndSettle();

      needsOpenPage = false;
    }

    final finder = find.byType(TextFormField);
    final matrixInputs = size * size;

    if (size > 1) {
      final finder = find.byKey(const Key('SizePicker-Forward-Button'));

      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();

      for (var i = 1; i < size; ++i) {
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.pumpAndSettle();
      }
    }

    // Filling the matrix
    for (var i = 0; i < matrixInputs; ++i) {
      await tester.enterText(finder.at(i), '${matrixCoefficients[i]}');
    }

    // Filling the known values vector
    var knownValuesCounter = 0;
    for (var i = matrixInputs; i < matrixInputs + size; ++i) {
      await tester.enterText(
        finder.at(i),
        '${knownValues[knownValuesCounter]}',
      );
      knownValuesCounter++;
    }

    // Solving
    final solveBtn = find.byKey(const Key('System-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Result cards
    await tester.ensureVisible(find.byType(RealResultCard).last);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNWidgets(size));

    // Cleaning
    final cleanBtn = find.byKey(const Key('System-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> testFactorization(
    WidgetTester tester, [
    int size = 1,
    // ignore: avoid_positional_boolean_parameters
    bool cholesky = false,
  ]) async {
    tester
        .widget<InheritedNavigation>(find.byType(InheritedNavigation))
        .navigationIndex
        .value = 1;

    await tester.pumpAndSettle();

    final finder = find.byType(TextFormField);
    final matrixInputs = size * size;

    if (size > 1) {
      final finder = find.byKey(const Key('SizePicker-Forward-Button'));

      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();

      for (var i = 1; i < size; ++i) {
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }
    }

    // Filling the matrix
    for (var i = 0; i < matrixInputs; ++i) {
      await tester.enterText(finder.at(i), '${matrixCoefficients[i]}');
    }

    // Filling the known values vector
    var knownValuesCounter = 0;
    for (var i = matrixInputs; i < matrixInputs + size; ++i) {
      await tester.enterText(
        finder.at(i),
        '${knownValues[knownValuesCounter]}',
      );
      knownValuesCounter++;
    }

    if (cholesky && size == 1) {
      await tester.ensureVisible(find.text('LU'));
      await tester.pumpAndSettle();

      // Changing the dropdown value
      await tester.tap(find.text('LU'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cholesky').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cholesky').last);
      await tester.pumpAndSettle();
    }

    // Solving
    final solveBtn = find.byKey(const Key('System-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Result cards
    await tester.ensureVisible(find.byType(RealResultCard).last);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNWidgets(size));

    // Cleaning
    final cleanBtn = find.byKey(const Key('System-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> testIterative(
    WidgetTester tester, [
    int size = 1,
    // ignore: avoid_positional_boolean_parameters
    bool jacobi = false,
  ]) async {
    // Moving to the 'Bracketing' page
    tester
        .widget<InheritedNavigation>(find.byType(InheritedNavigation))
        .navigationIndex
        .value = 2;

    await tester.pumpAndSettle();

    final finder = find.byType(TextFormField);
    final matrixInputs = size * size;

    if (size > 1) {
      final finder = find.byKey(const Key('SizePicker-Forward-Button'));

      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();

      for (var i = 1; i < size; ++i) {
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }
    }

    // Filling the matrix
    for (var i = 0; i < matrixInputs; ++i) {
      await tester.enterText(finder.at(i), '${matrixCoefficients[i]}');
    }

    // Filling the known values vector
    var knownValuesCounter = 0;
    for (var i = matrixInputs; i < matrixInputs + size; ++i) {
      await tester.enterText(
        finder.at(i),
        '${knownValues[knownValuesCounter]}',
      );
      knownValuesCounter++;
    }

    if (jacobi) {
      if (size == 1) {
        await tester.ensureVisible(find.text('SOR'));
        await tester.pumpAndSettle();

        // Changing the dropdown value
        await tester.tap(find.text('SOR'));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('SOR').last);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Jacobi').last);
        await tester.pumpAndSettle();
      }

      // Initial guess vector
      final totalInputs = matrixInputs + size;

      var value = 0;
      for (var i = totalInputs; i < totalInputs + size; ++i) {
        await tester.enterText(finder.at(i), '${value++}');
      }
    } else {
      final w = find.byKey(
        const Key('SystemSolver-Iterative-RelaxationFactor'),
      );

      await tester.ensureVisible(w);
      await tester.pumpAndSettle();

      await tester.enterText(w, '0.5');
    }

    // Solving
    final solveBtn = find.byKey(const Key('System-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Result cards
    await tester.ensureVisible(find.byType(RealResultCard).last);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNWidgets(size));

    // Cleaning
    final cleanBtn = find.byKey(const Key('System-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  group('Integration tests on the System page', () {
    testWidgets(
      'Testing row reduction',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();

        await testRowReduction(tester);
        await testRowReduction(tester, 2);
        await testRowReduction(tester, 3);
        await testRowReduction(tester, 4);
      },
    );

    testWidgets(
      'Testing factorization - LU',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();

        await testFactorization(tester);
        await testFactorization(tester, 2);
        await testFactorization(tester, 3);
        await testFactorization(tester, 4);
      },
    );

    testWidgets(
      'Testing factorization - Cholesky',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();

        await testFactorization(tester, 1, true);
        await testFactorization(tester, 2, true);
        await testFactorization(tester, 3, true);
        await testFactorization(tester, 4, true);
      },
    );

    testWidgets(
      'Testing iterative - SOR',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();

        await testIterative(tester);
        await testIterative(tester, 2);
        await testIterative(tester, 3);
        await testIterative(tester, 4);
      },
    );

    testWidgets(
      'Testing iterative - Jacobi',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();

        await testIterative(tester, 1, true);
        await testIterative(tester, 2, true);
        await testIterative(tester, 3, true);
        await testIterative(tester, 4, true);
      },
    );
  });
}
