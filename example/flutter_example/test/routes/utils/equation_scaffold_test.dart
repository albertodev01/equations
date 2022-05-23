import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  late final List<NavigationItem> navigationItems;

  setUpAll(() {
    navigationItems = const [
      NavigationItem(
        title: 'Test',
        content: SizedBox(),
      ),
      NavigationItem(
        title: 'Test',
        content: SizedBox(),
      ),
    ];
  });

  group("Testing the 'EquationScaffold' widget", () {
    testWidgets(s
      'Making sure that the scaffold can be rendered',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: EquationScaffold(
              body: SizedBox(),
            ),
          ),
        );

        expect(find.byKey(const Key('ScaffoldBackground')), findsOneWidget);
        expect(find.byKey(const Key('ScaffoldExtraBackground')), findsNothing);

        final finder = find.byType(EquationScaffold);
        expect(finder, findsOneWidget);

        final scaffold = tester.firstWidget(finder) as EquationScaffold;
        expect(scaffold.body, isNotNull);
        expect(scaffold.fab, isNull);
        expect(scaffold.navigationItems.length, isZero);
      },
    );

    testWidgets(
      'Making sure that the navigation scaffold can be rendered',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: EquationScaffold.navigation(
              navigationItems: navigationItems,
            ),
          ),
        );

        expect(find.byKey(const Key('ScaffoldBackground')), findsOneWidget);
        expect(find.byKey(const Key('ScaffoldExtraBackground')), findsNothing);

        expect(find.byType(RailNavigation), findsNothing);

        final finder = find.byType(EquationScaffold);
        expect(finder, findsOneWidget);

        final scaffold = tester.firstWidget(finder) as EquationScaffold;
        expect(scaffold.fab, isNull);
        expect(scaffold.navigationItems.length, equals(2));
      },
    );

    testWidgets(
      'Making sure that the rail navigation appears when the '
      'screen is wide (web & desktop platforms)',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        await tester.pumpWidget(
          MockWrapper(
            child: EquationScaffold.navigation(
              navigationItems: navigationItems,
            ),
          ),
        );

        expect(
          find.byKey(const Key('ScaffoldBackground')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('ScaffoldExtraBackground')),
          findsOneWidget,
        );
        expect(find.byType(RailNavigation), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the navigation scaffold, when there are no '
      'navigation items, throws an assertion error',
      (tester) async {
        expect(
          () => EquationScaffold.navigation(
            navigationItems: const [],
          ),
          throwsAssertionError,
        );
      },
    );
  });
}
