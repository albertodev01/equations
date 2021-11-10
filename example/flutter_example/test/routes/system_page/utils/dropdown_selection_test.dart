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
