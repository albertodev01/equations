import 'package:equations_solver/blocs/expansion_cubit/expansion_cubit.dart';
import 'package:equations_solver/routes/utils/collapsible/collapsible.dart';
import 'package:equations_solver/routes/utils/collapsible/primary_region.dart';
import 'package:equations_solver/routes/utils/collapsible/secondary_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'Collapsible' widget.", () {
    testWidgets(
      "Making sure that 'Collapsible' can be rendered",
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: BlocProvider<ExpansionCubit>(
            create: (_) => ExpansionCubit(),
            child: const Collapsible(
              header: Text('Header'),
              content: Text('Contents'),
            ),
          ),
        ));

        expect(find.byType(PrimaryRegion), findsOneWidget);
        expect(find.byType(SecondaryRegion), findsOneWidget);
        expect(find.byType(SizeTransition), findsOneWidget);

        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Contents'), findsOneWidget);
      },
    );

    testWidgets("Making sure that 'Collapsible' is tappable", (tester) async {
      final bloc = ExpansionCubit();

      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<ExpansionCubit>.value(
          value: bloc,
          child: const Collapsible(
            header: Text('Header'),
            content: Text('Contents'),
          ),
        ),
      ));

      final sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      expect(bloc.state, isFalse);
      expect(sizeTransition.sizeFactor.value, isZero);

      // Running the animation
      await tester.tap(find.byType(PrimaryRegion));
      await tester.pumpAndSettle();

      // Making sure the secondary region is visible
      expect(bloc.state, isTrue);
      expect(sizeTransition.sizeFactor.value, equals(1));
    });

    testGoldens('Collapsible', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Closed',
          BlocProvider<ExpansionCubit>(
            create: (_) => ExpansionCubit(),
            child: const Collapsible(
              header: Text('Header'),
              content: Text('Contents'),
            ),
          ),
        )
        ..addScenario(
          'Opened',
          BlocProvider<ExpansionCubit>(
            create: (_) => ExpansionCubit(),
            child: const Collapsible(
              header: Text('Header'),
              content: Text('Contents'),
              initializeOpened: true,
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(150, 250),
      );
      await screenMatchesGolden(tester, 'collapsible');
    });
  });
}
