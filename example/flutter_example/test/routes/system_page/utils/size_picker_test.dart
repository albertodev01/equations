import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/models/system_text_controllers/system_text_controllers.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
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
            child: const SizePicker(
              isInOtherPage: true,
            ),
          ),
        ),
      );

      expect(find.byType(SizePicker), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets(
      'Making sure that numbers can be changed in Others page',
      (tester) async {
        final state = NumberSwitcherState(
          min: 1,
          max: 4,
        );

        // This is required to ensure that no exceptions are thrown when the
        // "SizePicker" clears the state and the controllers of the "Other" page
        await tester.pumpWidget(
          MockWrapper(
            child: InheritedOther(
              otherState: OtherState(),
              child: InheritedTextControllers(
                textControllers: const [],
                child: InheritedNumberSwitcher(
                  numberSwitcherState: state,
                  child: const SizePicker(
                    isInOtherPage: true,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(state.state, equals(1));
        expect(find.text('1x1 matrix'), findsOneWidget);

        // Moving forward
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.pump();

        expect(find.text('3x3 matrix'), findsOneWidget);
        expect(state.state, equals(3));

        // Moving back
        await tester.tap(find.byKey(const Key('SizePicker-Back-Button')));
        await tester.pump();

        expect(find.text('2x2 matrix'), findsOneWidget);
        expect(state.state, equals(2));
      },
    );

    testWidgets(
      'Making sure that numbers can be changed in Others page',
      (tester) async {
        final state = NumberSwitcherState(
          min: 1,
          max: 4,
        );

        // This is required to ensure that no exceptions are thrown when the
        // "SizePicker" clears the state and the controllers of the "Other" page
        await tester.pumpWidget(
          MockWrapper(
            child: InheritedSystem(
              systemState: SystemState(SystemType.rowReduction),
              child: InheritedSystemControllers(
                systemTextControllers: SystemTextControllers(
                  jacobiControllers: const [],
                  vectorControllers: const [],
                  matrixControllers: const [],
                  wSorController: TextEditingController(),
                ),
                child: InheritedNumberSwitcher(
                  numberSwitcherState: state,
                  child: const SizePicker(
                    isInOtherPage: false,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(state.state, equals(1));
        expect(find.text('1x1 matrix'), findsOneWidget);

        // Moving forward
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.tap(find.byKey(const Key('SizePicker-Forward-Button')));
        await tester.pump();

        expect(find.text('3x3 matrix'), findsOneWidget);
        expect(state.state, equals(3));

        // Moving back
        await tester.tap(find.byKey(const Key('SizePicker-Back-Button')));
        await tester.pump();

        expect(find.text('2x2 matrix'), findsOneWidget);
        expect(state.state, equals(2));
      },
    );
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
        child: InheritedOther(
          otherState: OtherState(),
          child: InheritedTextControllers(
            textControllers: const [],
            child: InheritedNumberSwitcher(
              numberSwitcherState: state,
              child: const SizePicker(
                isInOtherPage: true,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('SizePicker - 1x1 matrix', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 60));

      await tester.pumpWidget(
        mockSliderForGolder(),
      );
      await expectLater(
        find.byType(SizePicker),
        matchesGoldenFile('goldens/size_picker_1.png'),
      );
    });

    testWidgets('SizePicker - 2x2 matrix', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 60));

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
      await tester.binding.setSurfaceSize(const Size(350, 60));

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
      await tester.binding.setSurfaceSize(const Size(350, 60));

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
