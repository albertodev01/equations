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
    });

    testWidgets(
      'Making sure that objects can correctly be compared',
      (tester) async {
        const child = SizedBox();
        const navigationItem = NavigationItem(
          title: 'Item title',
          content: child,
        );

        expect(
          const NavigationItem(
            title: 'Item title',
            content: child,
          ),
          equals(navigationItem),
        );

        expect(
          navigationItem,
          equals(
            const NavigationItem(
              title: 'Item title',
              content: child,
            ),
          ),
        );

        expect(
          const NavigationItem(
                title: 'Item title',
                content: child,
              ) ==
              navigationItem,
          isTrue,
        );

        expect(
          navigationItem ==
              const NavigationItem(
                title: 'Item title',
                content: child,
              ),
          isTrue,
        );

        expect(
          navigationItem ==
              const NavigationItem(
                title: 'Item title',
                content: SizedBox(),
              ),
          isFalse,
        );

        expect(
          navigationItem ==
              const NavigationItem(
                title: 'Item',
                content: SizedBox(),
              ),
          isFalse,
        );

        expect(
          navigationItem.hashCode,
          equals(
            const NavigationItem(
              title: 'Item title',
              content: child,
            ).hashCode,
          ),
        );
      },
    );
  });
}
