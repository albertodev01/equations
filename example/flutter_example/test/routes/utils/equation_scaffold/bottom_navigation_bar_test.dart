import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'BottomNavigation' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(),
          child: const BottomNavigation(
            navigationItems: [
              NavigationItem(title: 'Test 1', content: SizedBox()),
              NavigationItem(title: 'Test 2', content: SizedBox()),
            ],
          ),
        ),
      ));

      final finder = find.byType(BottomNavigation);
      expect(finder, findsOneWidget);

      final bottomNavigation = tester.widget(finder) as BottomNavigation;
      expect(bottomNavigation.navigationItems.length, equals(2));
    });
  });
}
