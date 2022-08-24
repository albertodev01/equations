import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation_widget.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'RailNavigationWidget' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNavigation(
            navigationIndex: ValueNotifier<int>(0),
            child: RailNavigationWidget(
              tabController: TabController(
                length: 2,
                vsync: const TestVSync(),
              ),
              navigationItems: const [
                NavigationItem(title: 'Test 1', content: SizedBox()),
                NavigationItem(title: 'Test 2', content: SizedBox()),
              ],
            ),
          ),
        ),
      );

      final finder = find.byType(RailNavigation);
      expect(finder, findsOneWidget);

      final bottomNavigation = tester.widget(finder) as RailNavigation;
      expect(bottomNavigation.navigationItems.length, equals(2));

      expect(find.byType(TabbedNavigationLayout), findsOneWidget);
      expect(find.byType(RailNavigation), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });

  group('Golden tests - RailNavigationWidget', () {
    testWidgets('RailNavigationWidget', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNavigation(
            navigationIndex: ValueNotifier<int>(0),
            child: RailNavigationWidget(
              tabController: TabController(
                length: 2,
                vsync: const TestVSync(),
              ),
              navigationItems: const [
                NavigationItem(title: 'Test 1', content: SizedBox()),
                NavigationItem(title: 'Test 2', content: SizedBox()),
              ],
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(RailNavigationWidget),
        matchesGoldenFile('goldens/rail_navigation_widget.png'),
      );
    });
  });
}