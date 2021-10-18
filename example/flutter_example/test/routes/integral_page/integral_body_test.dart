import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  setUpAll(() {
    registerFallbackValue<IntegralEvent>(MockIntegralEvent());
    registerFallbackValue<IntegralState>(MockIntegralState());
  });

  group("Testing the 'IntegralBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<IntegralBloc>(
          create: (_) => IntegralBloc(),
          child: const Scaffold(
            body: IntegralBody(),
          ),
        ),
      ));

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(IntegralDataInput), findsOneWidget);
      expect(find.byType(IntegralResultsWidget), findsOneWidget);
    });

    testWidgets(
      'Making sure that the widget is responsive - small screens test',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<IntegralBloc>(
            create: (_) => IntegralBloc(),
            child: const Scaffold(
              body: SizedBox(
                width: 800,
                child: IntegralBody(),
              ),
            ),
          ),
        ));

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
      'Making sure that the widget is responsive - large screens test',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<IntegralBloc>(
            create: (_) => IntegralBloc(),
            child: const Scaffold(
              body: IntegralBody(),
            ),
          ),
        ));

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

    testWidgets('Making sure that solving equations works', (tester) async {
      final bloc = IntegralBloc();

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<IntegralBloc>.value(
          value: bloc,
          child: const Scaffold(
            body: IntegralBody(),
          ),
        ),
      ));

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
      final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

      // Filling the forms
      await tester.enterText(equationInput, 'x+2');
      await tester.enterText(lowerInput, '1');
      await tester.enterText(upperInput, '3');

      // Initial state
      expect(find.byType(NoResults), findsOneWidget);
      expect(bloc.state, equals(const IntegralNone()));

      // Evaluating the integral
      await tester.tap(find.byKey(const Key('Integral-button-solve')));
      await tester.pumpAndSettle();

      // Results
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(RealResultCard), findsOneWidget);
      expect(bloc.state, isA<IntegralResult>());
    });
  });
}
