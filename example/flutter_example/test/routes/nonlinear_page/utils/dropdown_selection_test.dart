import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'DropdownSelection' widget", () {
    test("Testing the 'NonlinearDropdownItemsExt' extension method", () {
      expect(NonlinearDropdownItems.newton.asString(), equals('Newton'));
      expect(
        NonlinearDropdownItems.steffensen.asString(),
        equals('Steffensen'),
      );
      expect(NonlinearDropdownItems.bisection.asString(), equals('Bisection'));
      expect(NonlinearDropdownItems.secant.asString(), equals('Secant'));
      expect(NonlinearDropdownItems.brent.asString(), equals('Brent'));
    });

    test("Testing the 'StringExt' extension method", () {
      expect(
        'newton'.toNonlinearDropdownItems(),
        equals(NonlinearDropdownItems.newton),
      );
      expect(
        'steffensen'.toNonlinearDropdownItems(),
        equals(NonlinearDropdownItems.steffensen),
      );
      expect(
        'bisection'.toNonlinearDropdownItems(),
        equals(NonlinearDropdownItems.bisection),
      );
      expect(
        'secant'.toNonlinearDropdownItems(),
        equals(NonlinearDropdownItems.secant),
      );
      expect(
        'brent'.toNonlinearDropdownItems(),
        equals(NonlinearDropdownItems.brent),
      );
      expect(''.toNonlinearDropdownItems, throwsArgumentError);
    });

    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NonlinearBloc>(
              create: (_) => NonlinearBloc(NonlinearType.singlePoint),
            ),
            BlocProvider<DropdownCubit>(
              create: (_) => DropdownCubit(initialValue: 'Newton'),
            ),
          ],
          child: const Scaffold(
            body: NonlinearDropdownSelection(),
          ),
        ),
      ));

      expect(find.byType(NonlinearDropdownSelection), findsOneWidget);
    });

    testWidgets(
      "Making sure that when the bloc is of type 'singlePoint' the "
      'dropdown only contains single point algorithms',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NonlinearBloc>(
                create: (_) => NonlinearBloc(NonlinearType.singlePoint),
              ),
              BlocProvider<DropdownCubit>(
                create: (_) => DropdownCubit(initialValue: 'Newton'),
              ),
            ],
            child: const Scaffold(
              body: NonlinearDropdownSelection(),
            ),
          ),
        ));

        final dropdownFinder =
            find.byKey(const Key('Dropdown-Button-Selection'));
        expect(dropdownFinder, findsOneWidget);

        final widgetFinder = find.byType(NonlinearDropdownSelection);
        final state =
            tester.state(widgetFinder) as NonlinearDropdownSelectionState;

        expect(state.dropdownItems.length, equals(2));
        expect(
          state.dropdownItems[0].value,
          equals(NonlinearDropdownItems.newton),
        );
        expect(
          state.dropdownItems[1].value,
          equals(NonlinearDropdownItems.steffensen),
        );
      },
    );

    testWidgets(
      "Making sure that when the bloc is of type 'bracketing' the "
      'dropdown only contains single point algorithms',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NonlinearBloc>(
                create: (_) => NonlinearBloc(NonlinearType.bracketing),
              ),
              BlocProvider<DropdownCubit>(
                create: (_) => DropdownCubit(initialValue: 'Bisection'),
              ),
            ],
            child: const Scaffold(
              body: NonlinearDropdownSelection(),
            ),
          ),
        ));

        final dropdownFinder =
            find.byKey(const Key('Dropdown-Button-Selection'));
        expect(dropdownFinder, findsOneWidget);

        final widgetFinder = find.byType(NonlinearDropdownSelection);
        final state =
            tester.state(widgetFinder) as NonlinearDropdownSelectionState;

        expect(state.dropdownItems.length, equals(3));
        expect(
          state.dropdownItems[0].value,
          equals(NonlinearDropdownItems.bisection),
        );
        expect(
          state.dropdownItems[1].value,
          equals(NonlinearDropdownItems.secant),
        );
        expect(
          state.dropdownItems[2].value,
          equals(NonlinearDropdownItems.brent),
        );
      },
    );

    testWidgets(
      'Making sure that dropdown values can be changed',
      (tester) async {
        final cubit = DropdownCubit(initialValue: 'Newton');
        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NonlinearBloc>(
                create: (_) => NonlinearBloc(NonlinearType.singlePoint),
              ),
              BlocProvider<DropdownCubit>.value(
                value: cubit,
              ),
            ],
            child: const Scaffold(
              body: NonlinearDropdownSelection(),
            ),
          ),
        ));

        expect(cubit.state, equals('Newton'));
        await tester.tap(find.text('Newton'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Steffensen').last);
        await tester.pumpAndSettle();
        expect(cubit.state, equals('Steffensen'));
      },
    );

    testGoldens('DropdownSelection', (tester) async {
      final widget = SizedBox(
        width: 200,
        height: 200,
        child: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<NonlinearBloc>(
                create: (_) => NonlinearBloc(NonlinearType.bracketing),
              ),
              BlocProvider<DropdownCubit>(
                create: (_) => DropdownCubit(initialValue: 'Bisection'),
              ),
            ],
            child: const NonlinearDropdownSelection(),
          ),
        ),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 300),
      );
      await screenMatchesGolden(tester, 'dropdown_selection');
    });
  });
}
