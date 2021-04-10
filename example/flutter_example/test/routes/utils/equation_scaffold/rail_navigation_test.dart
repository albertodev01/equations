import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'RailNavigation' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(),
          child: const RailNavigation(
            navigationItems: [
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
      ));

      final finder = find.byType(RailNavigation);
      expect(finder, findsOneWidget);

      expect(find.byType(TabbedNavigationLayout), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);

      final railNavigation = tester.widget(finder) as RailNavigation;
      expect(railNavigation.navigationItems.length, equals(2));
    });
  });
}
