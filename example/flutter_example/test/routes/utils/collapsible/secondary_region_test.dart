import 'package:equations_solver/routes/utils/collapsible/secondary_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PrimaryRegion' widget", () {
    testWidgets("Making sure SecondaryRegion 'SecondaryRegion' can be rendered",
        (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: SecondaryRegion(
          heightBetweenRegions: 10,
          child: Container(),
        ),
      ));

      expect(find.byType(SecondaryRegion), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}
