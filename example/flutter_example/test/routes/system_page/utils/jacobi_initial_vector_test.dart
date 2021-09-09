import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/jacobi_initial_vector.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/bloc_mocks.dart';
import '../../mock_wrapper.dart';

void main() {
  late final DropdownCubit dropdownCubit;

  setUpAll(() {
    dropdownCubit = MockDropdownCubit();
  });

  group("Testing the 'JacobiVectorInput' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      when(() => dropdownCubit.state).thenReturn('jacobi');

      await tester.pumpWidget(MockWrapper(
        child: Scaffold(
          body: BlocProvider.value(
            value: dropdownCubit,
            child: JacobiVectorInput(
              controllers: [
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
              ],
              vectorSize: 2,
            ),
          ),
        ),
      ));

      expect(find.byType(JacobiVectorInput), findsOneWidget);
      expect(find.byType(VectorInput), findsOneWidget);
      expect(find.byType(SystemInputField), findsNWidgets(2));

      // Rebuild
      await tester.pumpWidget(MockWrapper(
        child: Scaffold(
          body: BlocProvider.value(
            value: dropdownCubit,
            child: JacobiVectorInput(
              controllers: [
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
              ],
              vectorSize: 4,
            ),
          ),
        ),
      ));

      expect(find.byType(SystemInputField), findsNWidgets(4));
    });

    testWidgets(
      'Making sure that nothing is rendered when the selected '
      'method is NOT Jacobi',
      (tester) async {
        when(() => dropdownCubit.state).thenReturn('SOR');

        await tester.pumpWidget(MockWrapper(
          child: Scaffold(
            body: BlocProvider.value(
              value: dropdownCubit,
              child: JacobiVectorInput(
                controllers: [
                  TextEditingController(),
                  TextEditingController(),
                  TextEditingController(),
                  TextEditingController(),
                ],
                vectorSize: 2,
              ),
            ),
          ),
        ));

        expect(find.byType(JacobiVectorInput), findsOneWidget);
        expect(find.byType(VectorInput), findsNothing);
        expect(find.byType(SystemInputField), findsNothing);
      },
    );
  });
}
