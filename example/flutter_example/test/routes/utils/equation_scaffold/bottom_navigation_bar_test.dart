import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'BottomNavigation' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: BlocProvider<NavigationCubit>(
            create: (_) => NavigationCubit(),
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

    testGoldens('BottomNavigationBar', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Bottom Navigation Bar',
          SizedBox(
            width: 500,
            height: 150,
            child: MockWrapper(
              child: BlocProvider<NavigationCubit>(
                create: (_) => NavigationCubit(),
                child: const BottomNavigation(
                  navigationItems: [
                    NavigationItem(title: 'Test 1', content: SizedBox()),
                    NavigationItem(title: 'Test 2', content: SizedBox()),
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
        surfaceSize: const Size(500, 300),
      );

      await screenMatchesGolden(tester, 'bottom_navigation_bar');
    });
  });
}
