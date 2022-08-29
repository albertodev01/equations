import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  late final TabController controller;

  setUpAll(() {
    controller = TabController(
      length: 2,
      vsync: const TestVSync(),
    );
  });

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
  });

  group('Golden tests - RailNavigation', () {
    testWidgets('RailNavigation', (tester) async {
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
