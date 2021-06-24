import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'SizePicker' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NumberSwitcherCubit>(
          create: (_) => NumberSwitcherCubit(
            min: 2,
            max: 4,
          ),
          child: const SizePicker(),
        ),
      ));

      expect(find.byType(SizePicker), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Making sure that numbers can be changed', (tester) async {
      final numberSwitchCubit = NumberSwitcherCubit(
        min: 2,
        max: 4,
      );

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NumberSwitcherCubit>.value(
          value: numberSwitchCubit,
          child: const SizePicker(),
        ),
      ));

      expect(numberSwitchCubit.state, equals(2));

      // Moving forward
      await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
      await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
      await tester.pump();

      expect(numberSwitchCubit.state, equals(4));

      // Moving back
      await tester.tap(find.byKey(const Key('SizePicker-Back-Button')));
      await tester.pump();

      expect(numberSwitchCubit.state, equals(3));
    });
  });
}
