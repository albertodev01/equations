import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/bloc_mocks.dart';
import '../../mock_wrapper.dart';

void main() {
  late final SystemBloc systemBloc;
  late final DropdownCubit dropdownCubit;

  setUpAll(() {
    registerFallbackValue(MockSystemEvent());
    registerFallbackValue(MockSystemState());

    systemBloc = MockSystemBloc();
    dropdownCubit = MockDropdownCubit();
  });

  group("Testing the 'SystemDropdownSelection' widget", () {
    test("Testing the 'SystemDropdownItemsExt' extension method", () {
      expect(SystemDropdownItems.lu.asString(), equals('LU'));
      expect(SystemDropdownItems.cholesky.asString(), equals('Cholesky'));
      expect(SystemDropdownItems.sor.asString(), equals('SOR'));
      expect(SystemDropdownItems.jacobi.asString(), equals('Jacobi'));
    });

    test("Testing the 'StringExt' extension method", () {
      expect(
        'lu'.toSystemDropdownItems(),
        equals(SystemDropdownItems.lu),
      );
      expect(
        'cholesky'.toSystemDropdownItems(),
        equals(SystemDropdownItems.cholesky),
      );
      expect(
        'sor'.toSystemDropdownItems(),
        equals(SystemDropdownItems.sor),
      );
      expect(
        'jacobi'.toSystemDropdownItems(),
        equals(SystemDropdownItems.jacobi),
      );
      expect(''.toSystemDropdownItems, throwsArgumentError);
    });

    testWidgets(
      'Making sure that the widget shows no dropdown when row '
      'reduction type is selected',
      (tester) async {
        when(() => systemBloc.systemType).thenReturn(SystemType.rowReduction);
        when(() => dropdownCubit.state).thenReturn('');

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SystemBloc>.value(value: systemBloc),
              BlocProvider<DropdownCubit>.value(value: dropdownCubit),
            ],
            child: const SystemDropdownSelection(),
          ),
        ));

        expect(find.byType(SystemDropdownSelection), findsOneWidget);
        expect(
          find.byKey(const Key('System-Dropdown-Button-Selection')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that the widget shows the dropdown when the '
      'factorization type is selected',
      (tester) async {
        when(() => systemBloc.systemType).thenReturn(SystemType.factorization);
        when(() => dropdownCubit.state).thenReturn('LU');

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SystemBloc>.value(value: systemBloc),
              BlocProvider<DropdownCubit>.value(value: dropdownCubit),
            ],
            child: const SystemDropdownSelection(),
          ),
        ));

        expect(find.byType(SystemDropdownSelection), findsOneWidget);
        expect(
          find.byKey(const Key('System-Dropdown-Button-Selection')),
          findsOneWidget,
        );
        expect(find.text('LU'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the widget shows the dropdown when the '
      'iterative type is selected',
      (tester) async {
        when(() => systemBloc.systemType).thenReturn(SystemType.iterative);
        when(() => dropdownCubit.state).thenReturn('SOR');

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SystemBloc>.value(value: systemBloc),
              BlocProvider<DropdownCubit>.value(value: dropdownCubit),
            ],
            child: const SystemDropdownSelection(),
          ),
        ));

        expect(find.byType(SystemDropdownSelection), findsOneWidget);
        expect(
          find.byKey(const Key('System-Dropdown-Button-Selection')),
          findsOneWidget,
        );
        expect(find.text('SOR'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that dropdown values can be changed',
      (tester) async {
        final cubit = DropdownCubit(initialValue: 'LU');

        await tester.pumpWidget(MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SystemBloc>(
                create: (_) => SystemBloc(SystemType.factorization),
              ),
              BlocProvider<DropdownCubit>.value(
                value: cubit,
              ),
            ],
            child: const Scaffold(
              body: SystemDropdownSelection(),
            ),
          ),
        ));

        expect(cubit.state, equals('LU'));
        await tester.tap(find.text('LU'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cholesky').last);
        await tester.pumpAndSettle();
        expect(cubit.state, equals('Cholesky'));
      },
    );

    testGoldens('SystemDropdownSelection', (tester) async {
      when(() => systemBloc.systemType).thenReturn(SystemType.iterative);
      when(() => dropdownCubit.state).thenReturn('SOR');

      final builder = GoldenBuilder.column()
        ..addScenario(
          'SystemDropdownSelection',
          SizedBox(
            width: 400,
            height: 250,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SystemBloc>.value(value: systemBloc),
                BlocProvider<DropdownCubit>.value(value: dropdownCubit),
              ],
              child: const SystemDropdownSelection(),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(400, 350),
      );
      await screenMatchesGolden(tester, 'system_dropdown_selection');
    });
  });
}
