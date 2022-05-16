import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(MockPolynomialEvent());
    registerFallbackValue(MockPolynomialState());
  });

  group("Testing the 'PolynomialBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: BlocProvider<PolynomialBloc>(
            create: (_) => PolynomialBloc(PolynomialType.quartic),
            child: const Scaffold(
              body: PolynomialBody(),
            ),
          ),
        ),
      );

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(PolynomialDataInput), findsOneWidget);
      expect(find.byType(PolynomialResults), findsOneWidget);
    });

    testWidgets(
      'Making sure that the widget is responsive - small screens '
      'test',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<PolynomialBloc>(
              create: (_) => PolynomialBloc(PolynomialType.quadratic),
              child: const Scaffold(
                body: PolynomialBody(),
              ),
            ),
          ),
        );

        expect(
          find.byKey(const Key('SingleChildScrollView-mobile-responsive')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('SingleChildScrollView-desktop-responsive')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that the widget is responsive - large screens '
      'test',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<PolynomialBloc>(
              create: (_) => PolynomialBloc(PolynomialType.cubic),
              child: const Scaffold(
                body: PolynomialBody(),
              ),
            ),
          ),
        );

        expect(
          find.byKey(const Key('SingleChildScrollView-mobile-responsive')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('SingleChildScrollView-desktop-responsive')),
          findsOneWidget,
        );
      },
    );

    testWidgets('Making sure that solving linear eq. works', (tester) async {
      final bloc = PolynomialBloc(PolynomialType.linear);

      await tester.pumpWidget(
        MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PolynomialBloc>.value(
                value: bloc,
              ),
              BlocProvider<PlotZoomCubit>(
                create: (_) => PlotZoomCubit(
                  minValue: 1,
                  maxValue: 10,
                  initial: 5,
                ),
              ),
            ],
            child: Scaffold(
              body: BlocProvider<PolynomialBloc>.value(
                value: bloc,
                child: const PolynomialBody(),
              ),
            ),
          ),
        ),
      );

      final coeffA =
          find.byKey(const Key('PolynomialInputField-coefficient-0'));
      final coeffB =
          find.byKey(const Key('PolynomialInputField-coefficient-1'));
      final solveButton = find.byKey(const Key('Polynomial-button-solve'));

      // Filling the forms
      await tester.enterText(coeffA, '-5');
      await tester.enterText(coeffB, '1/2');

      // Making sure that there are no results
      expect(bloc.state, isA<PolynomialNone>());
      expect(find.byType(NoResults), findsOneWidget);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Solutions on the UI!
      expect(bloc.state, isA<PolynomialRoots>());
      expect(find.byType(NoResults), findsNothing);
      expect(find.byKey(const Key('PolynomialDiscriminant')), findsOneWidget);
      expect(find.byType(ComplexResultCard), findsNWidgets(2));
    });

    testWidgets('Making sure that solving linear eq. works', (tester) async {
      final bloc = PolynomialBloc(PolynomialType.quadratic);
      var quadraticTabName = '';

      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              quadraticTabName = context.l10n.secondDegree;

              return MultiBlocProvider(
                providers: [
                  BlocProvider<PolynomialBloc>.value(
                    value: bloc,
                  ),
                  BlocProvider<PlotZoomCubit>(
                    create: (_) => PlotZoomCubit(
                      minValue: 1,
                      maxValue: 10,
                      initial: 5,
                    ),
                  ),
                ],
                child: Scaffold(
                  body: BlocProvider<PolynomialBloc>.value(
                    value: bloc,
                    child: const PolynomialBody(),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Moving to the second page
      await tester.tap(find.text(quadraticTabName));
      await tester.pumpAndSettle();

      // Data input
      final coeffA =
          find.byKey(const Key('PolynomialInputField-coefficient-0'));
      final coeffB =
          find.byKey(const Key('PolynomialInputField-coefficient-1'));
      final coeffC =
          find.byKey(const Key('PolynomialInputField-coefficient-2'));
      final solveButton = find.byKey(const Key('Polynomial-button-solve'));

      // Filling the forms
      await tester.enterText(coeffA, '-5');
      await tester.enterText(coeffB, '1/2');
      await tester.enterText(coeffC, '3');

      // Making sure that there are no results
      expect(bloc.state, isA<PolynomialNone>());
      expect(find.byType(NoResults), findsOneWidget);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Solutions on the UI!
      expect(bloc.state, isA<PolynomialRoots>());
      expect(find.byType(NoResults), findsNothing);
      expect(find.byKey(const Key('PolynomialDiscriminant')), findsOneWidget);
      expect(find.byType(ComplexResultCard), findsNWidgets(3));
    });

    testWidgets('Making sure that solving cubic eq. works', (tester) async {
      final bloc = PolynomialBloc(PolynomialType.cubic);
      var cubicTabName = '';

      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              cubicTabName = context.l10n.thirdDegree;

              return MultiBlocProvider(
                providers: [
                  BlocProvider<PolynomialBloc>.value(
                    value: bloc,
                  ),
                  BlocProvider<PlotZoomCubit>(
                    create: (_) => PlotZoomCubit(
                      minValue: 1,
                      maxValue: 10,
                      initial: 5,
                    ),
                  ),
                ],
                child: Scaffold(
                  body: BlocProvider<PolynomialBloc>.value(
                    value: bloc,
                    child: const PolynomialBody(),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Moving to the second page
      await tester.tap(find.text(cubicTabName));
      await tester.pumpAndSettle();

      // Data input
      final coeffA =
          find.byKey(const Key('PolynomialInputField-coefficient-0'));
      final coeffB =
          find.byKey(const Key('PolynomialInputField-coefficient-1'));
      final coeffC =
          find.byKey(const Key('PolynomialInputField-coefficient-2'));
      final coeffD =
          find.byKey(const Key('PolynomialInputField-coefficient-3'));
      final solveButton = find.byKey(const Key('Polynomial-button-solve'));

      // Filling the forms
      await tester.enterText(coeffA, '-5');
      await tester.enterText(coeffB, '1/2');
      await tester.enterText(coeffC, '0');
      await tester.enterText(coeffD, '1');

      // Making sure that there are no results
      expect(bloc.state, isA<PolynomialNone>());
      expect(find.byType(NoResults), findsOneWidget);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Solutions on the UI!
      expect(bloc.state, isA<PolynomialRoots>());
      expect(find.byType(NoResults), findsNothing);
      expect(find.byKey(const Key('PolynomialDiscriminant')), findsOneWidget);
      expect(find.byType(ComplexResultCard), findsNWidgets(4));
    });

    testWidgets('Making sure that solving cubic eq. works', (tester) async {
      final bloc = PolynomialBloc(PolynomialType.quartic);
      var quarticTabName = '';

      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              quarticTabName = context.l10n.fourthDegree;

              return MultiBlocProvider(
                providers: [
                  BlocProvider<PolynomialBloc>.value(
                    value: bloc,
                  ),
                  BlocProvider<PlotZoomCubit>(
                    create: (_) => PlotZoomCubit(
                      minValue: 1,
                      maxValue: 10,
                      initial: 5,
                    ),
                  ),
                ],
                child: Scaffold(
                  body: BlocProvider<PolynomialBloc>.value(
                    value: bloc,
                    child: const PolynomialBody(),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Moving to the second page
      await tester.tap(find.text(quarticTabName));
      await tester.pumpAndSettle();

      // Data input
      final coeffA =
          find.byKey(const Key('PolynomialInputField-coefficient-0'));
      final coeffB =
          find.byKey(const Key('PolynomialInputField-coefficient-1'));
      final coeffC =
          find.byKey(const Key('PolynomialInputField-coefficient-2'));
      final coeffD =
          find.byKey(const Key('PolynomialInputField-coefficient-3'));
      final coeffE =
          find.byKey(const Key('PolynomialInputField-coefficient-4'));
      final solveButton = find.byKey(const Key('Polynomial-button-solve'));

      // Filling the forms
      await tester.enterText(coeffA, '-5');
      await tester.enterText(coeffB, '1/2');
      await tester.enterText(coeffC, '0');
      await tester.enterText(coeffD, '1');
      await tester.enterText(coeffE, 'e');

      // Making sure that there are no results
      expect(bloc.state, isA<PolynomialNone>());
      expect(find.byType(NoResults), findsOneWidget);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Solutions on the UI!
      expect(bloc.state, isA<PolynomialRoots>());
      expect(find.byType(NoResults), findsNothing);
      expect(find.byKey(const Key('PolynomialDiscriminant')), findsOneWidget);
      expect(find.byType(ComplexResultCard), findsNWidgets(5));
    });
  });
}
