import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/sor_relaxation_factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/bloc_mocks.dart';
import '../../mock_wrapper.dart';

void main() {
  late final DropdownCubit dropdownCubit;

  setUpAll(() {
    dropdownCubit = MockDropdownCubit();
  });

  group("Testing the 'RelaxationFactorInput' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      when(() => dropdownCubit.state).thenReturn('SOR');

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<DropdownCubit>.value(
          value: dropdownCubit,
          child: RelaxationFactorInput(
            textEditingController: TextEditingController(),
          ),
        ),
      ));

      expect(find.byType(RelaxationFactorInput), findsOneWidget);
      expect(find.byType(SystemInputField), findsOneWidget);
    });

    testWidgets(
        'Making sure that the widget does NOT show an input field '
        "when the system solving algorithm isn't SOR", (tester) async {
      when(() => dropdownCubit.state).thenReturn('Jacobi');

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<DropdownCubit>.value(
          value: dropdownCubit,
          child: RelaxationFactorInput(
            textEditingController: TextEditingController(),
          ),
        ),
      ));

      expect(find.byType(RelaxationFactorInput), findsOneWidget);
      expect(find.byType(SystemInputField), findsNothing);
    });

    testGoldens('RelaxationFactorInput', (tester) async {
      when(() => dropdownCubit.state).thenReturn('SOR');

      final builder = GoldenBuilder.column()
        ..addScenario(
          'RelaxationFactorInput',
          SizedBox(
            width: 400,
            height: 250,
            child: MockWrapper(
              child: BlocProvider<DropdownCubit>.value(
                value: dropdownCubit,
                child: RelaxationFactorInput(
                  textEditingController: TextEditingController(),
                ),
              ),
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
      await screenMatchesGolden(tester, 'relaxation_factor_input');
    });
  });
}
