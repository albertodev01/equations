import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'SizePicker' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNumberSwitcher(
            numberSwitcherState: NumberSwitcherState(
              min: 2,
              max: 4,
            ),
            child: const SizePicker(),
          ),
        ),
      );

      expect(find.byType(SizePicker), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Making sure that numbers can be changed', (tester) async {
      final state = NumberSwitcherState(
        min: 2,
        max: 4,
      );

      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNumberSwitcher(
            numberSwitcherState: state,
            child: const SizePicker(),
          ),
        ),
      );

      expect(state.state, equals(2));
      expect(find.text('2x2 matrix'), findsOneWidget);

      // Moving forward
      await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
      await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
      await tester.pump();

      expect(state.state, equals(4));

      // Moving back
      await tester.tap(find.byKey(const Key('SizePicker-Back-Button')));
      await tester.pump();

      expect(state.state, equals(3));
    });
  });

  group('Golden tests - SystemDropdownSelection', () {
    Widget mockSliderForGolder({int matrixSize = 1}) {
      final state = NumberSwitcherState(
        min: 1,
        max: 5,
      );

      for (var i = 1; i < matrixSize; ++i) {
        state.increase();
      }

      return MockWrapper(
        child: InheritedNumberSwitcher(
          numberSwitcherState: state,
          child: const SizePicker(),
        ),
      );
    }

    testWidgets('SizePicker - 1x1 matrix', (tester) async {
      await tester.pumpWidget(
        mockSliderForGolder(),
      );
      await expectLater(
        find.byType(SizePicker),
        matchesGoldenFile('goldens/size_picker_1.png'),
      );
    });

    testWidgets('SizePicker - 2x2 matrix', (tester) async {
      await tester.pumpWidget(
        mockSliderForGolder(
          matrixSize: 2,
        ),
      );
      await expectLater(
        find.byType(SizePicker),
        matchesGoldenFile('goldens/size_picker_2.png'),
      );
    });

    testWidgets('SizePicker - 3x3 matrix', (tester) async {
      await tester.pumpWidget(
        mockSliderForGolder(
          matrixSize: 3,
        ),
      );
      await expectLater(
        find.byType(SizePicker),
        matchesGoldenFile('goldens/size_picker_3.png'),
      );
    });

    testWidgets('SizePicker - 4x4 matrix', (tester) async {
      await tester.pumpWidget(
        mockSliderForGolder(
          matrixSize: 4,
        ),
      );
      await expectLater(
        find.byType(SizePicker),
        matchesGoldenFile('goldens/size_picker_4.png'),
      );
    });
  });
}
