import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

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
          child: BlocProvider<NavigationCubit>(
            create: (_) => NavigationCubit(),
            child: RailNavigation(
              tabController: controller,
              navigationItems: const [
                NavigationItem(
                  title: 'Test',
                  content: SizedBox(),
                ),
                NavigationItem(
                  title: 'Test',
                  content: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      final finder = find.byType(RailNavigation);
      expect(finder, findsOneWidget);

      expect(find.byType(TabbedNavigationLayout), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);

      final railNavigation = tester.widget(finder) as RailNavigation;
      expect(railNavigation.navigationItems.length, equals(2));
    });

    testGoldens('RailNavigation', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Rail Navigation Bar',
          SizedBox(
            width: 200,
            height: 400,
            child: MockWrapper(
              child: BlocProvider<NavigationCubit>(
                create: (_) => NavigationCubit(),
                child: RailNavigation(
                  tabController: controller,
                  navigationItems: const [
                    NavigationItem(
                      title: 'Test 1',
                      content: Icon(Icons.date_range),
                    ),
                    NavigationItem(
                      title: 'Test 2',
                      content: Icon(Icons.wb_auto_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(200, 500),
      );

      await screenMatchesGolden(tester, 'rail_navigation');
    });
  });
}
