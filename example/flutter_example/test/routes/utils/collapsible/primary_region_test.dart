import 'package:equations_solver/routes/utils/collapsible/primary_region.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PrimaryRegion' widget", () {
    testWidgets(
      "Making sure that 'PrimaryRegion' can be rendered",
      (tester) async {
        final controller = AnimationController(
          vsync: const TestVSync(),
          duration: const Duration(milliseconds: 100),
        );

        final animation = Tween<double>(
          begin: 0,
          end: 3.18,
        ).animate(controller);

        await tester.pumpWidget(MockWrapper(
          child: PrimaryRegion(
            animation: animation,
            child: Container(),
          ),
        ));

        expect(find.byType(PrimaryRegion), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(ArrowUpSvg), findsOneWidget);
        expect(
          find.byKey(const Key('PrimaryRegion-AnimatedBuilder')),
          findsOneWidget,
        );

        // Animation test
        controller.forward();
        await tester.pumpAndSettle();

        expect(animation.value, equals(3.18));
      },
    );
  });
}
