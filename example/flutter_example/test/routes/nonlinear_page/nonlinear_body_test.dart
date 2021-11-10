import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
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
  late final DropdownCubit dropdownCubit;

  setUpAll(() {
    registerFallbackValue(MockNonlinearEvent());
    registerFallbackValue(MockNonlinearState());

    dropdownCubit = MockDropdownCubit();
  });

  group("Testing the 'NonlinearBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NonlinearBloc>(
          create: (_) => NonlinearBloc(NonlinearType.singlePoint),
          child: const Scaffold(body: NonlinearBody()),
        ),
      ));

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(NonlinearDataInput), findsOneWidget);
      expect(find.byType(NonlinearResults), findsOneWidget);
    });

    testWidgets(
      'Making sure that the widget is responsive - small screens '
      'test',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<NonlinearBloc>(
            create: (_) => NonlinearBloc(NonlinearType.bracketing),
            child: const Scaffold(
              body: SizedBox(
                width: 800,
                child: NonlinearBody(),
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
      'Making sure that the widget is responsive - large screens '
      'test',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<NonlinearBloc>(
            create: (_) => NonlinearBloc(NonlinearType.singlePoint),
            child: const Scaffold(
              body: NonlinearBody(),
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
      when(() => dropdownCubit.state).thenReturn('Newton');
      final bloc = NonlinearBloc(NonlinearType.singlePoint);

      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NonlinearBloc>.value(
              value: bloc,
            ),
            BlocProvider<DropdownCubit>.value(
              value: dropdownCubit,
            ),
            BlocProvider<SliderCubit>(
              create: (_) => SliderCubit(
                minValue: 1,
                maxValue: 10,
                current: 5,
              ),
            ),
          ],
          child: Scaffold(
            body: BlocProvider<NonlinearBloc>.value(
              value: bloc,
              child: const NonlinearBody(),
            ),
          ),
        ),
      ));

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final paramInput = find.byKey(const Key('EquationInput-first-param'));
      final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

      // Filling the forms
      await tester.enterText(equationInput, 'x-3');
      await tester.enterText(paramInput, '3');

      // Making sure that there are no results
      expect(bloc.state, isA<NonlinearNone>());
      expect(find.byType(NoResults), findsOneWidget);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Solutions on the UI!
      expect(bloc.state, isA<NonlinearGuesses>());
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(RealResultCard), findsNWidgets(3));
    });
  });
}
