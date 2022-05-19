import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../nonlinear_mock.dart';

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
      await tester.pumpWidget(
        mockNonlinearWidget(
          child: const NonlinearDropdownSelection(),
        ),
      );

      expect(find.byType(NonlinearDropdownSelection), findsOneWidget);
    });

    testWidgets(
      "Making sure that when the state is of type 'singlePoint' the dropdown "
      'only contains single point algorithms',
      (tester) async {
        await tester.pumpWidget(
          mockNonlinearWidget(
            child: const NonlinearDropdownSelection(),
          ),
        );

        await tester.tap(find.text('Newton'));
        await tester.pumpAndSettle();

        final widgetFinder = find.byType(NonlinearDropdownSelection);
        final state =
            tester.state(widgetFinder) as NonlinearDropdownSelectionState;

        expect(state.dropdownItems.length, equals(2));
        expect(
          state.dropdownItems.first.value,
          equals(NonlinearDropdownItems.newton),
        );
        expect(
          state.dropdownItems[1].value,
          equals(NonlinearDropdownItems.steffensen),
        );
      },
    );

    testWidgets(
      "Making sure that when the state is of type 'bracketing' the dropdown "
      'only contains bracketing algorithms',
      (tester) async {
        await tester.pumpWidget(
          mockNonlinearWidget(
            nonlinearType: NonlinearType.bracketing,
            dropdownValue: NonlinearDropdownItems.bisection.asString(),
            child: const NonlinearDropdownSelection(),
          ),
        );

        await tester.tap(find.text('Bisection'));
        await tester.pumpAndSettle();

        final widgetFinder = find.byType(NonlinearDropdownSelection);
        final state =
            tester.state(widgetFinder) as NonlinearDropdownSelectionState;

        expect(state.dropdownItems.length, equals(3));
        expect(
          state.dropdownItems.first.value,
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
        await tester.pumpWidget(
          mockNonlinearWidget(
            child: const NonlinearDropdownSelection(),
          ),
        );

        await tester.tap(find.text('Newton'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Steffensen').last);
        await tester.pumpAndSettle();
      },
    );
  });

  group('Golden tests - NonlinearDropdownSelection', () {
    testWidgets('NonlinearDropdownSelection - single point', (tester) async {
      await tester.pumpWidget(
        mockNonlinearWidget(
          child: const NonlinearDropdownSelection(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/dropdown_selection_single_point.png'),
      );
    });

    testWidgets('NonlinearDropdownSelection - bracketing', (tester) async {
      await tester.pumpWidget(
        mockNonlinearWidget(
          nonlinearType: NonlinearType.bracketing,
          dropdownValue: NonlinearDropdownItems.bisection.asString(),
          child: const NonlinearDropdownSelection(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/dropdown_selection_bracketing.png'),
      );
    });
  });
}
