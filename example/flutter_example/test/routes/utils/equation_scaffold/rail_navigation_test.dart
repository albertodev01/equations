import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'RailNavigation' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNavigation(
            tabController: TabController(
              length: 2,
              vsync: const TestVSync(),
            ),
            fab: null,
            navigationItems: const [
              NavigationItem(title: 'Test 1', content: SizedBox()),
              NavigationItem(title: 'Test 2', content: SizedBox()),
            ],
            navigationIndex: ValueNotifier<int>(0),
            child: const RailNavigation(),
          ),
        ),
      );

      final finder = find.byType(RailNavigation);
      expect(finder, findsOneWidget);

      expect(find.byType(TabbedNavigationLayout), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);
    });

    testWidgets('Making sure that routes can be changed', (tester) async {
      final navigationIndex = ValueNotifier<int>(0);

      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNavigation(
            tabController: TabController(
              length: 2,
              vsync: const TestVSync(),
            ),
            fab: null,
            navigationItems: const [
              NavigationItem(title: 'Test 1', content: SizedBox()),
              NavigationItem(title: 'Test 2', content: SizedBox()),
            ],
            navigationIndex: navigationIndex,
            child: const RailNavigation(),
          ),
        ),
      );

      expect(navigationIndex.value, isZero);

      await tester.tap(find.text('Test 2'));
      await tester.pumpAndSettle();

      expect(navigationIndex.value, equals(1));
    });
  });

  group('Golden tests - RailNavigation', () {
    testWidgets('RailNavigation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(80, 350));

      await tester.pumpWidget(
        SizedBox(
          width: 200,
          height: 400,
          child: MockWrapper(
            child: InheritedNavigation(
              tabController: TabController(
                length: 2,
                vsync: const TestVSync(),
              ),
              fab: null,
              navigationItems: const [
                NavigationItem(title: 'Test 1', content: SizedBox()),
                NavigationItem(title: 'Test 2', content: SizedBox()),
              ],
              navigationIndex: ValueNotifier<int>(0),
              child: const RailNavigation(),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(RailNavigation),
        matchesGoldenFile('goldens/rail_navigation.png'),
      );
    });
  });
}
