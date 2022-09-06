import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_widget.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'BottomNavigationWidget' widget", () {
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
            child: const BottomNavigationWidget(),
          ),
        ),
      );

      final finder = find.byType(BottomNavigation);
      expect(finder, findsOneWidget);

      final bottomNavigation = tester.widget(finder) as BottomNavigation;
      expect(bottomNavigation.navigationItems.length, equals(2));

      expect(find.byType(TabbedNavigationLayout), findsOneWidget);
      expect(find.byType(BottomNavigation), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });

  group('Golden tests - BottomNavigationWidget', () {
    testWidgets('BottomNavigationWidget', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 500));

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
            child: const BottomNavigationWidget(),
          ),
        ),
      );
      await expectLater(
        find.byType(BottomNavigation),
        matchesGoldenFile('goldens/bottom_navigation_widget.png'),
      );
    });
  });
}
