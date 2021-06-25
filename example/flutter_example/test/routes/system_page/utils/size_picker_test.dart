import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

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

    testGoldens('SizePicker', (tester) async {
      final numberSwitchCubit = NumberSwitcherCubit(
        min: 2,
        max: 4,
      );

      final builder = GoldenBuilder.column()
        ..addScenario(
          'VectorInput - 2x2',
          BlocProvider<NumberSwitcherCubit>.value(
            value: numberSwitchCubit,
            child: const SizePicker(),
          ),
        )
        ..addScenario(
          'VectorInput - 3x3',
          BlocProvider<NumberSwitcherCubit>.value(
            value: numberSwitchCubit..increase(),
            child: const SizePicker(),
          ),
        )
        ..addScenario(
          'VectorInput - 4v4',
          BlocProvider<NumberSwitcherCubit>.value(
            value: numberSwitchCubit..increase()..increase(),
            child: const SizePicker(),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(300, 300),
      );
      await screenMatchesGolden(tester, 'size_picker');
    });
  });
}
