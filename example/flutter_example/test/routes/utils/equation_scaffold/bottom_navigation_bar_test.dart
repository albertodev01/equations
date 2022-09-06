import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'BottomNavigation' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNavigation(
            tabController: TabController(
              length: 2,
              vsync: const TestVSync(),
            ),
            fab: null,
            navigationItems: const [],
            navigationIndex: ValueNotifier<int>(0),
            child: const BottomNavigation(
              navigationItems: [
                NavigationItem(title: 'Test 1', content: SizedBox()),
                NavigationItem(title: 'Test 2', content: SizedBox()),
              ],
            ),
          ),
        ),
      );

      final finder = find.byType(BottomNavigation);
      expect(finder, findsOneWidget);

      final bottomNavigation = tester.widget(finder) as BottomNavigation;
      expect(bottomNavigation.navigationItems.length, equals(2));
    });
  });

  group('Golden tests - BottomNavigation', () {
    testWidgets('BottomNavigation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 80));

      await tester.pumpWidget(
        MockWrapper(
          child: InheritedNavigation(
            tabController: TabController(
              length: 2,
              vsync: const TestVSync(),
            ),
            fab: null,
            navigationItems: const [],
            navigationIndex: ValueNotifier<int>(0),
            child: const BottomNavigation(
              navigationItems: [
                NavigationItem(
                  title: 'Test 1',
                  content: Text('Page 1'),
                ),
                NavigationItem(
                  title: 'Test 2',
                  content: Text('Page 2'),
                ),
              ],
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(BottomNavigation),
        matchesGoldenFile('goldens/bottom_navigation.png'),
      );
    });
  });
}
