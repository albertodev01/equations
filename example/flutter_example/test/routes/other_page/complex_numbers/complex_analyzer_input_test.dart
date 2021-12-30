import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'ComplexAnalyzerInput' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<OtherBloc>(
          create: (_) => OtherBloc(),
          child: const ComplexAnalyzerInput(),
        ),
      ));

      expect(find.byType(ComplexAnalyzerInput), findsOneWidget);
      expect(find.byType(ComplexNumberInput), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets(
      'Making sure that when trying to evaluate a complex number, if at least '
      'one of the inputs is wrong, a snackbar appears',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<OtherBloc>(
            create: (_) => OtherBloc(),
            child: const ComplexAnalyzerInput(),
          ),
        ));

        // Entering some text
        const realKey = Key('ComplexNumberInput-TextFormField-RealPart');
        const imagKey = Key('ComplexNumberInput-TextFormField-ImaginaryPart');

        await tester.enterText(find.byKey(realKey), '-1/2');
        await tester.enterText(find.byKey(imagKey), '...');
        await tester.tap(
          find.byKey(const Key('ComplexAnalyze-button-analyze')),
        );
        await tester.pumpAndSettle();

        // Making sure that we can see the entered text and the snackbar
        expect(find.text('-1/2'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);

        // Clearing
        await tester.tap(find.byKey(const Key('ComplexAnalyze-button-clean')));
        await tester.pumpAndSettle();

        expect(find.text('-1/2'), findsNothing);
      },
    );

    testWidgets(
      'Making sure that complex numbers can be analyzed',
      (tester) async {
        late FocusScopeNode focusScope;
        final bloc = OtherBloc();

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<OtherBloc>.value(
            value: bloc,
            child: Builder(
              builder: (context) {
                focusScope = FocusScope.of(context);

                return const ComplexAnalyzerInput();
              },
            ),
          ),
        ));

        expect(bloc.state, equals(const OtherNone()));

        // Entering some text
        const realKey = Key('ComplexNumberInput-TextFormField-RealPart');
        const imagKey = Key('ComplexNumberInput-TextFormField-ImaginaryPart');

        await tester.enterText(find.byKey(realKey), '-1/2');
        await tester.enterText(find.byKey(imagKey), '5');
        expect(focusScope.hasFocus, isTrue);

        await tester.tap(
          find.byKey(const Key('ComplexAnalyze-button-analyze')),
        );
        await tester.pumpAndSettle();

        expect(bloc.state, isA<AnalyzedComplexNumber>());

        // Cleaning
        final finder = find.byKey(const Key('ComplexAnalyze-button-clean'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(focusScope.hasFocus, isFalse);

        tester
            .widgetList<TextFormField>(find.byType(TextFormField))
            .forEach((t) {
          expect(t.controller!.text.length, isZero);
        });
      },
    );

    testGoldens('ComplexAnalyzerInput', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'ComplexAnalyzerInput',
          BlocProvider<OtherBloc>(
            create: (_) => OtherBloc(),
            child: const ComplexAnalyzerInput(),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(400, 250),
      );
      await screenMatchesGolden(tester, 'complex_analyzer_input');
    });
  });
}
