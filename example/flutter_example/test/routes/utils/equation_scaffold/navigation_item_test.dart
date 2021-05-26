import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NavigationItem' widget", () {
    testWidgets('Making sure that default values are correct', (tester) async {
      const navigationItem = NavigationItem(
        title: 'Item title',
        content: SizedBox(),
      );

      expect(navigationItem.title, equals('Item title'));
      expect(navigationItem.content, isA<SizedBox>());
      expect(navigationItem.icon, isA<Icon>());
      expect(navigationItem.activeIcon, isA<Icon>());
      expect(navigationItem.props.length, equals(4));
    });
  });
}
