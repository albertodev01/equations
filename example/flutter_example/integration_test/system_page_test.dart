import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
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

  Future<void> _testRowReduction(
    WidgetTester tester, [
    int size = 1,
  ]) async {
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
    expect(find.byType(RealResultCard), findsNWidgets(size));

    // Cleaning
    final cleanBtn = find.byKey(const Key('System-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> _testFactorization(
    WidgetTester tester, [
    int size = 1,
    bool cholesky = false,
  ]) async {
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

    if (cholesky) {
      await tester.ensureVisible(find.text('LU'));
      await tester.pumpAndSettle();

      // Changing the dropdown value
      await tester.tap(find.text('LU'));
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
    expect(find.byType(RealResultCard), findsNWidgets(size));

    // Cleaning
    final cleanBtn = find.byKey(const Key('System-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> _testIterative(
    WidgetTester tester, [
    int size = 1,
    bool jacobi = false,
  ]) async {
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
      await tester.ensureVisible(find.text('SOR'));
      await tester.pumpAndSettle();

      // Changing the dropdown value
      await tester.tap(find.text('SOR'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Jacobi').last);
      await tester.pumpAndSettle();
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
        app.main();
        await tester.pumpAndSettle();

        // Opening the system page
        await tester.tap(find.byKey(const Key('SystemsLogo-Container')));
        await tester.pumpAndSettle();

        await _testRowReduction(tester);
        await _testRowReduction(tester, 2);
        await _testRowReduction(tester, 3);
        await _testRowReduction(tester, 4);
      },
    );

    testWidgets(
      'Testing factorization - LU',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the system page
        await tester.tap(find.byKey(const Key('SystemsLogo-Container')));
        await tester.pumpAndSettle();

        // Moving to the 'Factorization' page
        await tester.tap(find.text('Factorization'));
        await tester.pumpAndSettle();

        await _testFactorization(tester);
        await _testFactorization(tester, 2);
        await _testFactorization(tester, 3);
        await _testFactorization(tester, 4);
      },
    );

    testWidgets(
      'Testing factorization - Cholesky',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the system page
        await tester.tap(find.byKey(const Key('SystemsLogo-Container')));
        await tester.pumpAndSettle();

        // Moving to the 'Factorization' page
        await tester.tap(find.text('Factorization'));
        await tester.pumpAndSettle();

        await _testFactorization(tester, 1, true);
        await _testFactorization(tester, 2, true);
        await _testFactorization(tester, 3, true);
        await _testFactorization(tester, 4, true);
      },
    );

    testWidgets(
      'Testing iterative - SOR',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the system page
        await tester.tap(find.byKey(const Key('SystemsLogo-Container')));
        await tester.pumpAndSettle();

        // Moving to the 'Factorization' page
        await tester.tap(find.text('Iterative'));
        await tester.pumpAndSettle();

        await _testIterative(tester);
        await _testIterative(tester, 2);
        await _testIterative(tester, 3);
        await _testIterative(tester, 4);
      },
    );
  });
}
